# Project 6 — App (Phase 0)

Tiny Flask API used for the Docker → ECR → ECS lab.

## Endpoints

| Path | Purpose |
|------|---------|
| `GET /health` | Health check (ALB / Docker HEALTHCHECK) |
| `GET /` or `GET /info` | Hostname + whether `APP_SECRET` is set (value never returned) |

## Local with Docker

From this `app/` folder (Docker Desktop must be running):

```powershell
docker build -t project6-api:local .
docker run --rm -p 8080:8080 -e APP_SECRET=local-demo-secret project6-api:local
```

In another terminal (use `curl.exe` on Windows — plain `curl` is a PowerShell alias):

```powershell
curl.exe http://localhost:8080/health
curl.exe http://localhost:8080/info
```

Or:

```powershell
Invoke-RestMethod http://localhost:8080/health
Invoke-RestMethod http://localhost:8080/info
```

Stop the container with `Ctrl+C` in the run terminal.

## Optional: run without Docker

Needs Python 3.12+ installed locally:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
$env:APP_SECRET = "local-demo-secret"
python main.py
```
