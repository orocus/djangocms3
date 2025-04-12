# Base image
FROM python:3.12-slim as base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libmysqlclient-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Development stage
FROM base as dev

# Copy project files
COPY . /app

# Run Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Production stage
FROM base as prod

# Copy project files
COPY . /app

# Run Gunicorn
CMD ["gunicorn", "cmsproject.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]