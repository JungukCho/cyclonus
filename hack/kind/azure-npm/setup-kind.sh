#!/usr/bin/env bash

set -e
set -xv

CLUSTER=${CLUSTER:-netpol-azure-npm}


kind create cluster --name "$CLUSTER" --config kind-config.yaml
until kubectl cluster-info;  do
    echo "$(date)waiting for cluster..."
    sleep 2
done


kubectl get nodes
kubectl get all -A

kubectl wait --for=condition=ready nodes --timeout=5m --all

kubectl get nodes
kubectl get all -A

AZURE_NPM_YAML="azure-npm.yaml"
AZURE_NPM_IMAGE="acnpublic.azurecr.io/azure-npm:endport"
AZURE_NPM_NS="kube-system"
AZURE_NPM_LABEL="k8s-app=azure-npm"

sed -i 's/mcr.microsoft.com\/containernetworking\/azure-npm:v1.4.1/acnpublic.azurecr.io\/azure-npm:endport/' $AZURE_NPM_YAML
docker pull $AZURE_NPM_IMAGE
kind load docker-image $AZURE_NPM_IMAGE --name $CLUSTER
kubectl apply -f $AZURE_NPM_YAML

kubectl wait --for=condition=ready pod -l $AZURE_NPM_LABEL -n $AZURE_NPM_NS