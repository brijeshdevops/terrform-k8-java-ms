# Terraform - Provision an EKS Cluster
Creating Kubernetes Cluster using AWS EKS service. We will create Jenkins & Jenkins JNLP Agent docker images and will deploy into EKS nodes. Jenkins JNLP Agent images will be configured as Jenkins Cloud Nodes for build and deploy. This setup helps to achieve Jenkins Master Slave deployments.

- First setup the Terraform
- Install and setup the AWS CLI
- Update provider.tf with new aws cli profile, OR  
  Setup below variables in environment  
  AWS_ACCESS_KEY_ID  
  AWS_SECRET_ACCESS_KEY  
  AWS_DEFAULT_REGION  
  
#### Run Terraform commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan --auto-approve
terraform apply --auto-approve
terraform output
```  

#### Setup Tools
Install kubectl > https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

Setup AWS IAM Authenticator > https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

Setup kubeconfig > https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html

Setup kubectl for newly created EKS cluster using below command

```bash
aws eks --region us-east-2 update-kubeconfig --name devopstools-EKS-Cluster --profile awsprofilename
```

#### Kubectl commands 

```bash
kubectl get nodes
kubectl get pods 
kubectl get deployments
kubectl get all
```
Install the EFS Drivers in EKS Cluster. (https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```

How to expose deployment inside private subnet?

```bash
kubectl expose deployment jenkins --type=LoadBalancer --name=jenkins-external
```

How to do Port Fowarding?

```bash
kubectl port-forward jenkins-pod  7000:8080
```

Other Commands

```bash
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts

eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster nextgen-sandbox-EKS-Cluster --approve --profile awsprofilename
```

#### Terraform Learning

### Store terraform state info in S3 bucket and state locking using DynamoDB.  
- Create S3 bucket  
- Create DynamoDB table with Partition Key name 'LockID'  
- Configure Terraform backend - https://www.terraform.io/docs/backends/types/s3.html  
 

### How to execute kubectl commands from Terraform?

- Refer website: https://gavinbunney.github.io/terraform-provider-kubectl/docs/provider
- For windows download 'terraform-provider-kubectl-windows-386.exe' from website: https://github.com/gavinbunney/terraform-provider-kubectl/releases/tag/v1.5.0
- Rename the file to 'terraform-provider-kubectl.exe' and paste to directory '.terraform/plugins/windows_amd64/' --OR-- directly in root folder of terraform where other .tf files such as provider.tf or so exists.
- Repeate the above steps for Linux based system as well.

### How to scale EKS cluster automatically?

- https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/

### Configure CNI Metrics 
- https://github.com/liwenwu-amazon/amazon-vpc-cni-k8s-1/blob/metrics1/misc/cni_metrics_helper.yaml
- kubectl logs -cni-pod- --namespace kube-system


### Troubleshooting Errors

##### Failure executing: GET at: https://10.100.0.1/api/v1/namespaces/default/endpoints/customers-service. Message: Forbidden!Configured service account doesn't have access. Service account may have been revoked. endpoints "customers-service" is forbidden: User "system:serviceaccount:default:default" cannot get resource "endpoints" in API group "" in the namespace "default".   
- Run below command to give access rights to default namespace of cluster admin so that pods can communicates with pods part of other nodes.

```bash
kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
```      

- Ref: https://github.com/fabric8io/fabric8/issues/6840






