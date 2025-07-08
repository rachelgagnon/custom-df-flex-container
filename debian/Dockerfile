FROM gcr.io/dataflow-templates-base/python310-template-launcher-base

ENV FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE="/template/requirements.txt"
ENV FLEX_TEMPLATE_PYTHON_PY_FILE="/template/main.py"

COPY . /template

RUN apt-get update \
    && apt-get install -y wget unzip libaio1 \
    && apt-get install -y libffi-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r $FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE \
    && pip download --no-cache-dir --dest /tmp/dataflow-requirements-cache -r $FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE \
    && apt-get install -y wget unzip libaio1

# Download the Oracle Instant Client Basic zip file
RUN wget https://download.oracle.com/otn_software/linux/instantclient/2350000/instantclient-basic-linux.x64-23.5.0.24.07.zip

# Create the installation directory
RUN mkdir -p /opt/oracle

# Unzip the Instant Client package
RUN unzip instantclient-basic-linux.x64-23.5.0.24.07.zip -d /opt/oracle

# Add Instant Client to the runtime link path
RUN sh -c "echo /opt/oracle/instantclient_23_5 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
    && ldconfig

# Set environment variables
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_23_5
# ENV PATH $PATH:/opt/oracle/instantclient_23_5
# ENV ORACLE_HOME /opt/oracle/instantclient_23_5

ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]