# base defines a base stage that uses the official python runtime base image
FROM python:3.11-slim AS base

# Install curl for the healthcheck
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# Upgrade Python packaging tools
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel

#Upgrade vulnerable urllib3
RUN python -m pip install --no-cache-dir --upgrade urllib3==2.8.0

COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Development stage
FROM base AS dev

RUN pip install watchdog
ENV FLASK_ENV=development

CMD ["python", "app.py"]

# Final application stage
FROM base AS final

# Create an unprivileged application user
RUN groupadd --system appuser && \
    useradd --system --gid appuser --home-dir /nonexistent \
    --shell /usr/sbin/nologin appuser

# Copy application files with safe ownership
COPY --chown=appuser:appuser . .

# Allow the app to bind to port 80 without root
RUN setcap 'cap_net_bind_service=+ep' "$(command -v python)" || true

EXPOSE 80

USER appuser

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:80", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]