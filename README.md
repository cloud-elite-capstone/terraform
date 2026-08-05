# Terraform and Docs

## Diagrams
To browse architecture diagrams, run `npm run dev` inside the devcontainer and it will auto-open the browser, or you can access [http://localhost:5173](http://localhost:5173)

## Repository Structure

```bash
.
├── docs
│   ├── likec4
│   │   ├── common
│   │   │   ├── models.c4
│   │   │   └── specs.c4
│   │   ├── dev
│   │   │   ├── likec4.config.json
│   │   │   └── main.c4
│   │   └── prod
│   │       ├── likec4.config.json
│   │       └── main.c4
│   └── structurizr
│       └── c4.dsl
├── terraform                       # Terraform-related files
│   ├── environments                # Deployment envs (dev or prod)
│   │   └── dev
│   │       ├── backend.tf          # Terraform state
│   │       ├── cicd.tf
│   │       ├── database.tf
│   │       ├── frontend.tf
│   │       ├── main.tf
│   │       ├── network.tf
│   │       ├── outputs.tf
│   │       ├── providers.tf
│   │       ├── servers.tf
│   │       ├── terraform.tfvars    # Env-specific config
│   │       └── variables.tf
│   └── modules                     # Custom modules
│       ├── gcp-cloud-build
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── ...
├── Justfile                        # Convenience scripts
├── LICENSE
├── README.md
├── package-lock.json
├── package.json
└── resources                       # relevant GCP resources
```

## Onboarding

### Configure Local Environment & Variables

#### 1. Open in devcontainer

#### 2. Configure your path:
In your `.env`, set your target environment directory:
```ini
PROJECT_DIR="terraform/environments/dev"
```

#### 3. Populate Terraform variables:
Navigate to `terraform.tfvars` in the target environment and replace placeholders.

#### 4. Authorize GCP & run:
```bash
just auth
just init
```

## Justfile Reference

Run commands using `just <target>`. Trailing arguments (e.g., `-upgrade`) are forwarded automatically to the underlying Terraform process.

### GCP
| Command | Description |
|---------|-------------|
| `just auth` | Log in to GCP via `gcloud auth application-default login` |

### Terraform
| Command | Description |
|---------|-------------|
| `just init [flags]` | Initialize Terraform in the target environment |
| `just plan [flags]` | Preview infrastructure changes |
| `just apply [flags]` | Apply changes (with `-auto-approve`) |
| `just destroy [flags]` | Destroy all infrastructure |
| `just fmt [flags]` | Format all Terraform files recursively |
| `just providers [flags]` | Show provider information for the target environment |

### Project
| Command | Description |
|---------|-------------|
| `just tree [flags]` | Show full project directory tree (excludes `.git`, `.terraform`, `keys`, `node_modules`) |
| `just tree-project [flags]` | Show directory tree for the target environment only |

<!-- <style>
.c4-image {
    width: 100%;
    max-width: 800px;
    height: 100%;
    max-height: 400px;
    object-fit: contain;
    display: block;
    margin: 0 auto;
}
</style> -->
