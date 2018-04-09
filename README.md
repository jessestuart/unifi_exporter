Multi-arch `unifi_exporter` for Prometheus Operator
=======================================================

[![Docker Repository on Quay][quay-badge]][quay-link]

Have you ever wanted to aggregate your Unifi networking data right alongside
all the myriad other data points you've meticulously configured your system to
collect?

Sure, you've already got more hand-tweaked Grafana graphs than could possibly
fit on any screen in that tiny studio of yours, but still something was missing.
It was those pretty network graphs.

#### What does this do?

This builds on the [excellent ubiquiti => prometheus integration][unifi-exporter-mdlayher]
developed by @mdlayher, which sadly is no longer actively maintained.

In addition to the self-evident benefits of the tool itself, this integration
offers:

- A significantly slimmed down Docker image -- just 7MB compressed, compared to
  150+MB.

- Native multi-arch (i.e., as defined in the [V2 image manifest, schema
  2][v2-image-manifest]) support for `amd64`, `armv7`/`armhf`, and `arm64`/`aarch64`
  architectures. Use it on your AWS VM's, your RPi's, your Odroid C2's,
  Rock64's... you get the idea.

- Turnkey integration with an existing Prometheus Operator deployment.

#### Sounds cool. What do I need?

- Ubiquiti gear, obviously; as well as a persistent connection to an instance
  of your Unifi controller — spinning it up as-needed on your local machine
  isn't going to cut it here. You can either spring for Ubiquiti's [Cloud
  Key][cloud-key-amazon], or you can easily host it on your choice of hosting
  provider — AWS, GCP, Digital Ocean, Linode, Vultr, Scaleway, etc. all have
  VPS' that will meet the minimum requirements for <= $5 USD / month.

- A Kubernetes cluster, with CoreOS' [Prometheus Operator][prom-op] deployed.
  If not, check out the [official-docs][prom-op-docs] to get started; [Carlos
  Eduardo][prom-op-carlosedp] also has a great writeup on his experience
  porting many of the Operator images to ARM architecture(s) that's well worth
  the read.

### Usage

If you just want a multi-arch Docker image, you can pull from
`jessestuart/unifi_exporter:v0.1.4.0` and go to town.

1. Now's a good time to switch to whatever namespace the new resources will
   live in; I kept miine in a `monitoring` namespace, along with the rest of
   my exporters.
1. Copy the `config.example.yml`, and fill it in with your Unifi controller's
   credentials. This should be as simple as updating the host, username, and
   password; you may also need to change the port if your controller is behind
   a reverse proxy.
1. Run `make generate-secret` to create a Kubernetes "generic secret" storing
   the data in this file.
1. Run `make deploy` to deploy the manifests defined in the `manifests` folder
   to your cluster (you probably don't have any reason to edit these).

[cloud-key-amazon]: https://www.amazon.com/Ubiquiti-Unifi-Cloud-Key-Control/dp/B017T2QB22/
[prom-op-carlosedp]: https://itnext.io/creating-a-full-monitoring-solution-for-arm-kubernetes-cluster-53b3671186cb
[prom-op-docs]: https://coreos.com/operators/prometheus/docs/latest/
[prom-op]: https://github.com/coreos/prometheus-operator
[unifi-exporter-mdlayher]: https://github.com/mdlayher/unifi_exporter
[v2-image-manifest]: https://docs.docker.com/registry/spec/manifest-v2-2/
[quay-badge]: https://quay.io/repository/jessestuart/unifi_exporter/status
[quay-link]: https://quay.io/repository/jessestuart/unifi_exporter
