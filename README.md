# jenkins-resources
A Repository that contains a lot of resources to be used in Jenkins pipelines.


## Sidecars containers yaml patch manifests for CI Testing. 

- All project manifest should be either in ./side-cars/kustomize/base/manifests.yaml or to be changed in  ./side-cars/kustomize/base/kustomization.yaml accordingly(change manifests.yaml with all concrete yaml manifests of the project.

- In order to inject and install sidecars in Openshift Platform:
```shell
oc kustomize ./side-cars/kustomize/openshift/
```

- In order to inject and install sidecars in Kubernetes:
```shell
kubectl kustomize ./side-cars/kustomize/k8/
```
- To enable Deploy applications in testing mode(for integration test) , controlled and driven by annotations, deployments for example:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: app
  name: app
  annotations:
    tests/injectWiremockSideCar: "true"
    tests/injectKafkaSideCar: "true"
    tests/injectPostgresqlSideCar: "true"
    postgresqlSideCarDB: "orders"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  strategy: {}
  template:
    metadata:
      labels:
        app: app
      annotations:
        tests/injectWiremockSideCar: "true"
        tests/injectKafkaSideCar: "true"
        tests/injectPostgresqlSideCar: "true"
        postgresqlSideCarDB: orders

    spec:
      containers:
      - image: ubi8/ubi:8.5-226
        name: ubi
        command: ["bash", "-c" , "sleep infinity" ]
```
- This deployment will be deployed with 3 sidecars containers:
   - Wiremock mocking server
   - Single node kafka broker
   - Postgresql DB instances
   - it will also auto create "orders" DB in postgresql Server for testing.
   
   
  
