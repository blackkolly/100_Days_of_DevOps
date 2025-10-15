The Nautilus DevOps team is diving into Kubernetes for application management. One team member has a task to create a pod according to the details below:

Create a pod named pod-httpd using the httpd image with the latest tag. Ensure to specify the tag as httpd:latest.
Set the app label to httpd_app, and name the container as httpd-container.
Note: The kubectl utility on jump_host is configured to operate with the Kubernetes cluster.

Option 1 — Using `kubectl run

kubectl run pod-httpd \
  --image=httpd:latest \
  --labels=app=httpd_app \
  --restart=Never \
  --name=httpd-container

Explanation

image=httpd:latest` → Uses the latest httpd image.
labels=app=httpd_app` → Adds label `app=httpd_app`.
restart=Never` → Creates a pod (not a Deployment).
name=httpd-container` → Names the container inside the pod.

Option 2 — Using a YAML manifest 

Create a file `/tmp/pod-httpd.yaml`:

apiVersion: v1
kind: Pod
metadata:
  name: pod-httpd
  labels:
    app: httpd_app
spec:
  containers:
  - name: httpd-container
    image: httpd:latest

Apply it:
kubectl apply -f /tmp/pod-httpd.yaml

Step 3 — Verify the pod

kubectl get pods -l app=httpd_app

Expected output:

NAME        READY   STATUS    RESTARTS   AGE
pod-httpd   1/1     Running   0          10s
