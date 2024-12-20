terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  owner = "alcofunk"

  app_auth {
    id              = var.app_id                           # or `GITHUB_APP_ID`
    installation_id = var.app_installation_id              # or `GITHUB_APP_INSTALLATION_ID`
    pem_file        = file("./key/private-key.pem")        # or `GITHUB_APP_PEM_FILE`
  }
}


data "github_organization" "default" {
  name = "alcofunk"
}

output "github_organization" {
  value = data.github_organization.default
}

# Add a user to the organization
resource "github_membership" "membership" {
  username = "nikita"
  role     = "member"
}



# data "github_repository" "default" {
#   full_name = "iva-cpu/multi-docker"
# }
#
# data "github_user" "user" {
#   username = "iva-cpu"
# }
#
#
# output "github_repository" {
#   value = data.github_repository.default
# }
#
# output "github_user" {
#   value = data.github_user.user
# }


# # Add a collaborator to a repository
# resource "github_repository_collaborator" "a_repo_collaborator" {
#   repository = "multi-docker"
#   username   = "nikita"
#   permission = "pull"
# }
