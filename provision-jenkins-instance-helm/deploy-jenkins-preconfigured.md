# Deploy Jenkins instance on K8 With Pre Loaded Configuration.

### Goal - To Avoid Boilerplate post deployment actions/operations that configures Jenkins, by introducing a way to perform a deployment that automates the needed configuration during the installation of Jenkins. 

### Objectives:

- Specify Exactly Which Jenkins' Plugins are needed to be auto-installed when Deploying Jenkins.
- Define Exactly what and which secrets will be created as Jenkins credentials(Using k8 secrets and JCasC - Jenkins Configuration As Code).
- Define Any Further Plugin/Jenkins/Security/Agents Configuration Using JCasC.
- Complete Documentation reference and all mapping of JCasC yaml schema<--> Jenkins Configuration is at [http://$JENKINS_URL/configuration-as-code/reference]()(CasC plugin must be installed). 


### Pre-requisites:

- Helm CLI.
- kubectl/oc CLI.
- Access to Openshift/Kubernetes Cluster.

### Procedure:

1. Create a literals Secret in default namespace(following name is important):
```shell
EXPORT CONTAINER_REGISTRY_USER=enter value
EXPORT CONTAINER_REGISTRY_PASSWORD=enter value
EXPORT SERVICE_ACCOUNT_TOKEN=enter value
EXPORT GITHUB_PERSONAL_ACCESS_TOKEN=value
oc create secret generic secret-credentials -n default --from-literal=user=$CONTAINER_REGISTRY_USER --from-literal=password=$CONTAINER_REGISTRY_PASSWORD --from-literal=token=$SERVICE_ACCOUNT_TOKEN --from-literal=gh-token=$GITHUB_PERSONAL_ACCESS_TOKEN
```
2. Create a files Secret in default namespace
```shell
# All files with absolutes paths.
#Private SSH Key of git account in order to connect using SSH to private git repos
#private key file name must be id-ed25519, if not rename it please.
EXPORT PATH_OF_PRIVATE_SSH_KEY=/path/to/private/id-ed25519
#Either k8 or openshift, ca name must be ca-jenkins-deployer.cert
EXPORT PATH_OF_CA_OPENSHIFT=/path/to/certificateAuthority/ca-jenkins-deployer.cert
#Private key for decrypting Secrets originated from git repos, private key name must be private.pgp. 
EXPORT PATH_OF_PRIVATE_GPG_KEY=/path/to/privateKey/private.pgp
oc create secret generic files -n default --from-file=$PATH_OF_CA_OPENSHIFT --from-file=$PATH_OF_PRIVATE_SSH_KEY --from-file=$PATH_OF_PRIVATE_GPG_KEY
```
3. fetch from git repository my fork of jenkins-ci official helm chart:
```shell
cd ..
git fetch git@github.com:zvigrinberg/helm-charts.git
git checkout FETCH_HEAD charts/jenkins
cd charts/jenkins
```

4. Create A Jenkins Namespace in cluster
```shell
export JENKINS_NAMESPACE=jenkins-namespace-name
oc new-project $JENKINS_NAMESPACE
```
5. Install Jenkins with all configuration bootstrapped 
```shell
 helm install jenkins . -n $JENKINS_NAMESPACE -f values-infinity-cicd.yaml
```

6. reset repository pointer FETCH_HEAD back to the one of current repo instead of foreign one:
```shell
git fetch.
```