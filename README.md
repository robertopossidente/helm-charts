# Helm-charts
This repository contains the necessary files for the deployment of OAI-RAN and 5G modules (AMF, HSS, SMF, PCRF, and UPF) through helm charts

## What's Helm?

Helm is a package manager for Kubernetes that allows developers and operators to more easily package, configure, and deploy applications and services onto Kubernetes clusters.

## Install Helm

1. Install Homebrew

```
git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir ~/.linuxbrew/bin
ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)
```

2. ``brew install helm``


## Charts
This project provides the following files:

| File                                              | Description                                                           |
|---------------------------------------------------|-----------------------------------------------------------------------|  
| `Chart.yaml`                    | The definition file for your application                           | 
| `values.yaml`                   | Configurable values that are inserted into the following template files      | 
| `templates/deployment.yaml`     | Template to configure your application deployment.                 | 
| `templates/service.yaml`        | Template to configure your application deployment.                 | 


## Testbed deployments

[All free5GC (and dependencies) docker images should be built in all nodes; in this link you can build all docker images through cluster docker-compose](https://gitlab.lasse.ufpa.br/2020-ai-testbed/ai-testbed/free5gc-docker-kube "free5gc images")

[The RAN docker images should already exist in all nodes. ](https://gitlab.lasse.ufpa.br/2020-ai-testbed/ai-testbed/oai-ran-docker/- "RAN images")

[The flexran-controller docker image should already exist in all nodes. ](https://gitlab.lasse.ufpa.br/2020-ai-testbed/ai-testbed/oai-ran-docker/blob/master/flexran-controller/Dockerfile- "Flexran image")

| Chart                                           | Creates the modules                                                           |
|---------------------------------------------------|-----------------------------------------------------------------------|  
| `free5gc`                    | amf, upf, hss, pcrf, amf, mongo and webapp (webapp service)                          | 
| `oai-ran`                   | rcc-master and rru-ue-master     | 
| `simple-chart`     | flexran-controller (flexran-controller service), vnf and pnf                | 

## Create deployment

Example:

``helm install ./[chart] --generate-name --set name=[name] --set nodeAffinity.values=[node tag]``

By default (w/o --set nodeAffinity.values=[node tag]):

* free5gc chart deploys in  labeled node environment=cloud

* simple-chart deploys in labeled node environment=edge

* oai-ran chart deploys in rru-ue-master in labeled node usrp=connected; and rcc-master in a node without rru-ue-master

## Simple-chart 

This chart creates any basic deployment (without specifications) based only on the name of the image, just run:

``helm install ./simple-chart --generate-name --set name=[image-name] --set nodeAffinity.values=[node tag]``

## Debugging helm

Example:

``helm install --dry-run --debug ./[chart] --generate-name --set name=[name]``
