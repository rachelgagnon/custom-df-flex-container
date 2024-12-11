# About

This directory contains Infrastructure-as-Code (IaC) to provision dependent resources to execute the Beam pipeline on a
Dataflow. It is recommended to apply the code in a temporary Google Cloud project isolated from your production
projects.

# Requirements

- [Google Cloud SDK](https://cloud.google.com/sdk); `gcloud init`
  and `gcloud auth`
- Google Cloud project with billing enabled
- [terraform](https://www.terraform.io/)
 
# Usage

Folders (also known as modules) are named in order of intended execution, for example, [01.setup](01.setup), followed by
[02.network](02.network).

An example of applying the module for [01.setup](01.setup) is shown in the following and can be followed for the others.

Set your Google Cloud Project ID:

```
PROJECT=<project id>
```

Set the working module directory.

```
DIR=01.setup
```

Init and apply the module. Note the use of `-var-file=common.tfvars`, a path to
[01.setup/common.tfvars](01.setup/common.tfvars) relative from [01.setup](01.setup) provided in the `-chdir` flag.

```
terraform -chdir=$DIR init
terraform -chdir=$DIR apply -var=project=$PROJECT -var-file=common.tfvars
```

## Usage exception

In [kubernetes](https://kubernetes.io) related modules that only use the
[helm provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs), only apply via
`terraform -chdir=$DIR apply` after
[connecting to the Google Kubernetes Engine cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#default_cluster_kubectl).
