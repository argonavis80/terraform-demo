locals {
  env_name           = "${terraform.workspace}"

  env_name_lowercase = "${lower(local.env_name)}"
  
  tags = {
    Application = "N4"
    Environment = "${local.env_name_lowercase}"
    CreatedBy   = "Terraform"
  }
}
