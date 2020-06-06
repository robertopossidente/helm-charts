#!/bin/bash

#HSS_POD=$(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}")
#AMF_POD=$(kubectl get pod -l app=amf -o jsonpath="{.items[0].metadata.name}")
#UPF_POD=$(kubectl get pod -l app=upf -o jsonpath="{.items[0].metadata.name}")
#SMF_POD=$(kubectl get pod -l app=smf -o jsonpath="{.items[0].metadata.name}")
#PCRF_POD=$(kubectl get pod -l app=pcrf -o jsonpath="{.items[0].metadata.name}")
#
VNF_POD=$(kubectl get pod -l app=vnf -o jsonpath="{.items[0].metadata.name}")
PNF_POD=$(kubectl get pod -l app=pnf -o jsonpath="{.items[0].metadata.name}")
FLEXRAN_POD=$(kubectl get pod -l app=flexran-controller -o jsonpath="{.items[0].metadata.name}")

#
#kubectl exec $HSS_POD -- pkill -9 nextepc
#kubectl exec $HSS_POD -- rm /free5gc/install/var/log/free5gc/free5gc.log
#echo "HSS finished"
#kubectl exec $AMF_POD -- pkill -9 free5gc
#kubectl exec $AMF_POD -- rm /free5gc/install/var/log/free5gc/free5gc.log
#echo "AMF finished"
#kubectl exec $UPF_POD -- pkill -9 free5gc
#kubectl exec $UPF_POD -- rm /free5gc/install/var/log/free5gc/free5gc.log
#echo "UPF finished"
#kubectl exec $SMF_POD -- pkill -9 free5gc
#kubectl exec $SMF_POD -- rm /free5gc/install/var/log/free5gc/free5gc.log
#echo "SMF finished"
#kubectl exec $PCRF_POD -- pkill -9 nextepc
#kubectl exec $PCRF_POD -- rm /free5gc/install/var/log/free5gc/free5gc.log
#echo "PCRF finished"
kubectl exec $PNF_POD -- killall lte-uesoftmodem.Rel15
kubectl exec $VNF_POD -- killall lte-softmodem.Rel15
kubectl exec $FLEXRAN_POD -- killall rt_controller
echo "RAN NFAPI finished"


