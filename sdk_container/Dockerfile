FROM python:3.10-slim

# Install SDK.
RUN pip install --no-cache-dir apache-beam[gcp]==2.60.0

# Verify that the image does not have conflicting dependencies.
RUN pip check

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python3.10_sdk:2.60.0 /opt/apache/beam /opt/apache/beam

# Set the entrypoint to Apache Beam SDK launcher.
ENTRYPOINT ["/opt/apache/beam/boot"]
