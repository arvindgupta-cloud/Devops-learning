# gRPC 

gRPC = google Remote Procedure Call

It is a high-performance RPC framework developed by Google that allows services to communicate efficiently.

It is widely used in:

- Microservices architectures
- Kubernetes-based systems
- Cloud-native applications
- Internal service-to-service communication

**🧠 1️⃣ What Problem Does gRPC Solve?**
Traditional REST APIs:
- Use HTTP/1.1
- Use JSON (large payload)
- Slower for internal microservices
- Text-based

gRPC:
- Uses HTTP/2
- Uses Protocol Buffers (binary)
- Faster, smaller, strongly typed
- Supports streaming

**⚙️ 2️⃣ How gRPC Works**

**Step 1️⃣ Define Service using Protocol Buffers**
```
syntax = "proto3";

service UserService {
  rpc GetUser (UserRequest) returns (UserResponse);
}

message UserRequest {
  int32 id = 1;
}

message UserResponse {
  string name = 1;
  string email = 2;
}
```

This .proto file defines:
- Service
- Request
- Response structure

**Step 2️⃣ Generate Code**

Using `protoc` compiler → generates:
- Server stub
- Client stub

Supported languages:
- Go
- Java
- Python
- Node.js
- C++

**Step 3️⃣ Communication Flow**

- Client calls method like local function
- Stub serializes request (Protobuf)
- HTTP/2 sends request
- Server processes
- Response returned in binary

## 🔥 3️⃣ Key Features of gRPC
✅ 1. HTTP/2 Based
- Multiplexing
- Header compression
- Single TCP connection
- Faster than HTTP/1.1

✅ 2. Protocol Buffers (Protobuf)
- Binary format
- Smaller than JSON
- Strict schema
- Versioning support

✅ 3. Streaming Support
- gRPC supports 4 types:
- Unary (normal request-response)
- Server Streaming
- Client Streaming
- Bidirectional Streaming

**Example:**

``` 
rpc StreamUsers(UserRequest) returns (stream UserResponse);
```

✅ 4. Strongly Typed Contracts
- Schema-first development.
- Breaking changes are controlled.

**🏗️ 4️⃣ gRPC in Microservices (Kubernetes Context)**

Since you're working with Kubernetes & CI/CD:

In a microservices cluster:

`Frontend → API Gateway → gRPC services → DB`

**Why companies use gRPC internally:**
- Faster inter-service communication
- Lower latency
- Reduced bandwidth
- Better performance at scale

In Kubernetes:
- Pods talk via ClusterIP service
- Often used with Service Mesh (Istio)
- Works well with Envoy proxy

**⚡ 5️⃣ gRPC vs REST**

| Feature         | gRPC                   | REST        |
| --------------- | ---------------------- | ----------- |
| Protocol        | HTTP/2                 | HTTP/1.1    |
| Format          | Binary (Protobuf)      | JSON        |
| Speed           | Faster                 | Slower      |
| Streaming       | Yes                    | Limited     |
| Browser Support | Limited                | Excellent   |
| Use Case        | Internal microservices | Public APIs |

**🔐 6️⃣ Security**
- TLS by default
- mTLS supported
- Works well with service mesh
- Authentication via metadata (JWT, OAuth)
