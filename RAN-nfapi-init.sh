#!/bin/sh
#################################################################
#  NFPI
###################################################################

PNF_POD=$(kubectl get pod -l app=pnf -o jsonpath="{.items[0].metadata.name}")
VNF_POD=$(kubectl get pod -l app=vnf -o jsonpath="{.items[0].metadata.name}")
FLEXRAN_POD=$(kubectl get pod -l app=flexran-controller -o jsonpath="{.items[0].metadata.name}")

AMF_IP=$(kubectl get pod -l app=amf -o jsonpath="{.items[0].status.podIP}")
VNF_IP=$(kubectl get pod -l app=vnf -o jsonpath="{.items[0].status.podIP}")
PNF_IP=$(kubectl get pod -l app=pnf -o jsonpath="{.items[0].status.podIP}")
FLEXRAN_IP=$(kubectl get pod -l app=flexran-controller -o jsonpath="{.items[0].status.podIP}")

#PNF
#kubectl exec $PNF_POD -- sed -i '102i\  host=NULL;\' ./openair3/NAS/UE/API/USER/user_api.c 
kubectl exec $PNF_POD -- sed -i "s|local_n_if_name.*;|local_n_if_name                    = \"eth0\";|g" ./ci-scripts/conf_files/ue.nfapi.conf
kubectl exec $PNF_POD -- sed -i "s|remote_n_address.*;|remote_n_address                   = \"$VNF_IP\";|g" ./ci-scripts/conf_files/ue.nfapi.conf
kubectl exec $PNF_POD -- sed -i "s|local_n_address.*;|local_n_address                    = \"$PNF_IP\";|g" ./ci-scripts/conf_files/ue.nfapi.conf

#VNF
kubectl exec $VNF_POD -- sed -i "s|mcc = 208;|mcc = 208;|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|mnc = 92;|mnc = 93;|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|ipv4 .*;|ipv4       = \"$AMF_IP\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf

kubectl exec $VNF_POD -- sed -i "s|ens3|eth0|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|ENB_IPV4_ADDRESS_FOR_S1_MME.*;|ENB_IPV4_ADDRESS_FOR_S1_MME              = \"$VNF_IP\/24\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|ENB_IPV4_ADDRESS_FOR_S1U.*;|ENB_IPV4_ADDRESS_FOR_S1U              = \"$VNF_IP\/24\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|ENB_IPV4_ADDRESS_FOR_X2C.*;|ENB_IPV4_ADDRESS_FOR_X2C              = \"$VNF_IP\/24\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf

kubectl exec $VNF_POD -- sed -i "s|local_s_if_name.*;|local_s_if_name  = \"eth0\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|remote_s_address.*;|remote_s_address  = \"$PNF_IP\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|local_s_address.*;|local_s_address  = \"$VNF_IP\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf

#flexran config

kubectl exec $VNF_POD -- sed -i "s|FLEXRAN_ENABLED.*;|FLEXRAN_ENABLED        = \"yes\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|FLEXRAN_INTERFACE_NAME.*;|FLEXRAN_INTERFACE_NAME = \"eth0\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf
kubectl exec $VNF_POD -- sed -i "s|FLEXRAN_IPV4_ADDRESS.*;|FLEXRAN_IPV4_ADDRESS   = \"$FLEXRAN_IP\";|g" ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf

#confirm its off 
kubectl exec $PNF_POD -- killall lte-uesoftmodem.Rel15
kubectl exec $VNF_POD -- killall lte-softmodem.Rel15
kubectl exec $FLEXRAN_POD -- killall rt_controller

#run
kubectl exec $FLEXRAN_POD -- ./run_flexran_rtc.sh  > /dev/null 2>&1 &
kubectl exec $VNF_POD -- sudo -E ./targets/bin/lte-softmodem.Rel15 -O ./ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf> /dev/null 2>&1 &
sleep 5s
kubectl exec $PNF_POD -- sudo -E ./targets/bin/lte-uesoftmodem.Rel15 -O ./ci-scripts/conf_files/ue.nfapi.conf --L2-emul 3 --num-ues 4 --nokrnmod 1 > /dev/null 2>&1 &
sleep 10s

echo "----------------------------------------------------------"
echo "RAN initialized"
