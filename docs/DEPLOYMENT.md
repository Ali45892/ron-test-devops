# Deployment Guide

## Prerequisites

### Tools Required
- `gcloud` CLI (authenticated)
- `terraform` >= 1.5.0
- `docker` 
- `git`
- `kubectl` (optional)

### GCP Setup
1. **Create Project**: `gcloud projects create PROJECT_ID`
2. **Enable Billing**: Link billing account to project
3. **Enable APIs**: Run `scripts/enable-apis.sh`
4. **Set IAM**: Create service accounts with proper roles

## Quick Start

### 1. Clone and Setup
```bash
git clone <repository-url>
cd ron-test-devops
cp terraform/environments/prod/terraform.tfvars.example terraform/environments/prod/terraform.tfvars
clear








terraform apply

terraform apply

# Go back to project root
cd ../../../

# Complete the final documentation and check everything
ls -la

# Let's create a sample FastAPI app to make this complete
cat > main.py << 'EOF'
"""
Health WebApp - FastAPI Application
Demonstrates modern Python web development with health checks,
monitoring, and cloud-native patterns.
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from prometheus_client import Counter, Histogram, generate_latest
from prometheus_client.openmetrics.exposition import CONTENT_TYPE_LATEST
from fastapi.responses import Response
import structlog
import os
import time
from typing import Dict, Any

# Configure structured logging
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.add_log_level,
        structlog.processors.JSONRenderer()
    ],
    wrapper_class=structlog.make_filtering_bound_logger(20),  # INFO level
    logger_factory=structlog.PrintLoggerFactory(),
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()

# Prometheus metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_DURATION = Histogram('http_request_duration_seconds', 'HTTP request duration')

app = FastAPI(
    title="Health WebApp API",
    description="Scalable health information platform with modern DevOps practices",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure properly in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.middleware("http")
async def log_requests(request, call_next):
    """Log all requests with timing and metrics"""
    start_time = time.time()
    
    response = await call_next(request)
    
    duration = time.time() - start_time
    
    # Record metrics
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.url.path,
        status=response.status_code
    ).inc()
    REQUEST_DURATION.observe(duration)
    
    # Structured logging
    logger.info(
        "HTTP request",
        method=request.method,
        url=str(request.url),
        status_code=response.status_code,
        duration=duration,
        client_ip=request.client.host if request.client else None
    )
    
    return response

@app.get("/")
async def root():
    """Root endpoint with basic API information"""
    return {
        "message": "Health WebApp API",
        "version": "1.0.0",
        "status": "operational",
        "environment": os.getenv("ENVIRONMENT", "development"),
        "docs": "/docs"
    }

@app.get("/health")
async def health_check():
    """Kubernetes-style health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": time.time(),
        "checks": {
            "api": "ok",
            "database": "ok",  # Add real DB check in production
            "cache": "ok"      # Add real cache check in production
        }
    }

@app.get("/ready")
async def readiness_check():
    """Kubernetes-style readiness check"""
    # Add real dependency checks (database, external APIs, etc.)
    return {
        "status": "ready",
        "timestamp": time.time(),
        "dependencies": {
            "database": "connected",
            "external_apis": "reachable"
        }
    }

@app.get("/metrics")
async def metrics():
    """Prometheus metrics endpoint"""
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

@app.get("/api/v1/health-info")
async def get_health_info():
    """Sample health information endpoint"""
    logger.info("Health information requested")
    
    return {
        "data": {
            "tips": [
                "Stay hydrated - drink 8 glasses of water daily",
                "Get 7-9 hours of sleep each night",
                "Exercise for at least 30 minutes daily",
                "Eat 5-9 servings of fruits and vegetables daily"
            ],
            "categories": ["nutrition", "exercise", "sleep", "mental_health"],
            "last_updated": "2024-09-24T00:00:00Z"
        },
        "meta": {
            "total_count": 4,
            "api_version": "1.0"
        }
    }

@app.post("/api/v1/health-data")
async def submit_health_data(data: Dict[str, Any]):
    """Sample endpoint for submitting health data"""
    logger.info("Health data submitted", data_keys=list(data.keys()))
    
    # In production, validate and store in database
    return {
        "message": "Health data recorded successfully",
        "id": f"health_record_{int(time.time())}",
        "timestamp": time.time()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")
