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
    exa-py \
    pyyaml \
 && /opt/hermes/.venv/bin/python -c "import ddgs; import exa_py; import pyyaml; print('ddgs and exa_py and pyyaml installed OK')"

USER hermes
