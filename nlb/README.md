# Network LoadBalancer

This module is responsible to launch a [NLB](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) resource on AWS.

## Listeners and Target Groups

Your new NLB will demand a Listener (or more than one) and Target Groups. 

You can define everything using `var.listeners` which is a list of objects.

In the following example 2 listeners and related target groups will be created: 

* Listener on port 443 with protocol TLS which will `forward` traffic to the the new Target Group on port 32500
* Listener on port 31000 with protocol TCP which will `forward` traffic to the new Target Group on port 31500

```
  listeners = [
    {
      port = 443
      protocol = "TLS"
      target_groups = {
        port = 32500
      }
    },
    {
      port = 31000
      protocol = "TCP",
      target_groups = {
        port = 31000
      }
    }
  ]
```
If you want to use the Target Groups created (eg. set an ASG), you can get the output `target_groups_arns` of this module and attach in your ASG.

## Usage with K8S
When using a NLB with Kubernetes, we need to deal with special Security Groups on the worker level (instance), this module implemented to cover this scenario and manage all the Security Groups which you can just attach on your worker later.

If you intend to use NLB with K8S, simply set the `var.security_group_for_eks` with the port you want to open and, the cidr_block.
Doing this, you can get the output `security_group_k8s` of this module and attach on your EKS. 

```
  security_group_for_eks = [
    {
      port = 32500
      cidr_block = ["10.0.0.0/16"] 
    },
    {
      port = 31000
      cidr_block = ["0.0.0.0/0"]
    }
  ]
```
