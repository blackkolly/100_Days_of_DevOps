One of the DevOps engineers was trying to deploy a python app on Kubernetes cluster. Unfortunately, due to some mis-configuration, 
the application is not coming up. Please take a look into it and fix the issues. Application should be accessible on the specified nodePort.

The deployment name is python-deployment-xfusion, its using poroko/flask-demo-appimage. The deployment and service of this app is already deployed.
nodePort should be 32345 and targetPort should be python flask app's default port
Note: The kubectl on jump_host has been configured to work with the kubernetes cluster.


Here are the commands used to troubleshoot and fix the issue:

Troubleshooting Steps:
# Check deployment status
kubectl get deployment python-deployment-xfusion
kubectl describe deployment python-deployment-xfusion

# Check service configuration
kubectl get svc -o wide | grep python


Fix Commands:

# Fix 1: Correct the image name from poroko/flask-demo-appimage to poroko/flask-demo-app
kubectl set image deployment/python-deployment-xfusion python-container-xfusion=poroko/flask-demo-app

# Fix 2: Update service port from 8080 to 5000 and targetPort to 5000
kubectl patch svc python-service-xfusion --type='json' -p='[{"op": "replace", "path": "/spec/ports/0/port", "value":5000},{"op": "replace", "path": "/spec/ports/0/targetPort", "value":5000}]'

# Wait for rollout to complete
kubectl rollout status deployment/python-deployment-xfusion
```

Verification:

kubectl get deployment python-deployment-xfusion
kubectl get pods -l app=python_app
kubectl get svc python-service-xfusion
```

Issues Fixed:
1. Image name typo: `poroko/flask-demo-appimage` → `poroko/flask-demo-app`
2. Service port: `8080` → `5000` (Flask default port)
3. TargetPort: `5000` (matching container port)
