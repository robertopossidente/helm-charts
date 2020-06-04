# Helm-charts
This repository contains the necessary files for the deployment of OAI-RAN and 5G modules (AMF, HSS, SMF, PCRF, and UPF) through helm charts

## What's Helm?

Helm is a package manager for Kubernetes that allows developers and operators to more easily package, configure, and deploy applications and services onto Kubernetes clusters.

## Charts
These directories and files have the following functions:

    charts/: Manually managed chart dependencies can be placed in this directory, though it is typically better to use requirements.yaml to dynamically link dependencies.
    templates/: This directory contains template files that are combined with configuration values (from values.yaml and the command line) and rendered into Kubernetes manifests. The templates use the Go programming language’s template format.
    Chart.yaml: A YAML file with metadata about the chart, such as chart name and version, maintainer information, a relevant website, and search keywords.
    requirements.yaml: A YAML file that lists the chart’s dependencies.
    values.yaml: A YAML file of default configuration values for the chart.

## Install Helm

1. Install Homebrew

```
git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
mkdir ~/.linuxbrew/bin
ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)
```

2. ``brew install helm``

## Create pods

[All free5GC (and dependencies) docker images should be built in all nodes; in this link you can build all docker images through cluster docker-compose](https://gitlab.lasse.ufpa.br/2020-ai-testbed/ai-testbed/free5gc-docker-kube "free5gc images")

[The rcc-master and rru-ue-master docker images should already exist in all nodes. ](https://gitlab.lasse.ufpa.br/2020-ai-testbed/ai-testbed/oai-ran-docker/- "RAN-master images")

And all rru nodes should be labeled with:

``kubectl label nodes [NODE NAME] usrp=connected``

[The flexran-controller docker image should already exist in all nodes. ](https://gitlab.lasse.ufpa.br/2020-ai-testbed/ai-testbed/oai-ran-docker/blob/master/flexran-controller/Dockerfile- "Flexran image")

Run in the master node:

``./create.sh``

Example single pod create:

``helm install ./[chart-model] --generate-name --set name=[name]``

## Free5gc Run 

(Only one time) Create uptun interface inside UPF pod: ``/root/setup.sh``

Run in the master node:

``./free5gc-init.sh``

See log (hss example):

``kubectl exec $(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}") -- cat /free5gc/install/var/log/free5gc/free5gc.log``

## OAI-RAN Run 

(Only one time) Configure UE infos inside rru-ue pod: ``./openair3/NAS/TOOLS/ue_eurecom_test_sfr.conf``

(Only one time) Build UE infos inside rru-ue pod: ``./targets/bin/conf2uedata -c ./openair3/NAS/TOOLS/ue_eurecom_test_sfr.conf -o .``

Run in the master node:

``./RAN-init.sh``

PS: For default Flexran is activated, to deactivate use ``./RAN-init.sh flexran_disabled``

## End all

Run in the master node:

``./finish.sh``

## Add subscriber 

(Only in the first time) Run inside webapp container:

``export DB_URI=mongodb://[MONGO IP]:27017/free5gc``

``npm run dev &>/dev/null &``

Now you can acess: http://[WEBAPP NODE]:[WEBAPP NODE PORT]/ with login: admin and password: 1423

ps: get webapp node: ``kubectl describe service webapp`` and get webapp node port: ``kubectl get service webapp``

UE informations should match with the file ``./openair3/NAS/TOOLS/ue_eurecom_test_sfr.conf)`` inside rru-ue container

## Others

## UE internet connection (run in rru-ue-master container)

``ping -I oaitun_ue1 8.8.8.8``

## Watch UE and UPF connection (run in upf container):

``iftop -i uptun``

## List subscribers (run in mongo container):

``mongo``

``use free5gc``

``db.subscribers.find()``

## Debugging helm

Example:

``helm install --dry-run --debug ./oai-ran/ --generate-name``
