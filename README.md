# Multi-arch `unifi_exporter` for Prometheus

![Docker Pulls][docker-hub-badge]
[![][microbadger]][microbadger 2]

Have you ever wanted to aggregate your Unifi networking data right alongside all
the myriad other data points you've meticulously configured your system to
collect?

Sure, you've already got more hand-tweaked Grafana graphs than could possibly
fit on any screen in that tiny studio of yours, but still something was missing.
It was those pretty network graphs.

#### What does this do?

This builds on the [excellent Unifi Exporter package][unifi-exporter-mdlayher]
developed by @mdlayher, which unfortunately is no longer actively maintained,
and provides an up-to-date, multi-arch image with the additional configuration
manifests required for easy Kubernetes + Prometheus Operator integration.

In addition to the self-evident benefits of the tool itself, this integration
offers:

- A significantly slimmed down Docker image -- just 7MB compressed, compared to
  150+MB.

- Native multi-arch (i.e., as defined in the [V2 image manifest, schema
  2][v2-image-manifest]) support for `amd64`, `armv7`/`armhf`, and
  `arm64`/`aarch64` architectures. Use it on your GCP VM's, your Raspberry Pis,
  your Odroid C2's, Rock64's... you get the idea.

- Turnkey integration with an existing Prometheus Operator deployment.

#### Sounds cool. What do I need?

- Ubiquiti gear, obviously; as well as a persistent connection to an instance of
  your Unifi controller — spinning it up as-needed on your local machine isn't
  going to cut it here. You can either spring for Ubiquiti's [Cloud
  Key][cloud-key-amazon], or you can easily host it on your choice of hosting
  provider — AWS, GCP, Digital Ocean, Linode, Vultr, Scaleway, etc. all have
  VPS' that will meet the minimum requirements for <= \$5 USD / month.

- A Kubernetes cluster, with CoreOS' [Prometheus Operator][prom-op] deployed. If
  not, check out the [official-docs][prom-op-docs] to get started; [Carlos
  Eduardo][prom-op-carlosedp] also has a great writeup on his experience porting
  many of the Operator images to ARM architecture(s) that's well worth the read.

### Usage

#### 'Vanilla' Docker

If you just want a multi-arch Docker image for the exporter, you can pull from
`jessestuart/unifi_exporter:v0.4.0` and go to town — just bind mount your config
file into your container and follow the instructions in the exporter
[README][unifi-exporter-readme].

#### Kubernetes Deployment

1. Now's a good time to switch to whatever namespace the resources to be created
   will live in. I keep mine in a `monitoring` namespace, along with the rest of
   my exporters. (Although this isn't a strict requirement, using fields like
   the `serviceMonitorNamespaceSelector` option on your `Prometheus` `CRD`[s])
1. Copy the `config.example.yml`, and fill it in with your Unifi controller's
   credentials. This just require updating the host, username, and password; you
   may also need to change the port if your controller is behind a reverse
   proxy.
1. Run `make generate-secret` to create a Kubernetes secret storing the data in
   this file.
1. Run `make deploy` to deploy to your cluster, and `make destroy` to remove
   only those resources that were created.

[cloud-key-amazon]:
  https://www.amazon.com/Ubiquiti-Unifi-Cloud-Key-Control/dp/B017T2QB22/
[docker-hub-badge]:
  https://img.shields.io/docker/pulls/jessestuart/unifi_exporter.svg
[microbadger 2]:
  https://microbadger.com/images/jessestuart/unifi_exporter
  'Get your own image badge on microbadger.com'
[microbadger]:
  https://images.microbadger.com/badges/image/jessestuart/unifi_exporter.svg
[prom-op-carlosedp]:
  https://itnext.io/creating-a-full-monitoring-solution-for-arm-kubernetes-cluster-53b3671186cb
[prom-op-docs]: https://coreos.com/operators/prometheus/docs/latest/
[prom-op]: https://github.com/coreos/prometheus-operator
[quay-badge]: https://quay.io/repository/jessestuart/unifi_exporter/status
[quay-link]: https://quay.io/repository/jessestuart/unifi_exporter
[unifi-exporter-mdlayher]: https://github.com/mdlayher/unifi_exporter
[v2-image-manifest]: https://docs.docker.com/registry/spec/manifest-v2-2/
