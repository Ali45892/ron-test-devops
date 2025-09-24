"""
Test suite for Health WebApp API
Demonstrates testing practices for FastAPI applications
"""

from fastapi.testclient import TestClient
from main import app
import pytest

client = TestClient(app)

def test_read_root():
    """Test the root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "Health WebApp API"
    assert data["version"] == "1.0.0"
    assert "status" in data

def test_health_check():
    """Test health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "checks" in data
    assert data["checks"]["api"] == "ok"

def test_readiness_check():
    """Test readiness check endpoint"""
    response = client.get("/ready")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ready"
    assert "dependencies" in data

def test_metrics_endpoint():
    """Test Prometheus metrics endpoint"""
    response = client.get("/metrics")
    assert response.status_code == 200
    assert "http_requests_total" in response.text

def test_health_info_endpoint():
    """Test health information endpoint"""
    response = client.get("/api/v1/health-info")
    assert response.status_code == 200
    data = response.json()
    assert "data" in data
    assert "tips" in data["data"]
    assert len(data["data"]["tips"]) > 0

def test_submit_health_data():
    """Test health data submission"""
    test_data = {
        "user_id": "test_user",
        "weight": 70.5,
        "height": 175,
        "activity_level": "moderate"
    }
    response = client.post("/api/v1/health-data", json=test_data)
    assert response.status_code == 200
    data = response.json()
    assert "message" in data
    assert "id" in data
