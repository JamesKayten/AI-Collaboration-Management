# AIM (AI-Collaboration-Management) Docker Image
# Provides isolated AICM framework that mounts project repos

FROM ubuntu:22.04

LABEL maintainer="AIM Framework"
LABEL description="AI-Collaboration-Management - Safe deployment container"

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    bash \
    curl \
    jq \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Create AIM directory structure
RUN mkdir -p /aim/scripts /aim/state/boards /aim/.claude/commands

# Copy AIM framework
COPY scripts/ /aim/scripts/
COPY .claude/ /aim/.claude/
COPY CLAUDE.md /aim/
COPY docs/ /aim/docs/

# Make scripts executable
RUN chmod +x /aim/scripts/*.sh

# Create project mount point
RUN mkdir -p /project
VOLUME /project

# State volume for boards (persists across containers)
VOLUME /aim/state

# Working directory is the mounted project
WORKDIR /project

# Environment
ENV AIM_HOME=/aim
ENV PATH="/aim/scripts:${PATH}"

# Entry point
COPY docker/aim-entrypoint.sh /aim/
RUN chmod +x /aim/aim-entrypoint.sh
ENTRYPOINT ["/aim/aim-entrypoint.sh"]
CMD ["shell"]
