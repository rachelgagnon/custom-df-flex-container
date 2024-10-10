FROM python:3.11-bookworm

# Install SDK.
RUN pip install --no-cache-dir apache-beam[gcp]==2.59.0

# Verify that the image does not have conflicting dependencies.
RUN pip check

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python3.11_sdk:2.59.0 /opt/apache/beam /opt/apache/beam

# Set the entrypoint to Apache Beam SDK launcher.
ENTRYPOINT ["/opt/apache/beam/boot"]
