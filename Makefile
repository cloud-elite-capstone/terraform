ifneq (,$(wildcard ./.env))
    include .env
    export
endif
PROJECT_DIR ?= environments/dev

.PHONY: default tree init plan apply destroy fmt auth

default:
	@echo "Available commands:"
	@echo
	@echo "GCP"
	@echo "  make auth    - Log in to GCP"
	@echo
	@echo "TERRAFORM"
	@echo "  make init    - Initialize Terraform"
	@echo "  make init-upgrade - Initialize Terraform and upgrade modules"
	@echo "  make plan    - Run terraform plan to see what changes will be made without applying them"
	@echo "  make apply   - Apply changes"
	@echo "  make destroy - Destroy infrastructure"
	@echo "  make fmt     - Format Terraform configuration files"
	@echo
	@echo "PROJECT"
	@echo "  make tree    - Show project directory structure for root"
	@echo "  make tree-project - Show project directory structure for $(PROJECT_DIR)"

auth:
	@echo "Setting up Application Default Credentials (ADC) via gcloud..."
	@echo
	@echo "Opening browser to authenticate. Select the appropriate Google account and grant access."
	@echo
	gcloud auth application-default login
	@echo "GCP authenticated!"

init:
	GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform -chdir=$(PROJECT_DIR) init $(RUN_ARGS)

plan:
	GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform -chdir=$(PROJECT_DIR) plan $(RUN_ARGS)

apply:
	GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform -chdir=$(PROJECT_DIR) apply -auto-approve $(RUN_ARGS)

destroy:
	@echo "WARNING: Destroying GCP resources"
	GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform -chdir=$(PROJECT_DIR) destroy $(RUN_ARGS)

fmt:
	terraform fmt -recursive

tree:
	@echo "Project directory structure:"
	@tree -a -I '.git|.terraform' --dirsfirst .

tree-project:
	@echo "Project directory structure for $(PROJECT_DIR):"
	@tree --dirsfirst $(PROJECT_DIR)