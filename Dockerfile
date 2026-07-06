FROM nousresearch/hermes-agent:latest

USER root

# Install system packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git-lfs \
    && git lfs install --system \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages into Hermes' own venv
RUN /usr/local/bin/uv pip install \
    --python /opt/hermes/.venv/bin/python \
    ddgs \
    PyYAML \
 && /opt/hermes/.venv/bin/python -c "import ddgs; import yaml; print('ddgs and yaml installed OK')"

USER hermes
