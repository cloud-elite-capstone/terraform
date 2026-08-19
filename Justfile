set dotenv-load := true

raw_creds := env("GOOGLE_APPLICATION_CREDENTIALS", "")
export GOOGLE_APPLICATION_CREDENTIALS := if raw_creds == "" { "" } else { absolute_path(raw_creds) }
project_dir := env("PROJECT_DIR", "terraform/environments/dev")
project_id := env("PROJECT_ID", "")
github_pat := env("GITHUB_PAT", "")
gemini_api_key := env("GEMINI_API_KEY", "")

default:
    @echo "Available commands:"
    @echo
    @echo "GCP"
    @echo "  just auth          - Log in to GCP"
    @echo "  just enable-apis   - Enable required GCP APIs"
    @echo
    @echo "TERRAFORM"
    @echo "  just fmt            - Format Terraform configuration files"
    @echo "  just apply-cicd     - Apply CI/CD only (Cloud Build + Artifact Registry); run first"
    @echo "  just build          - Manually run all Cloud Build triggers (builds current code)"
    @echo "  just apply-services - Apply everything incl. Cloud Run; run after images are built"
    @echo "  just t <args>       - Run arbitrary Terraform command with arguments on project directory ({{ project_dir }})"
    @echo
    @echo "PROJECT"
    @echo "  just tree          - Show project directory structure for root"
    @echo "  just tree-project  - Show project directory structure for {{ project_dir }}"

destroy-devpod:
    @echo "Destroying DevPod VM and associated resources..."
    just t destroy -target=module.devpod_vm.google_compute_instance.vm
    @echo "DevPod VM and associated resources destroyed."

set-project:
    @echo "Setting GCP project to {{ project_id }}..."
    gcloud config set project {{ project_id }}
    @echo "GCP project set to {{ project_id }}."

remove-state:
    @echo "Removing Terraform state files..."
    rm -rf {{ project_dir }}/.terraform
    rm -f {{ project_dir }}/.terraform.lock.hcl
    @echo "Terraform state files removed."

auth:
    @echo "Setting up Application Default Credentials (ADC) via gcloud..."
    @echo
    @echo "Opening browser to authenticate. Select the Google account and grant access."
    @echo
    gcloud auth application-default login
    # just set-project
    @echo
    @echo "GCP authenticated."

set-github-pat:
    @echo "Setting GitHub Personal Access Token (PAT) in GCP Secret Manager..."
    printf '%s' '{{ github_pat }}' | gcloud secrets create github-pat \
    --project=cloud-elite-capstone-retail \
    --replication-policy=automatic \
    --data-file=-

set-gemini-key:
    @echo "Setting Gemini API key in GCP Secret Manager..."
    printf '%s' '{{ gemini_api_key }}' | gcloud secrets create gemini-api-key \
    --project=cloud-elite-capstone-retail \
    --replication-policy=automatic \
    --data-file=-

enable-apis:
    @echo "Enabling required GCP APIs in project {{ project_id }}..."
    gcloud services enable \
        compute.googleapis.com \
        iam.googleapis.com \
        iamcredentials.googleapis.com \
        cloudresourcemanager.googleapis.com \
        serviceusage.googleapis.com \
        secretmanager.googleapis.com \
        cloudbuild.googleapis.com \
        artifactregistry.googleapis.com \
        run.googleapis.com \
        sqladmin.googleapis.com \
        servicenetworking.googleapis.com \
        --project {{ project_id }}
    @echo "APIs enabled."

apply-cicd:
    @echo "Applying CI/CD infrastructure only (Cloud Build + Artifact Registry + secret IAM + registry IAM)..."
    just t apply -target=module.cloud_build -target=module.artifact_registry -target=google_secret_manager_secret_iam_member.github_pat_cloudbuild_reader -target=google_artifact_registry_repository_iam_member.cloudbuild_writer -target=google_artifact_registry_repository_iam_member.cloudrun_reader

apply-services:
    @echo "Applying all remaining resources (network, database, Cloud Run)..."
    just t apply

build:
    @echo "Manually running all Cloud Build triggers..."
    gcloud builds triggers run push-microservices-agent-orchestrator-service --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=feat/orchestrator-service
    gcloud builds triggers run push-microservices-agent-service --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=feat/orchestrator-service
    gcloud builds triggers run push-microservices-product-service --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=feat/orchestrator-service
    gcloud builds triggers run push-microservices-order-service --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=feat/orchestrator-service
    gcloud builds triggers run push-microservices-shop-service --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=feat/orchestrator-service
    gcloud builds triggers run push-microservices-user-service --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=feat/orchestrator-service
    gcloud builds triggers run push-frontend-default --region=asia-southeast1 --project=cloud-elite-capstone-retail --branch=main

fmt *flags:
    terraform -chdir={{ project_dir }} fmt -recursive {{ flags }}

tree *flags:
    @echo "Project directory structure:"
    @echo
    tree -a -I '.git|.terraform|keys|node_modules' --dirsfirst {{ flags }} .

tree-project *flags:
    @echo "Project directory structure for {{ project_dir }}:"
    @echo
    tree --dirsfirst {{ flags }} {{ project_dir }}

tree-clean *flags:
    tree --dirsfirst -I '.git|.terraform|keys|node_modules|.devcontainer' {{ flags }} . \
    | tail -n +2 | sed 's/[├└]──/  /g; s/│/ /g'

# Wrapper for any arbitrary terraform command
t *args:
    terraform -chdir={{ project_dir }} {{ args }}
