// ...existing code...
# gcp-vm

Terraform configuration that provisions a single Google Compute Engine VM and a firewall rule.

Repository layout
```
.
├── LICENSE
├── README.md
└── infrastructure
    ├── backend.tf
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── startup_script.sh
    ├── terraform.tfvars.example
    └── variables.tf
```

Prerequisites
- Terraform CLI installed (compatible with the google provider).
- A Google Cloud project with billing enabled.
- Enabled APIs: Compute Engine and Cloud Storage (if using GCS backend).
- Service account with permissions: Compute Admin, Service Account User, Storage Admin (if managing backend).
- If using the GCS backend, ensure the backend bucket exists or update infrastructure/backend.tf.

Authentication (one-line description then one-line command)
Using Service Account Key File

``` sh 
export GOOGLE_APPLICATION_CREDENTIALS="infrastructure/service-account.json"
```
Using a Custom Location for the Service Account Key  

```sh
export GOOGLE_APPLICATION_CREDENTIALS="<path-to-your-key-file>"
```


Quick start (deploy from this repo)
1. Copy example variables:
   ```sh
   cp infrastructure/terraform.tfvars.example infrastructure/terraform.tfvars
   # Edit infrastructure/terraform.tfvars to match your project
   ```
2. Initialize Terraform:
   ```sh
   cd infrastructure
   terraform init
   ```
3. Plan and apply:
   ```sh
   terraform plan -out=tfplan
   terraform apply tfplan
   ```
4. Get VM external IP:
   ```sh
   terraform output external_ip
   ```

Using this as a module
You can consume the infrastructure directory as a module.

Example:
```hcl
module "gcp_vm" {
  source = "./infrastructure"

  project_id          = "my-gcp-project"
  region              = "us-central1"
  zone                = "us-central1-a"
  vm_name             = "example-vm"
  machine_type        = "e2-medium"
  image               = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
  tags                = ["http-server"]
  startup_script_path = "infrastructure/startup_script.sh"
  allowed_ports       = [22,80,443]
}
```

Notes when using as a module
- The module expects variables declared in infrastructure/variables.tf. Inspect that file for names, types and defaults.
- Provide credentials and backend configuration in the root module or via environment variables; avoid committing service-account.json.

Inputs (high level)
- project_id, region, zone — GCP project and location.
- vm_name, machine_type, image — VM identity and boot image.
- tags — instance tags applied to VM.
- startup_script_path — path to a startup script whose contents are read with file().
- allowed_ports — list of TCP ports for the firewall rule.

Outputs
- external_ip — public IP of the created VM (see infrastructure/outputs.tf).

Security considerations
- Do not commit service account keys. infrastructure/service-account.json is for local convenience only.
- Adjust firewall source_ranges in infrastructure/main.tf to restrict access (current config allows 0.0.0.0/0).



License
- See LICENSE