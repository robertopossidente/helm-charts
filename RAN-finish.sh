#!/bin/bash

#HSS_POD=$(kubectl get pod -l app=hss -o jsonpath="{.items[0].metadata.name}")
#AMF_POD=$(kubectl get pod -l app=amf -o jsonpath="{.items[0].metadata.name}")
#UPF_POD=$(kubectl get pod -l app=upf -o jsonpath="{.items[0].metadata.name}")
#SMF_POD=$(kubectl get pod -l app=smf -o jsonpath="{.items[0].metadata.name}")
#PCRF_POD=$(kubectl get pod -l app=pcrf -o jsonpath="{.items[0].metadata.name}")
#
RRU_POD=$(kubectl get pod -l app=rru-ue-master -o jsonpath="{.items[0].metadata.name}")
RCC_POD=$(kubectl get pod -l app=rcc-master -o jsonpath="{.items[0].metadata.name}")
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
kubectl exec $RRU_POD -- killall lte-uesoftmodem.Rel14
kubectl exec $RCC_POD -- killall lte-softmodem.Rel14
kubectl exec $FLEXRAN_POD -- killall run_flexran_rtc
echo "RAN finished"


