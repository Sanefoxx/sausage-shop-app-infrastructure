#!/bin/bash
set +e

echo "${K8SCONFIG}"
echo "${K8SCONFIG}" | base64 -d > .kube/config
set -e

kubectl apply -f ./k8s-deploy/backend
kubectl apply -f ./k8s-deploy/backend-report
kubectl apply -f ./k8s-deploy/frontend

rm .kube/config