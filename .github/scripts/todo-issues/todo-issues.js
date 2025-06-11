#!/usr/bin/env node

const { execSync } = require('child_process');
const { Octokit } = require('@octokit/rest');

// Load environment variables
const token = process.env.GH_TOKEN;
const repoSlug = process.env.GITHUB_REPOSITORY;
const sha = process.env.GITHUB_SHA;
const prNumber = process.env.PR_NUMBER;
const prUrl = process.env.PR_URL;
const baseRef = process.env.GITHUB_BASE_REF;

if (!token || !repoSlug || !sha || !prNumber || !prUrl || !baseRef) {
  console.error('Missing required environment variables.');
  process.exit(1);
}

const [owner, repo] = repoSlug.split('/');
const octokit = new Octokit({ auth: token });


// Fetch base and compute unified diff
execSync(`git fetch origin ${baseRef}`);
const diff = execSync(`git diff origin/${baseRef} --unified=0`).toString();
const lines = diff.split('\n');

// Pre-scan additions to detect updates
const addedSet = new Set();
for (const raw of lines) {
  // Only consider added content lines (unified diff) not file headers
  if (raw.startsWith('+ ') && !raw.startsWith('+++ ')) {
    const match = raw.match(/^\+\s*(?:\/\/|#|\/\*|<!--)\s*TODO[: ]*(.*)$/);
    if (match) addedSet.add(match[1].trim());
  }
}

let currentFile = null;
let newLineNum = null;

(async () => {
  for (const raw of lines) {
    // Track file path (diff header)
    if (raw.startsWith('diff --git')) {
      const m = raw.match(/^diff --git a\/.* b\/(.+)$/);
      if (m) currentFile = m[1];
      continue;
    }
    // Track new-line from hunk header
    const hunk = raw.match(/^@@ .* \+(\d+)(?:,\d+)? @@/);
    if (hunk) {
      newLineNum = parseInt(hunk[1], 10);
      continue;
    }

    let oldTxt

    // Handle removed TODOs (< hunk removal) only if not also added
    if (raw.startsWith('-')) {
      console.log(raw)
      const m = raw.match(/^\-\s*(?:\/\/|#|\/\*|<!--)\s*TODO[: ]*(.*)$/);
      console.log(m)
      if (m) {
        oldTxt = m[1].trim();
        if (!addedSet.has(oldTxt)) {
          const { data } = await octokit.issues.listForRepo({ owner, repo, state: 'open', search: oldTxt });
          const issue = data.find(i => !i.pull_request);
          if (issue) {
            await octokit.issues.createComment({ owner, repo, issue_number: issue.number,
              body: `⚠️ The TODO \`${oldTxt}\` was removed in PR ${prUrl} (#${prNumber}); please review if this issue can now be closed.`
            });
            console.log(`Commented removal on #${issue.number}`);
          }
        }
      }
      continue;
    }

    // Handle added TODOs (+ hunk addition)
    if (raw.startsWith('+') ) {
      console.log(raw)
      const m = raw.match(/^\+\s*(?:\/\/|#|\/\*|<!--)\s*TODO[: ]*(.*)$/);
      console.log(m)
      if (!m) continue;
      const newTxt = m[1].trim();
      // find true line
      try {
        const g = execSync(`grep -n -F '${newTxt}' ${currentFile}`).toString().split(':');
        newLineNum = parseInt(g[0], 10);
      } catch {}
      const url = `https://github.com/${owner}/${repo}/blob/${sha}/${currentFile}#L${newLineNum}`;
      const title = `TODO in ${currentFile}:${newLineNum} – ${newTxt}`;

      // match by old text first if removal seen
      const searchTerm = oldTxt || newTxt;

      const { data } = await octokit.issues.listForRepo({ owner, repo, state: 'open', search: searchTerm });
      const issue = data.find(i => !i.pull_request);
      if (issue) {
        // update existing
        const { data: full } = await octokit.issues.get({ owner, repo, issue_number: issue.number });
        if (full.body.includes(prUrl)) {
          await octokit.issues.update({ owner, repo, issue_number: issue.number, title,
            body: `🆕 Found TODO in file [${currentFile}:${newLineNum}](${url}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
          });
        } else {
          await octokit.issues.createComment({ owner, repo, issue_number: issue.number,
            body: `🔄 Updated TODO: <blockquote>${newTxt}</blockquote>Location: [${currentFile}:${newLineNum}](${url})<br/>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
          });
        }
        console.log(`Handled existing #${issue.number}`);
      } else {
        // create new
        const { data: ni } = await octokit.issues.create({ owner, repo, title,
          body: `🆕 Found TODO in file [${currentFile}:${newLineNum}](${url}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`,
          labels: ['code-todo'],
        });
        console.log(`Created #${ni.number}`);
        console.log(`::warning file=${currentFile},line=${newLineNum},title=New TODO::A new TODO '${newTxt}' was added in PR #${prNumber}; see ${ni.html_url}`);
      }
      continue;
    }
  }
})();
