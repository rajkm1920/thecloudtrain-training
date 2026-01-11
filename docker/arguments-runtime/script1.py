import os

if __name__ == "__main__":
    build_time_var = os.getenv("build_time_env_var", "Not Set")
    print(f"Build-time argument passed: {build_time_var}")
