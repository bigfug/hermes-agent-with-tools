FROM nousresearch/hermes-agent:latest

USER root

# Install system packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git-lfs \
    && git lfs install --system \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages into Hermes' own venv
# RUN /usr/local/bin/uv pip install \
#     --python /opt/hermes/.venv/bin/python \
#     ddgs \
#     PyYAML \
#     mnemosyne-hermes \
#  && /opt/hermes/.venv/bin/python -c "import ddgs; import yaml; print('ddgs and yaml installed OK')"

RUN uv pip install --python /usr/bin/python3 \
    ddgs \
    PyYAML \
    mnemosyne-hermes \
 && /usr/bin/python3 -c "import ddgs; import yaml; import mnemosyne_hermes; print('all packages installed OK')"
 
# USER hermes
