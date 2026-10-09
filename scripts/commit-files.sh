#!/usr/bin/env bash
# Create one descriptive commit per project file using the current Git identity.
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$project_root"

# Require a repository here, rather than accidentally committing into a parent.
if [[ ! -e .git ]]; then
    git init -b main
fi

if [[ "$(git rev-parse --show-toplevel)" != "$project_root" ]]; then
    echo "Run this script from its original project checkout." >&2
    exit 1
fi

if ! git diff --cached --quiet; then
    echo "Existing staged changes detected. Commit or unstage them before running this script." >&2
    exit 1
fi

# Validate identity before staging files. No identity or timestamps are overridden.
git var GIT_AUTHOR_IDENT >/dev/null
git var GIT_COMMITTER_IDENT >/dev/null

commit_file() {
    local file="$1"
    local message="$2"
    if [[ ! -f "$file" ]]; then
        echo "Missing project file: $file" >&2
        exit 1
    fi
    git add -- "$file"
    if git diff --cached --quiet; then
        printf 'Unchanged: %s\n' "$file"
        return
    fi
    git commit -m "$message"
}

commit_file '.gitignore' 'chore(git): exclude credentials, caches, Terraform state, and source backup'
commit_file '.gitattributes' 'chore(git): normalize line endings for source and documentation'
commit_file 'requirements.txt' 'build(python): declare dashboard, AWS SDK, and AI dependencies'
commit_file '.env.example' 'chore(config): document backend URL, region, and AI environment settings'
commit_file 'config/__init__.py' 'chore(config): add configuration package marker'
commit_file 'config/settings.py' 'feat(config): load environment settings and supported AWS services'
commit_file 'lambda_/__init__.py' 'chore(backend): add Lambda backend package marker'
commit_file 'lambda_/cost_explorer.py' 'feat(billing): add service cost breakdowns and monthly forecasts'
commit_file 'lambda_/services_inventory.py' 'feat(inventory): collect resource details across seven AWS services'
commit_file 'lambda_/service_actions.py' 'feat(resources): add AWS resource start, stop, and deletion actions'
commit_file 'lambda_/handler.py' 'feat(api): route billing, inventory, and resource action requests'
commit_file 'dashboard/__init__.py' 'chore(dashboard): add dashboard package marker'
commit_file 'dashboard/utils/__init__.py' 'chore(dashboard): add utilities package marker'
commit_file 'dashboard/utils/aws_client.py' 'feat(client): call the AWS backend through API Gateway'
commit_file 'dashboard/utils/cost_utils.py' 'feat(dashboard): add cost formatting and savings estimate helpers'
commit_file 'dashboard/utils/ai_agent.py' 'feat(advisor): add LangGraph advisor with six AWS data tools'
commit_file '.streamlit/config.toml' 'style(streamlit): configure dark theme and disable usage telemetry'
commit_file 'dashboard/app.py' 'feat(dashboard): display spending metrics, service charts, and daily trends'
commit_file 'dashboard/pages/2_Services.py' 'feat(services): display inventory, resource controls, and AI advice'
commit_file 'dashboard/pages/3_AI_Advisor.py' 'feat(advisor): add chat interface, suggested prompts, and tool activity'
commit_file 'terraform/variables.tf' 'infra(terraform): define region, environment, and Lambda inputs'
commit_file 'terraform/main.tf' 'infra(aws): define Lambda, REST API, IAM policies, and logging'
commit_file 'terraform/outputs.tf' 'infra(terraform): expose backend endpoint and resource identifiers'
commit_file 'README.md' 'docs(readme): explain features, architecture, setup, and current limitations'
commit_file 'docs/github-setup.md' 'docs(github): explain authentication, file commits, and repository publishing'
commit_file 'scripts/commit-files.sh' 'chore(git): automate descriptive commits for individual project files'

printf '\nFinished committing project files.\n'
git status --short
