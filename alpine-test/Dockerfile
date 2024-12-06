# Use the base image
FROM python:3.10-slim AS build

WORKDIR /app

# copy all
COPY . .

# Arguments and Environment Variable Setup
ARG VER
ARG CI_PROJECT_NAME
ARG APP_NAME
ARG ORACLE_URL="https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-basic-linux.x64-23.5.0.24.07.zip"

ENV FLEX_TEMPLATE_PYTHON_PY_FILE="/app/hello_world.py"
ENV FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE="/app/requirements.txt"
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_23_5

RUN ls

# Update the OS packages
RUN apt update -y \
    && apt upgrade -y \
    && apt upgrade -y python3 \
    && pip3 install --upgrade pip \
    && apt install -y python3-venv \
    && python3 --version \
    && pip3 --version

RUN apt-get install -y libaio1 libnsl-dev libc6-dev curl wget unzip libffi-dev git \
    && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environments
ENV VENV=/app/venv
RUN python3 -m venv $VENV
ENV PATH="$VENV/bin:$PATH"

# Install Beam SDK
RUN $VENV/bin/pip install --no-cache-dir apache-beam[gcp]==2.60.0 

# Install other dependencies
RUN $VENV/bin/pip install --no-cache-dir -r ${FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE}
RUN ls -al /app
RUN ls -al /app/venv

# Oracle Installation
RUN wget $ORACLE_URL
RUN mkdir -p /opt/oracle
RUN unzip instantclient-basic-linux.x64-23.5.0.24.07.zip -d /opt/oracle
RUN sh -c "echo /opt/oracle/instantclient_23_5 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
    && ldconfig

# Verify that the image does not have conflicting dependencies.
RUN $VENV/bin/pip check

RUN ls -a

# final stage/image
FROM python:3.10-slim

# Arguments Setup
ARG VER
ARG CI_PROJECT_NAME
ARG APP_NAME

# Labels Setup
LABEL MAINTAINER=${CI_PROJECT_NAME}
LABEL dg.app=${CI_PROJECT_NAME}
LABEL dg.version=${VER}

RUN echo ${CI_PROJECT_NAME}
WORKDIR /app
RUN ls -a

# Set the virtual environment for the rest of the build process
ENV PATH="/app/venv/bin:$PATH"

COPY --from=build . .
RUN ls -a

# RUN apk update \
#     && apk upgrade

#USER container-user
#RUN whoami

#WORKDIR /app/src
WORKDIR /app

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python3.10_sdk:2.60.0 /opt/apache/beam /opt/apache/beam

# Include the Dataflow Template Launcher if needed (from other Dockerfile)
COPY --from=gcr.io/dataflow-templates-base/python310-template-launcher-base /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher

# Set the entrypoint
ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]