# Terraform

## Diagrams (Draft)

### System Context
<img class="c4-image" alt="C4 System Context Diagram" src="https://assets.jmrecondo.com/cloud-elite/systemcontext.png"/>

### Containers
<img class="c4-image" alt="C4 Containers Diagram" src="https://assets.jmrecondo.com/cloud-elite/containers.png"/>

## Repository Structure

```bash
.
├── .devcontainer/
├── docs/
│   ├── common/
│   │   ├── models.c4
│   │   └── specs.c4
│   ├── dev/
│   │   ├── likec4.config.json
│   │   └── main.c4
│   └── prod/
│       ├── likec4.config.json
│       └── main.c4
├── terraform/
│   ├── environments/
│   │   └── dev/                  # Development env config
│   │       ├── backend.tf        # GCS remote state storage
│   │       ├── cicd.tf           # CI/CD (Cloud Build)
│   │       ├── database.tf       # Database resources
│   │       ├── frontend.tf       # Frontend resources
│   │       ├── main.tf           # Entrypoint (commented modules)
│   │       ├── network.tf        # Network/VPC resources
│   │       ├── outputs.tf        # Environment outputs
│   │       ├── providers.tf      # Provider version locking
│   │       ├── servers.tf        # Server/VM resources
│   │       ├── terraform.tfvars  # Non-sensitive dev variables
│   │       └── variables.tf      # Dev variable declarations
│   └── modules/                  # Reusable templates
│       ├── gcp-cloud-build/      # Cloud Build CI/CD module
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── gcp-vm/               # GCP Compute Engine VM module
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
├── .env.example                  # Env variable template
├── .gitignore
├── Justfile                      # Command runner (think of package.json)
├── LICENSE
├── package.json
└── README.md
```

## Onboarding

### Configure Local Environment & Variables

#### 1. Make .env
```bash
cp .env.example .env
```

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

---

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

<style>
.c4-image {
    width: 100%;
    max-width: 800px;
    height: 100%;
    max-height: 400px;
    object-fit: contain;
    display: block;
    margin: 0 auto;
}
</style>
