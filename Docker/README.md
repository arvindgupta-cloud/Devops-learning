**Multi-staged Docker**
```dockerfile
# Stage 1: The Builder
# We use a temporary stage to install dependencies
FROM python:3.9-slim AS builder

WORKDIR /app

# Copy only requirements to take advantage of Docker layer caching
COPY requirements.txt requirements.txt

# Install dependencies without keeping the pip cache
RUN pip install --no-cache-dir -r requirements.txt


# Stage 2: The Final Runtime
# We start with a fresh, clean image for production
FROM python:3.9-slim

WORKDIR /app

# Copy ONLY the installed packages from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/

# Copy the application source code from the builder stage
COPY --from=builder /app /app

# Inform Docker that the container listens on port 5000
EXPOSE 5000

# The command to run the application
CMD ["python", "app.py"]
```
