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
ARG ORACLE_URL="https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-basic-linux.x64-23.5.0.24.07.zip"
ARG LD_LIBRARY_PATH=/opt/oracle

ENV FLEX_TEMPLATE_PYTHON_PY_FILE=$TEMPLATE_FILE
ENV FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE=$REQUIREMENTS_FILE

# Copy template files to /template
RUN mkdir -p $WORKDIR
COPY main.py requirements.txt* /template/
WORKDIR $WORKDIR

# Create requirements.txt file if not provided
RUN if ! [ -f requirements.txt ] ; then echo "$BEAM_PACKAGE" > requirements.txt ; fi

# # Install dependencies to launch the pipeline and download to reduce worker startup time 
RUN apt-get update \
    && apt-get install -y wget unzip libaio1 \
    && apt-get install -y libffi-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r $FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE \
    && pip uninstall js2py -y \
    && pip download --no-cache-dir --dest /tmp/dataflow-requirements-cache -r $FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE 

# Download Oracle Client
RUN wget $ORACLE_URL

# Unzip Oracle Client
RUN unzip instantclient-basic-linux.x64-23.5.0.24.07.zip -d /opt/oracle

# Add Instant Client to the runtime link path
RUN sh -c "echo /opt/oracle/instantclient_23_5 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
    && ldconfig

# Set Python environment variables
ENV PIP_NO_DEPS=True
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH/instantclient_23_5

# Copy licenses and launcher from base image
COPY --from=python-base /usr/licenses/ /usr/licenses/
COPY --from=python-base /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher

ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]