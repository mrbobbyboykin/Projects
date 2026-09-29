"""Minimal API for Project 6 Phase 0 — local Docker lab."""

from __future__ import annotations

import os
import socket

from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/health")
def health():
    """ALB / container health check — keep this fast and dependency-free."""
    return jsonify(status="ok"), 200


@app.get("/")
@app.get("/info")
def info():
    """
    Shows runtime context for demos.
    Never return the secret value — only whether it is present.
    """
    secret = os.environ.get("APP_SECRET", "")
    return jsonify(
        service="project-6-secure-containers",
        hostname=socket.gethostname(),
        secret_configured=bool(secret),
    ), 200


if __name__ == "__main__":
    # Bind all interfaces so Docker port mapping works.
    port = int(os.environ.get("PORT", "8080"))
    app.run(host="0.0.0.0", port=port)
