variable "target_repository" {
  description = "The docker repo into which the image and attestations should be published."
}

module "versions" {
  source  = "../../tflib/versions"
  package = "etcd"
}

module "config" {
  for_each       = module.versions.versions
  source         = "./config"
  extra_packages = [each.key]
  environment = endswith(each.key, "-3.4") ? {
    "ETCD_UNSUPPORTED_ARCH" : "arm64"
  } : {}
}

module "versioned" {
  for_each          = module.versions.versions
  source            = "../../tflib/publisher"
  name              = basename(path.module)
  target_repository = var.target_repository
  config            = module.config[each.key].config
  build-dev         = true
  main_package      = each.value.main
  update-repo       = each.value.is_latest
}

module "test-versioned" {
  for_each = module.versions.versions
  source   = "./tests"
  digest   = module.versioned[each.key].image_ref
}

module "tagger" {
  source     = "../../tflib/tagger"
  depends_on = [module.test-versioned]
  tags = merge(
    [for v in module.versioned : v.latest_tag_map]...
  )
}
