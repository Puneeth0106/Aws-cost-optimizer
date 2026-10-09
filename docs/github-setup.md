# Publish to GitHub

Suggested repository name: `puneeth0106/aws-cost-optimizer`.

Suggested description: **AWS cost dashboard with resource inventory, AI-assisted recommendations, and a Terraform-defined serverless backend.**

Suggested topics: `aws`, `finops`, `cost-optimization`, `python`, `streamlit`, `terraform`, `langgraph`.

## Authenticate

From your terminal, sign in to the GitHub CLI:

```bash
gh auth login --hostname github.com
gh auth status
```

## Commit each file separately

Run this from the repository root:

```bash
bash scripts/commit-files.sh
git log --oneline
```

The script initializes a `main` branch if needed and creates one commit per changed project file, with a message describing that file's contents. A fresh repository produces 26 commits. For example: `feat(billing): add service cost breakdowns and monthly forecasts`.

The script uses your configured Git identity and the current time. It skips unchanged files when rerun, stops if unrelated changes are already staged, and does not rewrite existing history. If Git needs an identity, set `git config user.name` and `git config user.email` to your preferred values in this repository, then rerun the script.

The original downloaded materials remain in the local workspace as a backup and are excluded by `.gitignore`.

## Create and push

Create a private repository first so you can review it on GitHub before changing its visibility:

```bash
gh repo create puneeth0106/aws-cost-optimizer --private --source=. --remote=origin --push --description "AWS cost dashboard with resource inventory, AI-assisted recommendations, and a Terraform-defined serverless backend."
```

If you have already created an empty repository on GitHub, use these commands instead:

```bash
git remote add origin https://github.com/puneeth0106/aws-cost-optimizer.git
git push -u origin main
```

If `origin` already exists, inspect it with `git remote -v` before changing anything. If the remote already contains commits, reconcile its history before pushing; do not force-push over existing work.
