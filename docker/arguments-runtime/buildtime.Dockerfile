# Use the official Python image
FROM python:3.9-slim

# Define a build-time argument with a default value
ARG build_time_var="default_value"

# Create an environment variable using the build-time argument
ENV build_time_env_var=${build_time_var}

# Copy a Python script into the container
WORKDIR /app
COPY script1.py .

# Run the Python script and pass the environment variable as an argument
ENTRYPOINT ["python", "script1.py"]

#docker build --build-arg build_time_var="Hello World from build" -t b:v2  -f buildtime.Dockerfile .