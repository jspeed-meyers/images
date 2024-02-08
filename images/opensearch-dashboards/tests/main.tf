terraform {
  required_providers {
    oci       = { source = "chainguard-dev/oci" }
    helm      = { source = "hashicorp/helm" }
    imagetest = { source = "chainguard-dev/imagetest" }
  }
}

variable "digest" {
  description = "The image digests to run tests over."
}

data "oci_string" "ref" {
  input = var.digest
}

data "imagetest_inventory" "this" {}

resource "imagetest_harness_k3s" "this" {
  name      = "opensearch-dashboards"
  inventory = data.imagetest_inventory.this
}

module "helm_opensearch" {
  source = "../../../tflib/imagetest/helm"

  namespace = "opensearch-dashboards"
  chart     = "opensearch"
  repo      = "https://opensearch-project.github.io/helm-charts"

  values = {
    singleNode = true
    majorVersion = "2"
    image = {
      repository = "cgr.dev/chainguard/opensearch"
      tag        = "latest"
    }
    config = {
      "log4j2.properties" = <<-EOT
      status = error

      appender.console.type = Console
      appender.console.name = console
      appender.console.layout.type = PatternLayout
      appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] [%node_name]%marker %m%n

      rootLogger.level = info
      rootLogger.appenderRef.console.ref = console
      EOT
    }
  }
}

module "helm_opensearch_dashboards" {
  source = "../../../tflib/imagetest/helm"

  namespace = "opensearch-dashboards"
  chart     = "opensearch-dashboards"
  repo      = "https://opensearch-project.github.io/helm-charts"

  values = {
    installCRDs = true
    singleNode = true
    image = {
      repository = "${data.oci_string.ref.registry_repo}:${data.oci_string.ref.pseudo_tag}"
      # tag        = 
    }
  }
}

resource "imagetest_feature" "basic" {
  harness     = imagetest_harness_k3s.this
  name        = "Basic"
  description = "Basic functionality of the opensearch-dashboard helm chart."

  steps = [
    {
      name = "Helm install Opensearch"
      cmd  = module.helm_opensearch.install_cmd
    },
#    {
#      name = "Helm install Opensearch Dashboards"
#      cmd  = module.helm_opensearch_dashboards.install_cmd
#    },
    {
      name = "Ensure it passes cmctl readiness checks"
      cmd  = <<EOF
apk add kubectl
kubectl get pods -A
      EOF
    },
  ]

  labels = {
    type = "k8s"
  }
}
