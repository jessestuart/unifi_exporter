.PHONY: all test

define DEPLOY_SUCCEDED_MESSAGE
===============================================================

Deploy complete!
Check the logs to verify the pod is up and speaking to the ServiceMonitor,
with e.g.:

```
kubectl -n monitoring logs --selector app=unifi-exporter
```

You can also navigate to your Prometheus service in your browser and verifying
that unifi-exporter now appears as active under the `/targets` page. Try
querying some metrics — they're all prefixed with the `unifi_` keyword.

===============================================================
endef

.PHONY: build
build:
	pushd ./unifi_exporter/
	go build ./cmd/unifi_exporter
	popd

.PHONY: docker
docker:
	docker build -t jessestuart/unifi_exporter .

.PHONY: clean
clean:
	go clean
	rm -f unifi_exporter

generate-secret:
	# You can replace namespace with whatever you want; but make sure
	# it matches the namespaces you'll be deploying to.
	kubectl create secret generic unifi-exporter-credentials \
		--namespace monitoring \
		--from-file config.yml

export DEPLOY_SUCCEDED_MESSAGE
deploy:
	kubectl apply -f manifests/
	@echo "$$DEPLOY_SUCCEDED_MESSAGE"
