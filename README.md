# Get started with terraform
```shell
cd terraform/sausage-store
terraform init
terraform plan -var yc_token=${YANDEX_CLOUD_TOKEN}
terraform apply -var yc_token=${YANDEX_CLOUD_TOKEN}
terraform destroy -var yc_token=${YANDEX_CLOUD_TOKEN}
```

After applying terraform will create inventory for ansible

# Get started with ansible
```shell
cd ansible
ansible-playbook playbook -i inventory
```
you should insert nexus repo login/password to console after run playbook

# Get started with K8s
You should export KUBE_CONFIG
```shell
kubectl apply -f backend backend-report frontend
```
# Get started with Helm
You should export KUBE_CONFIG
```shell
helm install sausage-store ./sausage-store-chart
```
