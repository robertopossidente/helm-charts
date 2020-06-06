#!/bin/bash

VNF_POD=$(kubectl get pod -l app=vnf -o jsonpath="{.items[0].metadata.name}")
PNF_POD=$(kubectl get pod -l app=pnf -o jsonpath="{.items[0].metadata.name}")
FLEXRAN_POD=$(kubectl get pod -l app=flexran-controller -o jsonpath="{.items[0].metadata.name}")

kubectl exec $PNF_POD -- killall lte-uesoftmodem.Rel15
kubectl exec $VNF_POD -- killall lte-softmodem.Rel15
kubectl exec $FLEXRAN_POD -- killall rt_controller
echo "RAN NFAPI finished"


