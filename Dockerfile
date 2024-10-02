#===================================================================#
# Create build environment from base Python template launcher image #
#===================================================================#
FROM gcr.io/dataflow-templates-base/python311-template-launcher-base:latest as python-base

#============================================================#
# Create template image using Google distroless Python image #
#============================================================#
FROM gcr.io/distroless/python3:f369a5c1313c9919954ea37b847ccf6b40d3d509

# TODO - Set these values, if different
ARG BEAM_VERSION=2.59.0
ARG TEMPLATE_FILE=main.py

# Build args
ARG WORKDIR=/template
ARG REQUIREMENTS_FILE=requirements.txt
ARG BEAM_PACKAGE=apache-beam[gcp,dataframe,azure,aws]==$BEAM_VERSION
ARG PY_VERSION=3.11

# Copy template files to /template
RUN mkdir -p $WORKDIR
COPY main.py requirements.txt* /template/

WORKDIR $WORKDIR

# Create requirements.txt file if not provided
RUN if ! [ -f requirements.txt ] ; then echo "$BEAM_PACKAGE" > requirements.txt ; fi

# Install dependencies to launch the pipeline and download to reduce worker startup time
RUN python -m venv /venv \
    && /venv/bin/pip install --no-cache-dir --upgrade pip setuptools \
    && /venv/bin/pip install --no-cache-dir -U -r $REQUIREMENTS_FILE \
    && /venv/bin/pip download --no-cache-dir --dest /tmp/dataflow-requirements-cache -r $REQUIREMENTS_FILE \
    && rm -rf /usr/local/lib/python$PY_VERSION/site-packages  \
    && mv /venv/lib/python$PY_VERSION/site-packages /usr/local/lib/python$PY_VERSION/

# Set python environment variables
ENV FLEX_TEMPLATE_PYTHON_PY_FILE=$TEMPLATE_FILE
ENV LD_LIBRARY_PATH="${WORKDIR}/lib/oracle_client/"

# Copy licenses and launcher from base image
COPY --from=python-base /usr/licenses/ /usr/licenses/
COPY --from=python-base /opt/google/dataflow/python_template_launcher /opt/google/dataflow/python_template_launcher

ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
