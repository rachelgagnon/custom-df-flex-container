#===================================================================#
# Create build environment from base Python template launcher image #
#===================================================================#
FROM gcr.io/dataflow-templates-base/python311-template-launcher-base:latest as python-base

#============================================================#
# Create template image using Google distroless Python image #
#============================================================#
FROM python:3.11-slim

ARG BEAM_VERSION=2.59.0
ARG TEMPLATE_FILE=main.py
ARG WORKDIR=/template
ARG REQUIREMENTS_FILE=requirements.txt
ARG BEAM_PACKAGE=apache-beam[gcp,dataframe,azure,aws]==$BEAM_VERSION
ARG PY_VERSION=3.11
ARG GCS_PATH="gs://dataflow-staging-us-central1-54176095559/dataflow_oracle/oracle_client"
ARG LD_LIBRARY_PATH=$WORKDIR/lib/oracle_client

# Copy template files to /template
RUN mkdir -p $WORKDIR
COPY main.py requirements.txt* /template/
WORKDIR $WORKDIR

# Create requirements.txt file if not provided
RUN if ! [ -f requirements.txt ] ; then echo "$BEAM_PACKAGE" > requirements.txt ; fi

# Install CLI tools
RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install unzip

RUN wget -p $LD_LIBRARY_PATH/ https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-basic-linux.x64-23.5.0.24.07.zip
# # Download Oracle Client Library from GCS
# RUN gsutil cp $GCS_PATH/instantclient-basic-linuxx64.zip $LD_LIBRARY_PATH/

# Unzip Oracle Client
RUN unzip $LD_LIBRARY_PATH/instantclient-basic-linuxx64.zip

# install libaio

# Install dependencies to launch the pipeline and download to reduce worker startup time 
RUN python -m venv /venv \
    && /venv/bin/pip install --no-cache-dir --upgrade pip setuptools \
    && /venv/bin/pip install --no-cache-dir -U -r $REQUIREMENTS_FILE \
    && /venv/bin/pip download --no-cache-dir --dest /tmp/dataflow-requirements-cache -r $REQUIREMENTS_FILE \
    && /venv/bin/pip uninstall js2py -y \
    && rm -rf /usr/local/lib/python$PY_VERSION/site-packages  \
    && mv /venv/lib/python$PY_VERSION/site-packages /usr/local/lib/python$PY_VERSION/

# Set python environment variables
ENV FLEX_TEMPLATE_PYTHON_PY_FILE=$TEMPLATE_FILE
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH

# Copy licenses and launcher from base image
COPY --from=python-base /usr/licenses/ /usr/licenses/
COPY --from=python-base /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher

ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]