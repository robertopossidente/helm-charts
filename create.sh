#!/bin/bash

helm install ./free5gc --generate-name --set name=mongo
helm install ./free5gc --generate-name --set name=hss
helm install ./free5gc --generate-name --set name=amf
helm install ./free5gc --generate-name --set name=upf
helm install ./free5gc --generate-name --set name=smf
helm install ./free5gc --generate-name --set name=pcrf
helm install ./free5gc --generate-name --set name=webapp

helm install ./oai-ran/ --generate-name --set name=rru-ue-master
helm install ./oai-ran/ --generate-name --set name=rcc-master
helm install ./simplechart/ --generate-name --set name=flexran-controller
