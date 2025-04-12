# Create a virtual environment
create_venv:
	python3 -m venv .venv

# Compile requirements using pip-compile inside the virtual environment
pip_compile: create_venv
	. .venv/bin/activate && pip install pip-tools && pip-compile requirements.in