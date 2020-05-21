#!/bin/bash

HSS_POD=$(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}")
AMF_POD=$(kubectl get pod -l app=amf -o jsonpath="{.items[0].metadata.name}")
UPF_POD=$(kubectl get pod -l app=upf -o jsonpath="{.items[0].metadata.name}")
SMF_POD=$(kubectl get pod -l app=smf -o jsonpath="{.items[0].metadata.name}")
PCRF_POD=$(kubectl get pod -l app=pcrf -o jsonpath="{.items[0].metadata.name}")

MONGO_IP=$(kubectl get pod -l app=mongo -o jsonpath="{.items[0].status.podIP}")
HSS_IP=$(kubectl get pod -l app=hss -o jsonpath="{.items[0].status.podIP}")
AMF_IP=$(kubectl get pod -l app=amf -o jsonpath="{.items[0].status.podIP}")
UPF_IP=$(kubectl get pod -l app=upf -o jsonpath="{.items[0].status.podIP}")
SMF_IP=$(kubectl get pod -l app=smf -o jsonpath="{.items[0].status.podIP}")
PCRF_IP=$(kubectl get pod -l app=pcrf -o jsonpath="{.items[0].status.podIP}")

kubectl exec $HSS_POD -- ./setup-lasse.sh $MONGO_IP $HSS_IP $AMF_IP $UPF_IP $SMF_IP $PCRF_IP &>/dev/null &
echo "HSS initialized"
sleep 30s
kubectl exec $AMF_POD -- ./setup-lasse.sh $MONGO_IP $HSS_IP $AMF_IP $UPF_IP $SMF_IP $PCRF_IP &>/dev/null &
echo "AMF initialized"
sleep 30s
kubectl exec $UPF_POD -- ./setup-lasse.sh $MONGO_IP $HSS_IP $AMF_IP $UPF_IP $SMF_IP $PCRF_IP &>/dev/null &
echo "UPF initialized"
sleep 30s
kubectl exec $SMF_POD -- ./setup-lasse.sh $MONGO_IP $HSS_IP $AMF_IP $UPF_IP $SMF_IP $PCRF_IP &>/dev/null &
echo "SMF initialized"
sleep 30s
kubectl exec $PCRF_POD -- ./setup-lasse.sh $MONGO_IP $HSS_IP $AMF_IP $UPF_IP $SMF_IP $PCRF_IP &>/dev/null &
echo "PCRF initialized"
