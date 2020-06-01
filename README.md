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

## Create 5G modules pods

``helm install ./free5gc --generate-name --set name=mongo``

``helm install ./free5gc --generate-name --set name=hss``

``helm install ./free5gc --generate-name --set name=amf``

``helm install ./free5gc --generate-name --set name=upf``

``helm install ./free5gc --generate-name --set name=smf``

``helm install ./free5gc --generate-name --set name=pcrf``

``helm install ./free5gc --generate-name --set name=webapp``

## Create OAI-RAN pods

The rcc-master and rru-ue-master docker images should already exist in all nodes. And all rru nodes should be labeled with:

``kubectl label nodes [NODE NAME] usrp=connected``

After this, run (in order):

``helm install ./oai-ran/ --generate-name --set name=rru-ue-master``

``helm install ./oai-ran/ --generate-name --set name=rcc-master``

## Free5gc Run 

(Only one time) Inside UPF container:

```
apt-get install net-tools
ip tuntap add name uptun mode tun
ip addr add 45.45.0.1/16 dev uptun
ip link set uptun up
sh -c "echo 'net.ipv6.conf.uptun.disable_ipv6=0' > /etc/sysctl.d/30-free5gc.conf"
ip addr add cafe::1/64 dev uptun
sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I INPUT -i uptun -j ACCEPT
```

Run in the master node:

``./free5gc-init.sh``

See log (hss example):

``kubectl exec $(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}") -- cat /free5gc/install/var/log/free5gc/free5gc.log``

## OAI-RAN Run 

(Only one time) run inside rru-ue container:

``./targets/bin/conf2uedata -c ./openair3/NAS/TOOLS/ue_eurecom_test_sfr.conf -o .``

Run in the master node:

``./RAN-init.sh``

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
