# Terraform

## Diagrams (Draft)

### System Context
<img class="c4-image" alt="C4 System Context Diagram" src="https://assets.jmrecondo.com/systemcontext.png"/>

### Containers
<img class="c4-image" alt="C4 Containers Diagram" src="https://assets.jmrecondo.com/containers.png"/>

## Repository Structure

```bash
.
├── environments/
│   ├── dev/                  # Development env config
│   │   ├── backend.tf        # GCS remote state storage
│   │   ├── main.tf           # Entrypoint
│   │   ├── outputs.tf        # Environment outputs
│   │   ├── providers.tf      # Provider version locking
│   │   ├── terraform.tfvars  # Non-sensitive dev variables
│   │   └── variables.tf      # Dev variable declarations
│   └── prod/                 # Production env config
├── modules/                  # Reusable templates
│   └── gcp-vm/
│       ├── main.tf           
│       ├── outputs.tf        
│       └── variables.tf      
├── .env.example              # Env variable template
├── .gitignore                
└── Justfile                  # Command runner (think of package.json)

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
PROJECT_DIR="environments/dev"
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
