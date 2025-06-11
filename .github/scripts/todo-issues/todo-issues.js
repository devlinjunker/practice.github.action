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
const diff = execSync(`git diff origin/${baseRef}`).toString();
const lines = diff.split('\n');

// Pre-scan additions to detect updates
const addedSet = new Set();
for (const raw of lines) {
  if (raw.startsWith('+ ') && !raw.startsWith('+++ ')) {
    const m = raw.match(/^\+\s*(?:\/\/|#|\/\*|<!--)\s*TODO[: ]*(.*)$/);
    if (m) addedSet.add(m[1].trim());
  }
}

// Build hunk blocks with file context
const hunks = [];
let currentFile = null;
let currentHunk = null;
for (const raw of lines) {
  if (raw.startsWith('diff --git')) {
    const m = raw.match(/^diff --git a\/.* b\/(.+)$/);
    if (m) currentFile = m[1];
    currentHunk = null;
    continue;
  }
  const hunkMatch = raw.match(/^@@ .* \+(\d+)(?:,\d+)? @@/);
  if (hunkMatch && currentFile) {
    const newLineStart = parseInt(hunkMatch[1], 10);
    currentHunk = { file: currentFile, newLineStart, lines: [] };
    hunks.push(currentHunk);
    continue;
  }
  if (currentHunk) {
    currentHunk.lines.push(raw);
  }
}

(async () => {
  for (const hunk of hunks) {
    const { file, newLineStart, lines: hunkLines } = hunk;
    const removed = [];
    const added = [];
    hunkLines.forEach(line => {
      let m;
      if ((m = line.match(/^\-\s*(?:\/\/|#|\/\*|<!--)\s*TODO[: ]*(.*)$/))) {
        removed.push(m[1].trim());
      } else if ((m = line.match(/^\+\s*(?:\/\/|#|\/\*|<!--)\s*TODO[: ]*(.*)$/))) {
        added.push(m[1].trim());
      }
    });

    // Modified TODOs: presence of both added and removed indicates modification
    if (removed.length && added.length) {
      for (let i = 0; i < added.length; i++) {
        const oldTxt = removed[i] || removed[0];
        const newTxt = added[i];
        let newLine = newLineStart;
        try {
          const grep = execSync(`grep -n -F '${newTxt}' ${file}`).toString().split(':');
          newLine = parseInt(grep[0], 10);
        } catch {}
        const url = `https://github.com/${owner}/${repo}/blob/${sha}/${file}#L${newLine}`;
        const title = `TODO in ${file}:${newLine} – ${newTxt}`;
        const { data: issuesRaw } = await octokit.issues.listForRepo({ owner, repo, state: 'open', search: oldTxt });
        const issue = issuesRaw.find(i => !i.pull_request);
        if (issue) {
          const { data: full } = await octokit.issues.get({ owner, repo, issue_number: issue.number });
          if (full.body.includes(prUrl)) {
            await octokit.issues.update({ owner, repo, issue_number: issue.number, title,
              body: `🆕 Found TODO in file [${file}:${newLine}](${url}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
            });
          } else {
            await octokit.issues.createComment({ owner, repo, issue_number: issue.number,
              body: `🔄 Updated TODO: <blockquote>${newTxt}</blockquote>Location: [${file}:${newLine}](${url})<br/>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
            });
          }
          console.log(`Modified issue #${issue.number}`);
        }
      }
    } else {
      // Pure removals: only removals not in addedSet
      for (const oldTxt of removed) {
        if (!addedSet.has(oldTxt)) {
          const { data: issuesRaw } = await octokit.issues.listForRepo({ owner, repo, state: 'open', search: oldTxt });
          const issue = issuesRaw.find(i => !i.pull_request);
          if (issue) {
            await octokit.issues.createComment({ owner, repo, issue_number: issue.number,
              body: `⚠️ The TODO \`${oldTxt}\` was removed in PR ${prUrl} (#${prNumber}); please review if this issue can now be closed.`
            });
            console.log(`Removed comment on #${issue.number}`);
          }
        }
      }
      // Pure additions: handle each added TODO and emit warning
      for (const newTxt of added) {
        let newLine = newLineStart;
        try {
          const grep = execSync(`grep -n -F '${newTxt}' ${file}`).toString().split(':');
          newLine = parseInt(grep[0], 10);
        } catch {}
        const url = `https://github.com/${owner}/${repo}/blob/${sha}/${file}#L${newLine}`;
        const title = `TODO in ${file}:${newLine} – ${newTxt}`;
        const { data: issuesRaw } = await octokit.issues.listForRepo({ owner, repo, state: 'open', search: newTxt });
        const issue = issuesRaw.find(i => !i.pull_request);
        if (issue) {
          const { data: full } = await octokit.issues.get({ owner, repo, issue_number: issue.number });
          if (full.body.includes(prUrl)) {
            await octokit.issues.update({ owner, repo, issue_number: issue.number, title,
              body: `🆕 Found TODO in file [${file}:${newLine}](${url}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
            });
          } else {
            await octokit.issues.createComment({ owner, repo, issue_number: issue.number,
              body: `🔄 Updated TODO: <blockquote>${newTxt}</blockquote>Location: [${file}:${newLine}](${url})<br/>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
            });
          }
          console.log(`Handled existing #${issue.number}`);
        } else {
          const { data: ni } = await octokit.issues.create({ owner, repo, title,
            body: `🆕 Found TODO in file [${file}:${newLine}](${url}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`,
            labels: ['code-todo'],
          });
          console.log(`Created #${ni.number}`);
          // Warning for pure additions
          console.log(`::warning file=${file},line=${newLine},title=New TODO::A new TODO '${newTxt}' was added in PR #${prNumber}; see ${ni.html_url}`);
        }
      }
    }
  }
})();
