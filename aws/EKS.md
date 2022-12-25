# Steps to create 

1. Create a user in IAM
2. Run eksctl command 

```
export AWS_ACCESS_KEY=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=
eksctl get clusters
eksctl create cluster cluster-name
eksctl delete cluster cluster-name
```

## Selecting worker sizing
```bash
eksctl get nodegroups --cluster cluster-name 
```

```
eksctl create nodegroup --node-type m5.large --cluster cluster-name --name bottlerocket --node-ami-family Bottlerocket 
```

```bash
eksctl delete nodegroup --cluster cluster-name node-group-name
```

## Creating scaling worker pools

1. Create node group 
```
eksctl create nodegroup --node-type m5.large --name asgscale --cluster cluster-name --asg-access --nodes-min 1 --nodes-max 3
```

2. Go to auto scaling groups -> automatic scaling groups
3. 
