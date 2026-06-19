# Dockerfile
FROM nousresearch/hermes-agent:latest

USER root

RUN /usr/local/bin/uv pip install \
    --python /opt/hermes/.venv/bin/python \
    ddgs \
    exa-py \
 && /opt/hermes/.venv/bin/python -c "import ddgs; import exa_py; print('ddgs and exa_py installed OK')"

USER hermes
