#!/usr/bin/env node

const { execSync } = require('child_process');
const { Octokit } = require('@octokit/rest');

// Load environment variables
const token = process.env.GH_TOKEN;
const repoSlug = process.env.GITHUB_REPOSITORY;  // e.g. owner/repo
const sha = process.env.GITHUB_SHA;
const prNumber = process.env.PR_NUMBER;
const prUrl = process.env.PR_URL;
const baseRef = process.env.GITHUB_BASE_REF;  // ensure this is set in the workflow

if (!token || !repoSlug || !sha || !prNumber || !prUrl || !baseRef) {
  console.error('Missing required environment variables.');
  process.exit(1);
}

const [owner, repo] = repoSlug.split('/');
const octokit = new Octokit({ auth: token });

// Track issues we've updated this run
const updatedIssues = new Set();

// Fetch base branch for diff
execSync(`git fetch origin ${baseRef}`);
const diff = execSync(`git diff origin/${baseRef} --unified=0`).toString();
const lines = diff.split('\n');

let currentFile = null;
let newLineNum = null;

(async () => {
  for (const raw of lines) {
    // Track file path
    if (raw.startsWith('diff --git')) {
      const match = raw.match(/^diff --git a\/.* b\/(.+)$/);
      if (match) currentFile = match[1];
      continue;
    }
    // Track new-line number
    const hunkMatch = raw.match(/^@@ .* \+(\d+)(?:,\d+)? @@/);
    if (hunkMatch) {
      newLineNum = parseInt(hunkMatch[1], 10);
      continue;
    }

    // Handle additions first
    if (/^\+\s*(\/\/|#|\/\*|<!--)\s*TODO/.test(raw)) {
      const newTxt = raw.replace(/^\+.*TODO[: ]*/, '').trim();
      // Find actual line if file exists
      try {
        const grep = execSync(`grep -n -F '${newTxt}' ${currentFile}`).toString().split(':');
        newLineNum = parseInt(grep[0], 10);
      } catch {
        // leave newLineNum from hunk
      }
      const locationUrl = `https://github.com/${owner}/${repo}/blob/${sha}/${currentFile}#L${newLineNum}`;
      const title = `TODO in ${currentFile}:${newLineNum} – ${newTxt}`;

      // Search for existing open issues (exclude pull requests)
      const { data: allIssues } = await octokit.issues.listForRepo({
        owner,
        repo,
        state: 'open',
        search: newTxt,
      });
      const issues = allIssues.filter(issue => !issue.pull_request);
      const existing = issues.length ? issues[0].number : null;

      if (existing) {
        // Fetch existing issue body
        const { data: issue } = await octokit.issues.get({ owner, repo, issue_number: existing });
        if (issue.body.includes(prUrl)) {
          // Overwrite body as new
          await octokit.issues.update({
            owner,
            repo,
            issue_number: existing,
            title,
            body: `🆕 Found TODO in file [${currentFile}:${newLineNum}](${locationUrl}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
          });
        } else {
          // Comment update
          await octokit.issues.createComment({
            owner,
            repo,
            issue_number: existing,
            body: `🔄 Updated TODO: ${newTxt}<br/>Location: [${currentFile}:${newLineNum}](${locationUrl})<br/>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`
          });
        }
        updatedIssues.add(existing);
        console.log(`Updated issue #${existing}`);
      } else {
        // Create new issue
        const { data: newIssue } = await octokit.issues.create({
          owner,
          repo,
          title,
          body: `🆕 Found TODO in file [${currentFile}:${newLineNum}](${locationUrl}):<br/><blockquote>${newTxt}</blockquote>PR: ${prUrl} (#${prNumber})<br/>Commit: ${sha}`,
          labels: ['code-todo'],
        });
        console.log(`Created issue #${newIssue.number}`);
      }
      continue;
    }

    // Handle removals (only if not updated above)
    if (/^-\s*(\/\/|#|\/\*|<!--)\s*TODO/.test(raw)) {
      const oldTxt = raw.replace(/^-.*TODO[: ]*/, '').trim();
      // Find matching open issues (exclude pull requests)
      const { data: allIssues } = await octokit.issues.listForRepo({
        owner,
        repo,
        state: 'open',
        search: oldTxt,
      });
      const issues = allIssues.filter(issue => !issue.pull_request);
      const existing = issues.length ? issues[0].number : null;
      if (existing && !updatedIssues.has(existing)) {
        await octokit.issues.createComment({
          owner,
          repo,
          issue_number: existing,
          body: `⚠️ The TODO \`${oldTxt}\` was removed in PR ${prUrl} (#${prNumber}); please review if this issue can now be closed.`
        });
        console.log(`Commented removal on issue #${existing}`);
      }
    }
  }
})();
