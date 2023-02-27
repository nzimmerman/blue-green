create-cluster:
	@kind create cluster --name local --config kind-cluster-cfg.yaml
	@kubectl create namespace traefik
	@kubectl create namespace th3
	@helm repo add traefik https://helm.traefik.io/traefik || true
	@helm repo update
	@helm install traefik traefik/traefik --namespace traefik --values traefik-values.yaml
	@helm repo add flagger https://flagger.app || true
	@helm repo update
	@kubectl apply -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml
	@helm install flagger flagger/flagger --namespace traefik --values flagger-values.yaml
	@docker build -t th3:0.0.1 -f Dockerfile.v1 .
	@kind load docker-image th3:0.0.1 --name local
	@docker build -t th3:0.0.2 -f Dockerfile.v2 .
	@kind load docker-image th3:0.0.2 --name local
	@kubectl apply -f th3-canary.yaml -n th3
	@kubectl apply -f th3-ingressroute.yaml -n th3
	@kubectl apply -f th3-service.yaml -n th3
	@kubectl apply -f th3-deployment-v1.yaml -n th3

start-test:
	@kubectl apply -f th3-deployment-v2.yaml -n th3
	@echo "Starting test to show blue-green deployment"
	@python3 version-test.py

delete-cluster:
	@kind delete cluster --name local

