# Kubernetes Architecture
Kubernetes (K8s) is a container orchestration platform that manages containerized applications across a cluster of machines.

It follows a **Master-Worker architecture** (now commonly called **Control Plane + Worker Nodes**).

## 🧠 1️⃣ Control Plane (Master Node)

The Control Plane manages the entire cluster. It makes decisions about scheduling, scaling, and maintaining desired state.

<img width="1402" height="882" alt="image" src="https://github.com/user-attachments/assets/bf8206c2-ea2a-40dd-8067-66273d4b5070" />

## 🔹 Components of Control Plane
- **1️⃣ kube-apiserver**
- **2️⃣ etcd**
- **3️⃣ kube-scheduler**
- **4️⃣ kube-controller-manager**
- **5️⃣ cloud-controller-manager**


**🧠 Kubernetes Control Plane Components**
🔹 1️⃣ kube-apiserver (The Brain / Front Door)

👉 Main role: Entry point of the cluster

All communication goes through API Server.
- kubectl → API Server
- kubelet → API Server
- controllers → API Server
- scheduler → API Server

**Note:** It is the only component that talks to etcd directly.

**🔥 Internal Flow of kube-apiserver (Very Important for Interviews)**
When you run:

```
kubectl apply -f deployment.yaml
```

The request flows like this:

✅ Step 1: Authentication (Who are you?)

API Server checks identity.

Methods:
- Client certificates
- Bearer tokens
- Service accounts
- OIDC
- Cloud IAM (GKE/EKS/AKS)

👉 **Example:** Are you a valid DevOps engineer or not?

✅ Step 2: Authorization (What can you do?)

After identity is verified → check permissions.

Handled by:
- RBAC (most common)
- ABAC
- Node authorizer
- Webhook

👉 **Example:** 
- Can Arvind create deployments?
- Can he delete pods?
- Can he access secrets?

If not allowed → request denied here.

✅ Step 3: Admission Controllers (Final Gate)

Now API Server modifies or validates request.

**Two types:**
- Mutating Admission Controller → modifies request
- Validating Admission Controller → approves/rejects request

**Examples:**
- LimitRanger
- NamespaceLifecycle
- PodSecurity
- ResourceQuota

👉 **Example:**
If namespace CPU limit exceeded → request rejected.

✅ Step 4: Store in etcd

If everything passes → object stored in **etcd**.

etcd = cluster database.

✅ Step 5: Watch Mechanism (Very Important Concept)

Controllers & kubelets use:

```
WATCH API
```

They continuously watch for changes.

Example:
- New Pod created → Scheduler sees it
- Pod assigned to node → kubelet sees it
- Pod deleted → controller recreates it

👉 Kubernetes is event-driven.

🔹 2️⃣ etcd (Cluster Database)

- Distributed key-value store
- Stores:
  - Pods
  - Deployments
  - Secrets
  - ConfigMaps
  - Node info
- Uses RAFT consensus
- Highly consistent

⚠️ If etcd is lost → cluster state is lost

🔹 3️⃣ kube-scheduler (Decision Maker)

👉 Role: Assign Pod to Node

When new Pod is created:

1. Scheduler watches for unscheduled pods
2. Filters nodes (CPU, memory, taints, affinity)
3. Scores nodes
4. Selects best node
5. Updates API Server

Scheduler does NOT create pods — it just assigns node.

🔹 4️⃣ kube-controller-manager (Desired State Manager)

Runs multiple controllers.

Example controllers:
- ReplicaSet controller
- Deployment controller
- Node controller
- Job controller
- Endpoint controller

👉 Uses reconciliation loop:

```
Desired State != Current State → Fix it
```

**Example:**
Desired replicas = 3
Running pods = 2
→ Controller creates 1 more

🔹 5️⃣ cloud-controller-manager

👉 Only used in cloud environments (GKE, EKS, AKS)

It connects Kubernetes with cloud provider APIs.

Handles:
- Load Balancer creation
- Node lifecycle
- Route tables
- Persistent volumes

**Example:**
When you create:

```
type: LoadBalancer
```

Cloud controller:
→ Calls AWS / GCP API
→ Creates actual Load Balancer

**🎯 Interview-Ready Summary (Strong Answer)**

The Kubernetes Control Plane consists of kube-apiserver, etcd, kube-scheduler, kube-controller-manager, and cloud-controller-manager.
The API Server acts as the entry point and processes requests through authentication, authorization, and admission control before storing state in etcd.
Controllers and scheduler watch for changes using the watch API and continuously reconcile the cluster to maintain the desired state.
