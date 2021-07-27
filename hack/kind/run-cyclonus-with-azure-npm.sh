#!/bin/bash


echo "start running cyclonus"
JOB_NS="netpol"
JOB_NAME="job.batch/cyclonus"
kubectl create ns netpol
kubectl create clusterrolebinding cyclonus --clusterrole=cluster-admin --serviceaccount=netpol:cyclonus
kubectl create sa cyclonus -n netpol
kubectl create -f ./azure-npm/cyclonus-job.yaml -n netpol

# wait for job to start running
# TODO there's got to be a better way to do this
sleep 30
kubectl get all -A

kubectl wait --for=condition=ready pod -l job-name=cyclonus -n $JOB_NS --timeout=5m
kubectl logs -f -n $JOB_NS $JOB_NAME

# grab the job logs
LOG_FILE=cyclonus-test.txt
kubectl logs -n kube-system job.batch/cyclonus | tee "$LOG_FILE"
cat "$LOG_FILE"