set dotenv-load

root_dir := env_var_or_default("PWD", `pwd`)

raw_creds := env_var_or_default("GOOGLE_APPLICATION_CREDENTIALS", "")
export GOOGLE_APPLICATION_CREDENTIALS := if raw_creds == "" { "" } else { absolute_path(raw_creds) }

project_dir := env_var_or_default("PROJECT_DIR", "environments/dev")

default:
    @echo "Available commands:"
    @echo
    @echo "GCP"
    @echo "  just auth          - Log in to GCP"
    @echo
    @echo "TERRAFORM"
    @echo "  just init          - Initialize Terraform"
    @echo "  just plan          - Run terraform plan to preview changes"
    @echo "  just apply         - Apply changes"
    @echo "  just destroy       - Destroy infrastructure"
    @echo "  just fmt           - Format Terraform configuration files"
    @echo
    @echo "PROJECT"
    @echo "  just tree          - Show project directory structure for root"
    @echo "  just tree-project  - Show project directory structure for {{project_dir}}"

auth:
    @echo "Setting up Application Default Credentials (ADC) via gcloud..."
    @echo
    @echo "Opening browser to authenticate. Select the Google account and grant access."
    @echo
    gcloud auth application-default login
    @echo
    @echo "GCP authenticated."

init *flags:
    terraform -chdir={{project_dir}} init {{flags}}

plan *flags:
    terraform -chdir={{project_dir}} plan {{flags}}

apply *flags:
    terraform -chdir={{project_dir}} apply -auto-approve {{flags}}

destroy *flags:
    @echo "WARNING: Destroying GCP resources!"
    terraform -chdir={{project_dir}} destroy {{flags}}

fmt:
    terraform fmt -recursive

tree:
    @echo "Project directory structure:"
    tree -a -I '.git|.terraform|keys' --dirsfirst .

tree-project:
    @echo "Project directory structure for {{project_dir}}:"
    tree --dirsfirst {{project_dir}}