"""
Health WebApp - FastAPI Application
"""

from fastapi import FastAPI
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from fastapi.responses import Response
import time

app = FastAPI(
    title="Health WebApp API",
    description="Scalable health information platform",
    version="1.0.0"
)

# Prometheus metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests')

@app.get("/")
async def root():
    REQUEST_COUNT.inc()
    return {
        "message": "Health WebApp API",
        "version": "1.0.0",
        "status": "operational"
    }

@app.get("/health")
async def health_check():
    REQUEST_COUNT.inc()
    return {
        "status": "healthy",
        "timestamp": time.time(),
        "checks": {"api": "ok"}
    }

@app.get("/ready")
async def readiness_check():
    REQUEST_COUNT.inc()
    return {
        "status": "ready",
        "timestamp": time.time()
    }

@app.get("/metrics")
async def metrics():
    return Response(generate_latest(), media_type=CONTENT_TYPE_LATEST)

@app.get("/api/v1/health-info")
async def get_health_info():
    REQUEST_COUNT.inc()
    return {
        "data": {
            "tips": [
                "Stay hydrated - drink 8 glasses of water daily",
                "Get 7-9 hours of sleep each night"
            ]
        }
    }

@app.post("/api/v1/health-data")
async def submit_health_data(data: dict):
    REQUEST_COUNT.inc()
    return {
        "message": "Health data recorded successfully",
        "id": f"health_record_{int(time.time())}"
    }
