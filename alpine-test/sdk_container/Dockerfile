# Use the base image
FROM python:3.10-slim AS build

WORKDIR /app

# copy all
COPY . .

# Arguments Setup
ARG VER
ARG CI_PROJECT_NAME
ARG APP_NAME

# Update the OS packages
RUN apt update -y \
    && apt upgrade -y \
    && apt upgrade -y python3 \
    && pip3 install --upgrade pip \
    && apt install -y python3-venv \
    && python3 --version \
    && pip3 --version

# Create and activate virtual environments
ENV VENV=/app/venv
RUN python3 -m venv $VENV
ENV PATH="$VENV/bin:$PATH"

# Install Beam SDK
RUN $VENV/bin/pip install --no-cache-dir apache-beam[gcp]==2.60.0 

# Verify that the image does not have conflicting dependencies.
RUN $VENV/bin/pip check

# final stage/image
FROM python:3.10-alpine

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

# Set the virtual environment for the rest of the build process
ENV PATH="/app/venv/bin:$PATH"

COPY --from=build /app ./

RUN apk update \
    && apk upgrade

#USER container-user
#RUN whoami

WORKDIR /app/src

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python3.10_sdk:2.60.0 /opt/apache/beam /opt/apache/beam

# Set the entrypoint to Apache Beam SDK launcher.
ENTRYPOINT ["/opt/apache/beam/boot"]
