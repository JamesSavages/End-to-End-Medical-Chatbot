# Use the official Python 3.12 slim image
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Leverage the official astral-sh/uv image to safely copy uv binaries
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set the working directory inside the container
WORKDIR /app

# Copy ONLY the dependency files first to cache installations
COPY pyproject.toml uv.lock ./

# Install project dependencies
RUN uv sync

# Copy the rest of your application code
COPY . .

# Expose the network port your app runs on (e.g., 8000)
EXPOSE 8000

# Execute the application
CMD ["uv", "run", "python", "app.py"]