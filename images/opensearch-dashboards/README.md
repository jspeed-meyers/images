<!--monopod:start-->
# opensearch-dashboards
| | |
| - | - |
| **OCI Reference** | `cgr.dev/chainguard/opensearch-dashboards` |


* [View Image in Chainguard Academy](https://edu.chainguard.dev/chainguard/chainguard-images/reference/opensearch-dashboards/overview/)
* [View Image Catalog](https://console.enforce.dev/images/catalog) for a full list of available tags.
* [Contact Chainguard](https://www.chainguard.dev/chainguard-images) for enterprise support, SLAs, and access to older tags.*

---
<!--monopod:end-->

<!--overview:start-->
Minimal image with Opensearch Dashboards.
<!--overview:end-->

<!--getting:start-->
## Get It!
The image is available on `cgr.dev`:

```
docker pull cgr.dev/chainguard/opensearch-dashboards:latest
```
<!--getting:end-->

<!--body:start-->
## Using Opensearch Dashboards

Chainguard Opensearch images include the `opensearch` package and helper scripts which can be used to start up or configure Opensearch.

The full list of included tools is:

```shell
$ ls /usr/share/opensearch/bin/
opensearch-dashboards      opensearch-dashboards-plugin      opensearch-dashboards-keystore      use_node
```

The default entrypoint is set to run the included `/usr/local/bin/opensearch-dashboards-docker` script.

To get started:

```shell
$ docker run -it cgr.dev/chainguard/opensearch-dashboards
```
<!--body:end-->
