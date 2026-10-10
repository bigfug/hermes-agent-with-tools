# hermes-agent-with-tools
#
# Purpose: the one thing the official image does not do — ship git-lfs.
#
# Everything else that used to live here moved out on 2026-10-08, when upstream
# re-cut the image on PM (0.21.6 rc.4, commit 818c13be). Reasons, from that
# image's own Dockerfile and pyproject:
#
#   * uv is gone on purpose. PM resolves the pinned uv from pm/lock.json into
#     /opt/hermes/tools and never exposes it as an installer executable —
#     upstream removed its own astral-image uv stage because the tag had drifted
#     to 0.11.6 while pm/lock.json pinned 0.12.3, calling it "exactly the
#     two-authorities failure the pm design exists to end". Restoring a uv stage
#     here would re-create that drift.
#   * Writing /opt/hermes/.venv is forbidden in this architecture ("the sealed
#     /opt/hermes/.venv is never written"), so no pip/uv layer belongs here.
#   * A PM generation built at image-build time lands under /opt/data, which the
#     volume mount masks at runtime — those packages would vanish at boot.
#
# The Python packages are provided elsewhere now:
#   * ddgs      -> bundled plugin plugins/web/ddgs installs the package on first
#                  pick into a PM generation under /opt/data/installs
#   * hindsight -> shipped as the plugin-catalog/hindsight.yaml plugin, whose
#                  deps PM prepares at admission
#   * pytest, PyYAML -> our own tooling, not Hermes features: they install into
#                  a PM environment on the volume at runtime, never the image.
FROM nousresearch/hermes-agent:latest
# git-lfs: the official image installs git and openssh-client but not git-lfs,
# and the git config here declares filter.lfs.required=true, so any checkout
# touching an LFS object fails without this binary.
#
# No USER directive on purpose: the base image runs as root by design — the
# s6-overlay stage2 hook needs it to remap HERMES_UID/HERMES_GID and chown
# /opt/data, after which supervised services drop to `hermes` via s6-setuidgid.
# ENTRYPOINT, CMD and VOLUME are inherited from the base image unchanged.
RUN apt-get -o Acquire::Retries=3 update \
 && apt-get -o Acquire::Retries=3 install -y --no-install-recommends git-lfs \
 && git lfs install --system \
 && rm -rf /var/lib/apt/lists/* \
 && git lfs version
