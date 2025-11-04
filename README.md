# gcp-vm

This repository provisions a single Google Compute Engine VM and a firewall rule using Terraform.

Repository layout
- [infrastructure/main.tf](infrastructure/main.tf) — defines the VM resource [`google_compute_instance.ubuntu_vm`](infrastructure/main.tf) and firewall [`google_compute_firewall.allow_ports`](infrastructure/main.tf).
- [infrastructure/variables.tf](infrastructure/variables.tf) — Terraform input variables such as [`variable.project_id`](infrastructure/variables.tf), [`variable.startup_script_path`](infrastructure/variables.tf) and [`variable.allowed_ports`](infrastructure/variables.tf).
- [infrastructure/provider.tf](infrastructure/provider.tf) — Google provider configuration (`provider "google"`) and region/zone bindings.
- [infrastructure/backend.tf](infrastructure/backend.tf) — remote state backend configuration (GCS).
- [infrastructure/outputs.tf](infrastructure/outputs.tf) — exposes [`output.external_ip`](infrastructure/outputs.tf).
- [infrastructure/terraform.tfvars.example](infrastructure/terraform.tfvars.example) — example variable values.
- [infrastructure/startup_script.sh](infrastructure/startup_script.sh) — instance startup script applied via `startup-script` metadata.
- [.gitignore](.gitignore) — ignores secrets and state.
- [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) — devcontainer configuration.

Prerequisites
1. Install Terraform CLI (version compatible with the provider).  
2. A Google Cloud project with billing enabled.
3. Enable required APIs: Compute Engine and Cloud Storage (if using the GCS backend).
4. A service account with permissions to create Compute Engine instances and firewall rules. Either:
   - Place the service account key as [infrastructure/service-account.json](infrastructure/service-account.json) and configure credentials, or
   - Set the environment variable GOOGLE_APPLICATION_CREDENTIALS to the service account key path.
5. Ensure the backend bucket referenced in [infrastructure/backend.tf](infrastructure/backend.tf) exists (bucket `tf-backend-bucket-lv`) or update the backend configuration.

Important notes about the workspace
- The default startup script path in [infrastructure/variables.tf](infrastructure/variables.tf) may differ from the actual file name. Ensure the `startup_script_path` variable (see [infrastructure/terraform.tfvars.example](infrastructure/terraform.tfvars.example)) points to [infrastructure/startup_script.sh](infrastructure/startup_script.sh).
- The service account key file is ignored by [.gitignore](.gitignore). Do not commit secrets.

Quick start (deploy directly from this repo)
1. Copy the example variables:
   ```sh
   cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
   # Edit infrastructure/terraform.tfvars to match your project and preferences
   ```
2. Initialize Terraform and download providers:
   ```sh
   cd infrastructure
   terraform init
   ```
   If you use the GCS backend and the bucket doesn't exist, create it before `terraform init`.
3. Plan and apply:
   ```sh
   terraform plan -out=tfplan
   terraform apply tfplan
   ```
4. After apply, retrieve the VM external IP from output:
   ```sh
   terraform output external_ip
   ```
   See [`output.external_ip`](infrastructure/outputs.tf).

Using this as a module
You can use the contents of the `infrastructure/` directory as a reusable module from another Terraform configuration. Example consumer:

```hcl
module "gcp_vm" {
  source = "./infrastructure"

  project_id         = "my-gcp-project"
  region             = "asia-south1"
  zone               = "asia-south1-a"
  vm_name            = "example-vm"
  machine_type       = "n2-standard-4"
  image              = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  tags               = ["http-server","database-server"]
  startup_script_path = "./path/to/startup_script.sh" # ensure readable by Terraform
  allowed_ports      = [22,80,443]
}
```

Notes when using as a module:
- The module expects the same variables defined in [infrastructure/variables.tf](infrastructure/variables.tf). Inspect that file for names and types.
- Ensure credentials and backend handling are configured in the root module or via environment variables (avoid committing service-account files).

Inputs (high level)
- [`var.project_id`](infrastructure/variables.tf) — GCP project ID (required).
- [`var.region`](infrastructure/variables.tf) — region (default provided).
- [`var.zone`](infrastructure/variables.tf) — zone (default provided).
- [`var.vm_name`](infrastructure/variables.tf) — instance name.
- [`var.machine_type`](infrastructure/variables.tf) — machine type.
- [`var.image`](infrastructure/variables.tf) — boot disk image.
- [`var.tags`](infrastructure/variables.tf) — instance tags (used by firewall).
- [`var.startup_script_path`](infrastructure/variables.tf) — path to the startup script file (contents are read with file()).
- [`var.allowed_ports`](infrastructure/variables.tf) — list of ports for the firewall.

Outputs
- [`output.external_ip`](infrastructure/outputs.tf) — public IP of the created VM.

Useful files and symbols (quick links)
- [infrastructure/main.tf](infrastructure/main.tf) — defines [`google_compute_instance.ubuntu_vm`](infrastructure/main.tf) and [`google_compute_firewall.allow_ports`](infrastructure/main.tf)
- [infrastructure/variables.tf](infrastructure/variables.tf) — variables like [`variable.project_id`](infrastructure/variables.tf) and [`variable.startup_script_path`](infrastructure/variables.tf)
- [infrastructure/provider.tf](infrastructure/provider.tf) — `provider "google"` configuration
- [infrastructure/backend.tf](infrastructure/backend.tf) — Terraform backend
- [infrastructure/outputs.tf](infrastructure/outputs.tf) — [`output.external_ip`](infrastructure/outputs.tf)
- [infrastructure/terraform.tfvars.example](infrastructure/terraform.tfvars.example) — example values
- [infrastructure/startup_script.sh](infrastructure/startup_script.sh) — startup script applied to the instance

Security considerations
- Keep service account keys out of version control.
- Adjust firewall `source_ranges` in [infrastructure/main.tf](infrastructure/main.tf) if you want to restrict access instead of allowing `0.0.0.0/0`.

Contributing
- Use the devcontainer defined in [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) for a consistent development environment.

License
- See [LICENSE](LICENSE).