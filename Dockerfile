# Use the official Python 3.11 slim image
FROM python:3.12-slim

# Install system dependencies 
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# FIX: Leverage the official astral-sh/uv image to safely copy uv binaries 
# into this container without dealing with pip PEP 668 restrictions.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory inside the container
WORKDIR /workspace

# Copy ONLY the dependency files first to cache installations
COPY pyproject.toml uv.lock ./

# Use uv to sync and install all dependencies into the container
RUN uv sync

# Copy the rest of your application code
COPY . .

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["uv", "run", "app/main.py"]