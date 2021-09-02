### Test debug funcationality on Azure-NPM
1. Deploy pods and network policy
```shell
./helper.sh deploy
```

2. Access to npm pod and then run below commands
```shell
pod=$(kubectl get pods -l k8s-app=azure-npm -n kube-system -o jsonpath={.items..metadata.name} | awk '{print $1}'); kubectl exec $pod -n kube-system -it bash

# inside the docker    

azure-npm debug gettuples -s y/a -d x/a
&{RuleType:NOT ALLOWED Direction:INGRESS SrcIP:ANY SrcPort:ANY DstIP:10.240.0.21 DstPort:ANY Protocol:ANY}

azure-npm debug gettuples -s x/c -d x/a
&{RuleType:NOT ALLOWED Direction:INGRESS SrcIP:ANY SrcPort:ANY DstIP:10.240.0.21 DstPort:ANY Protocol:ANY}
&{RuleType:ALLOWED Direction:INGRESS SrcIP:10.240.0.7 SrcPort:ANY DstIP:10.240.0.21 DstPort:80 Protocol:tcp}

azure-npm debug gettuples -s x/a -d y/b
&{RuleType:ALLOWED Direction:EGRESS SrcIP:10.240.0.21 SrcPort:ANY DstIP:ANY DstPort:443 Protocol:tcp}
&{RuleType:ALLOWED Direction:EGRESS SrcIP:10.240.0.21 SrcPort:ANY DstIP:10.240.0.28 DstPort:80 Protocol:tcp}
&{RuleType:NOT ALLOWED Direction:EGRESS SrcIP:10.240.0.21 SrcPort:ANY DstIP:ANY DstPort:ANY Protocol:ANY}
```
