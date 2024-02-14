variable "extra_packages" {
  description = "Additional packages to install."
  type        = list(string)
  default     = ["ko"]
}

module "accts" { source = "../../../tflib/accts" }

output "config" {
  value = jsonencode({
    contents = {
      repositories = ["https://packages.cgr.dev/extras"]
      keyring = ["https://packages.cgr.dev/extras/chainguard-extras.rsa.pub"]
      packages = concat(["busybox", "build-base", "go", "git"], var.extra_packages)
    }
    accounts = module.accts.block
    entrypoint = {
      command = "/usr/bin/ko"
    }
  })
}

