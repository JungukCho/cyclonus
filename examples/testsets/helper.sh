#!/bin/bash

argc=$#

if [[ $argc -ne 1 ]]
then
    echo "[deploy] [clean]"
    exit -1
fi

command=$1
namespaces=(
    "x"
    "y"
    "z"
)
pods=(
    "a"
    "b"
    "c"
)

netpol="netpol.yaml"
case $command in
"deploy")
    for ns in ${namespaces[@]}
    do
        kubectl apply -f ns-$ns.yaml
        for pod in ${pods[@]}
        do
            kubectl apply -f $ns-$pod.yaml
            #kubectl wait --for=condition=ready pod $pod -n $ns
        done
    done
    kubectl apply -f $netpol
    ;;
"clean")
    kubectl delete -f $netpol
    for ns in ${namespaces[@]}
    do
        kubectl delete ns $ns
    done
    ;;
*)
    echo "Unknown command: " $command
    ;;
esac