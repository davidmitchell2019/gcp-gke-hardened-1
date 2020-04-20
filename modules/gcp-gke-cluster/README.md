# gke-cluster 
Deploys gke cluster

Equivalent to running the gcloud command below:

```
gcloud container clusters create [cluster_name] \
    --zone=europe-west2 \
    --enable-ip-alias \
    --machine-type=n1-standard-2 \
    --num-nodes=1 \
    --disk-size 10 \
    --network=[network]  \
    --subnetwork=[subnetwork] \
    --cluster-secondary-range-name=[pods-range] \
    --services-secondary-range-name=[services-range] \
    --enable-private-nodes \
    --enable-private-endpoint \
    --enable-master-authorized-networks \
    --master-authorized-networks 10.64.0.0/24 \
    --master-ipv4-cidr 172.16.128.0/28 \
    --no-enable-basic-auth \
    --no-issue-client-certificate \
    --service-account=[service-account]
```

# TODO
* Instance labelling
