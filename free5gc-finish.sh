#!/bin/bash

HSS_POD=$(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}")
AMF_POD=$(kubectl get pod -l app=amf -o jsonpath="{.items[0].metadata.name}")
UPF_POD=$(kubectl get pod -l app=upf -o jsonpath="{.items[0].metadata.name}")
SMF_POD=$(kubectl get pod -l app=smf -o jsonpath="{.items[0].metadata.name}")
PCRF_POD=$(kubectl get pod -l app=pcrf -o jsonpath="{.items[0].metadata.name}")

kubectl exec $HSS_POD -- pkill -9 nextepc
echo "HSS finished"
kubectl exec $AMF_POD -- pkill -9 free5gc
echo "AMF finished"
kubectl exec $UPF_POD -- pkill -9 free5gc
echo "UPF finished"
kubectl exec $SMF_POD -- pkill -9 free5gc
echo "SMF finished"
kubectl exec $PCRF_POD -- pkill -9 nextepc
echo "PCRF finished"
