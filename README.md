# Production-Grade YOLOv8 Object Detection Web App

This project is a web application that leverages YOLOv8 to detect objects in images. Users can upload an image through an intuitive interface, and the application uses advanced AI to identify and annotate objects in real time. The app runs inside a Docker container to ensure consistency across environments, and a Helm chart is provided for easy deployment on a Kubernetes cluster. All infrastructure—including VPC, IRSA, EKS, and key Helm releases—is provisioned using Terraform for a fully automated, scalable, and production-ready environment.

---

## Tech Stack

- **YOLOv8:** State-of-the-art deep learning model for real-time object detection.
- **Docker:** Containerises the web application for consistent and portable deployments.
- **Kubernetes:** Orchestrates containerised workloads for scalability and high availability.
- **Helm:** Simplifies deployment and management of the application on Kubernetes.
- **Terraform:** Automates the provisioning of infrastructure such as VPC, EKS, and IRSA, along with Helm releases.
- **ArgoCD:** Implements GitOps for continuous deployment and configuration management.
- **Prometheus:** Collects and aggregates metrics from the application and infrastructure.
- **Grafana:** Visualises metrics through interactive dashboards.
- **Nginx Ingress Controller:** Manages external traffic routing to the Kubernetes cluster.
- **Cert Manager:** Automates SSL/TLS certificate management.
- **External DNS:** Dynamically manages DNS records for the cluster.

---

## Architecture Diagram

![Architecture Diagram](/images/architectural-diagram.png)

---

## Architecture Overview

The deployment architecture is designed to be scalable, secure, and fully automated. Key components include:

1. **Route 53 and ALB**: DNS routing is handled via AWS Route 53, with HTTPS traffic secured using SSL certificates managed by cert-manager and terminated at an Application Load Balancer (ALB).
2. **EKS Cluster**: The application is hosted on an AWS EKS cluster, with worker nodes distributed across multiple availability zones for fault tolerance.
3. **GitOps with ArgoCD**: Continuous delivery is automated using ArgoCD, ensuring the Kubernetes cluster state reflects the desired state defined in Git repositories.
4. **Terraform**: Infrastructure provisioning and state management are fully automated using Terraform, with state locking enabled via DynamoDB and S3.
5. **Monitoring**: Prometheus collects detailed metrics, while Grafana visualises these metrics with customised dashboards for actionable insights.
6. **CI/CD Pipeline**: GitHub Actions automates application builds, containerisation (Docker), and deployments to EKS.


---

## Features

1. **User-Friendly Image Upload:**
   - A responsive web interface enables users to easily upload images.
   - The application quickly processes the image with YOLOv8, returning annotated results.

2. **Advanced Object Detection:**
   - Utilises YOLOv8 for high-accuracy, real-time object detection.
   - Provides detailed annotations and metadata for each detected object.

3. **Containerised and Scalable Deployment:**
   - Docker ensures a consistent runtime environment across all deployments.
   - The provided Helm chart simplifies deployment on Kubernetes, enabling easy scaling and maintenance.

4. **Infrastructure as Code:**
   - Terraform provisions and manages all infrastructure components, including VPC, EKS, and IRSA.
   - Automates Helm releases for essential services (Nginx Ingress Controller, Cert Manager, External DNS, ArgoCD, Prometheus-Kube-Stack), ensuring consistency and reproducibility.

5. **Automated CI/CD and GitOps:**
   - GitHub Actions streamline the build, test, and deployment processes.
   - ArgoCD maintains the desired state of the Kubernetes cluster through a robust GitOps workflow.

6. **Comprehensive Monitoring:**
   - Prometheus and Grafana provide real-time insights into application performance and infrastructure health.
   - Custom dashboards and alerts enable proactive troubleshooting and performance optimisation.

---

### Prometheus and Grafana Dashboard

Prometheus and Grafana are integrated to deliver in-depth monitoring and observability:

- **Prometheus:** Collects metrics from the YOLOv8 application, Docker containers, and Kubernetes components.
- **Grafana:** Visualises these metrics using interactive dashboards, providing insights into CPU usage, memory consumption, network traffic, and object detection performance.

#### Key Monitoring Features:
- **Real-Time Metrics:** Live dashboards display performance data and system health.
- **Custom Alerts:** Alerts are configured to ensure rapid detection and response to any issues.

![Grafana Dashboard](/images/grafana.png)
*Grafana dashboard displaying real-time metrics of the application and infrastructure.*

---

## Terraform Infrastructure Provisioning

Terraform automates the setup and management of the entire infrastructure, ensuring a consistent and scalable environment:

- **VPC:** A dedicated Virtual Private Cloud for secure and isolated network configuration.
- **EKS Cluster:** A managed Kubernetes service for running containerised applications.
- **IRSA (IAM Roles for Service Accounts):** Provides secure, fine-grained IAM permissions for Kubernetes workloads.
- **Helm Releases Managed by Terraform:**
  - **Nginx Ingress Controller:** Manages and routes external HTTP/S traffic.
  - **Cert Manager:** Automates SSL/TLS certificate management.
  - **External DNS:** Dynamically manages DNS records.
  - **ArgoCD:** Enables GitOps for continuous, automated deployments.
  - **Prometheus-Kube-Stack:** Offers full-stack monitoring for both the Kubernetes cluster and the deployed application.

---

## Running Application Screenshot

Below is a screenshot of the YOLOv8 object detection web application running in production.

![Running YOLOv8 App](/images/object-detection-app.png)
*Screenshot of the YOLOv8 object detection web application in action.*

---

## ArgoCD
ArgoCD is used to implement a GitOps workflow, ensuring that the Kubernetes cluster state is always in sync with the desired state defined in Git repositories.

### Key Features:
- Automated Deployments: ArgoCD continuously monitors the Git repository for changes and applies them to the cluster. 
- Declarative Configuration: All resources, including deployments, services, and ingress rules, are defined as code in Git.
- Application Health Monitoring: The ArgoCD dashboard provides real-time application health and sync status, ensuring transparency and traceability.

![alt text](/images/argocd.png)