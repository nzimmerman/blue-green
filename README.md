# Blue/Grean Deployment Using Traefik and Flagger
This is a simple demonstration of how a blue-green deployment on a Kubernetes cluster. This strategy allows the deployment of a new version of a service with zero downtime while automating testing and rollback in case there is an issue witht he new deployment.

Kind is used to provide a local Kubernetes cluster. Traefik proxy is used as the ingress and routing. 

Flagger is deployed to manage the deployments. Flagger takes any new deployment and created a copy of it and appends -primary to that copy. The original deployment is deleted. When the deployment is updated, Flagger begins testing the new deployment according to the Canary resource configuration.

The Canary resource is configured to execute and analyze tests which will determin if the new deployment can proceed. If the analysis times out or fails, the new deployment is not promoted and it is rolled back.

If an interval shows success based on the test analysis, the next incremental increase in traffic is applied and more load is shifted to the new deployment. Once the maximum weight per the configuration has been transfered to the new deployment and an interval passes, the current primary is terminated and the new deployment is promoted to primary.

## Prerequisites
* kind
* kubectl
* make
* python3
* docker
* helm

## Using the repository

`$ make create-cluster`
This creates the kind cluster and loads all the necessary resources. It loads the th3-server version 0.0.1.

`$ make start-test`
This loads the updated deployment with th3-server version 0.0.2, and then the test calling the `/version` endpoint with a 1 second delay between calls.

The `sample_output.txt` file shows the output of this command.

`$ make delete-cluster`
Delete and clean-up the cluster.

The th3-server is sourced from https://volskayaindustries.com/th3.zip .