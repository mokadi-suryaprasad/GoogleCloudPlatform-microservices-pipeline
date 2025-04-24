# 🌐 GCP VPC with Public and Private Subnets using Terraform

This project sets up a Virtual Private Cloud (VPC) network on **Google Cloud Platform (GCP)** using **Terraform**. It includes a public subnet, a private subnet, and special IP ranges for Kubernetes clusters.

---

## 📖 Simple Explanation (Basic English)

In Google Cloud, a **VPC (Virtual Private Cloud)** is like your own private space on the internet. You can divide this space into smaller parts called **subnets**.

- The **Public Subnet** is for resources that need internet access, like websites.
- The **Private Subnet** is for internal systems, like databases or apps that don't need to be seen on the internet.

We also added special IP ranges in the private subnet to run **Kubernetes**, which is a system to manage containers (small apps).

We used **Terraform** (an infrastructure-as-code tool) to create all this automatically. It helps make cloud setups easier, faster, and repeatable.

---

## 🗺️ Network Diagram

```text
         +----------------------+
         |     VPC: my-vpc      |
         +----------+-----------+
                    |
        +-----------+------------+
        |                        |
+---------------+        +------------------+
| Subnet: public|        | Subnet: private  |
| 10.0.0.0/19   |        | 10.0.32.0/19     |
| No GKE ranges |        | +---------------+
+---------------+        | | k8s-pods      |
                         | | 172.16.0.0/14 |
                         | +---------------+
                         | | k8s-services  |
                         | | 172.20.0.0/18 |
                         | +---------------+
                         +------------------+
