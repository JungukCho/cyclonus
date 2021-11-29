#!/bin/bash

argc=$#


if [[ $argc -ne 1 ]]
then
    echo "[cyclonous output]"
    exit -1
fi

cyclonous_output=$1
cyclonous_output_netpol=$cyclonous_output"-netpol.txt"
NETPOLS_YAML=$cyclonous_output".yaml"
# grep network policy definitions
perl -lne 'print if /apiVersion: networking.k8s.io\/v1/ .. /Egress/' $cyclonous_output > $cyclonous_output_netpol
cut -d " " -f 2- $cyclonous_output_netpol  > $NETPOLS_YAML
sed -i 's/- Egress/- Egress\n---/' $NETPOLS_YAML


line=1
index=0
while read LINE
do
    if [[ $LINE == *"name: base"* ]]
    then
        echo $line
        lineNum=$line"s"
        # to rename name filed in network policy to make the name field in network policy unique
        sed -i "$lineNum/name: base/name: base-$index/" $NETPOLS_YAML
        index=$((index+1))
    fi    
line=$((line+1))
done < $NETPOLS_YAML


# # create namespace before deploy network policies 
# kubectl create ns x
# kubectl create ns y
# kubectl create ns z

# sleep 3
# kubectl apply -f $NETPOLS_YAML
