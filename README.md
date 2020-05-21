# Helm-charts
This repository contains the necessary files for the deployment of OAIN RAN, flexran and 5G modules (AMF, HSS, SMF, PCRF, and UPF) through helm charts

## What's Helm?

Helm is a package manager for Kubernetes that allows developers and operators to more easily package, configure, and deploy applications and services onto Kubernetes clusters.

## Charts
These directories and files have the following functions:

    charts/: Manually managed chart dependencies can be placed in this directory, though it is typically better to use requirements.yaml to dynamically link dependencies.
    templates/: This directory contains template files that are combined with configuration values (from values.yaml and the command line) and rendered into Kubernetes manifests. The templates use the Go programming language’s template format.
    Chart.yaml: A YAML file with metadata about the chart, such as chart name and version, maintainer information, a relevant website, and search keywords.
    requirements.yaml: A YAML file that lists the chart’s dependencies.
    values.yaml: A YAML file of default configuration values for the chart.

## Install 
1. Install Kubernetes

2. Install Multus [ https://intel.github.io/multus-cni/doc/quickstart.html ]

3. Storing a configuration as a Custom Resource [https://intel.github.io/multus-cni/doc/quickstart.html#storing-a-configuration-as-a-custom-resource]

4. Install Homebrew

```
git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir ~/.linuxbrew/bin
ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)
```

5. ``brew install helm``


## Create pods

``helm install ./oai-ran/ --generate-name --set name=rru``

``helm install ./oai-ran/ --generate-name --set name=rcc``

``helm install ./free5gc --generate-name --set name=mongo``

``helm install ./free5gc --generate-name --set name=hss``

``helm install ./free5gc --generate-name --set name=amf``

``helm install ./free5gc --generate-name --set name=upf``

``helm install ./free5gc --generate-name --set name=smf``

``helm install ./free5gc --generate-name --set name=pcrf``

``helm install ./free5gc --generate-name --set name=webapp``


## Free5gc Run 

Run:

``./free5gc-init.sh``

See log (hss example):

``kubectl exec $(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}") -- cat /free5gc/install/var/log/free5gc/free5gc.log``

### WEBAPP

Run inside container:

``export DB_URI=mongodb://[MONGO IP]:27017/free5gc``

``npm run dev &>/dev/null &``

Acess:

http://[WEBAPP NODE]:[WEBAPP NODE PORT]/

Login: admin

Password: 1423

webapp node: ``kubectl describe service webapp``

webapp node port: ``kubectl get service webapp``

###MONGO

List subscribers:

Run inside mongo container:
``mongo``

``use free5gc``

``db.getCollectionNames()``

``db.subscribers.find()``

## Debugging
Example:

``helm install --dry-run --debug ./oai-ran/ --generate-name``


