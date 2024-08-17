## Get Token to connect EC2 to EKS
```shell
TOKEN=$(aws eks get-token --cluster-name my-eks-cluster --query 'status.token' --output text)
kubectl config set-credentials eks-user --token=$TOKEN

# Maybe we don't need those two step above
aws eks update-kubeconfig --region ap-southeast-1 --name my-eks-cluster
kubectl config set-context --current --user=eks-user
kubectl get pods
```

## Create IAM Role for installing "Amazon EBS CSI Driver" Addon
```shell
export AWS_REGION=ap-southeast-1
eksctl utils associate-iam-oidc-provider --region=ap-southeast-1 --cluster=my-eks-cluster --approve
eksctl create iamserviceaccount \
        --name ebs-csi-controller-sa \
        --namespace kube-system \
        --cluster my-eks-cluster \
        --role-name AmazonEKS_EBS_CSI_DriverRole \
        --role-only \
        --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
        --approve
```

## Allow EC2 Role ARN to connect
`kubectl edit configmap aws-auth -n kube-system`
```yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::992382727045:role/eks-node-role
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:masters
      rolearn: arn:aws:iam::992382727045:role/ec2_role
      username: ec2-user
kind: ConfigMap
metadata:
  creationTimestamp: "2024-08-11T03:34:15Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "16120"
  uid: 6afd258a-71ff-44f5-bddc-69d102229754
```

## K8S install ingress
```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.1/deploy/static/provider/cloud/deploy.yaml
kubectl get pods --namespace=ingress-nginx | grep nginx
kubectl apply -f ingress.yml
kubectl get ingress -o wide
```


## Prometheus - Grafana | Helm (Built in - not AWS managed service)

```shell
 helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
 help repo update
 helm install prometheus prometheus-community/prometheus \                            
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"
```

```shell
helm install grafana grafana/grafana \
--namespace grafana \
--set persistence.storageClassName="gp2" \
--set persistence.enabled=true \
--set adminPassword='EKS!sAWSome' \
--values /Users/kietlyc/hometemp/nashtech-assignment/sd2139-msa/grafana.yaml \
--set service.type=LoadBalancer

export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "http://$ELB"
 kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

## Jenkins

### Plugin List
- NodeJS
- Pipeline Utility Steps
- SSH Agent

### Config Stuff

```shell
# Create Keypairs for Github authentication so we can push code later - then add the public key to Github
ssh-keygen -t rsa -b 4096 -C "kiet-jenkins@example.com"
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa 

# Git Host Key Verification Configuration - Change to Accept first connection to pass the host certificate check
```