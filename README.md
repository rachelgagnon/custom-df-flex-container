# Custom Dataflow Image
This repo demonstrates how to use custom container images to build and deploy Dataflow flex templates. We use two different custom images, the template launcher image and the execution image. Each custom container is a Dockerfile that is built and pushed to Artifact Registry using Cloud Build.

Template Launcher Image: This image is responsible for building the Flex Template itself. It's essential for using templates and needs to contain any packages required outside the core pipeline logic (e.g., the Oracle client library). It typically uses the entrypoint /opt/google/dataflow/python_template_launcher.

Execution Image (Base SDK Image): This image is used by each worker node to execute the pipeline operations. It needs to include Apache Beam and any packages used within the pipeline's core logic (i.e., within DoFn functions). It typically uses the entrypoint /opt/apache/beam/boot.

This assumes the template is called "main.py" and you want to install Beam 2.59.0. You can also include an optional requirements.txt file that includes any additional packages you would like to install, just make sure to add apache-beam (with desired targets - gcp, dataframe, azure, etc.) to the requirements file as well.

### Set Args
PROJECT = data-analytics-pocs
REGION = us-central1
BUCKET = rgagnon-df-test
REPO = rgagnon-df-test-repo
TEMPLATE_IMAGE = us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/custom_python_image:latest
TEMPLATE_PATH = gs://rgagnon-df-test/distroless_test/template/custom_python_image.json
JOB_NAME = "flex-test-`date+%Y%m%d-%H%M%S`" \

# BUILD THE IMAGE
Use either Docker or Cloud Build to build the image. Put all the build artifacts (main.py, Dockerfile, and the optional requirements.txt) in the build directory where you run the command from. Both images will need to be built with this command before using them in the flex template.

From root/sdk_container/ run the following:
gcloud builds submit --tag us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/custom_sdk_container:latest .

From the root dir, run the following:
gcloud builds submit --tag us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/custom_template_launcher:latest .


# BUILD THE FLEX TEMPLATE
gcloud dataflow flex-template build gs://rgagnon-df-test/distroless_test/template/flex_template_test.json \
   --image us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/custom_template_launcher:latest \
   --sdk-language "PYTHON" \
   --metadata-file "metadata.json" \
   --project data-analytics-pocs

# RUN THE FLEX TEMPLATE
gcloud dataflow flex-template run "custom-image-test-`date +%Y%m%d-%H%M%S`" \
   --region=us-central1 \
   --template-file-gcs-location=gs://rgagnon-df-test/distroless_test/template/flex_template_test.json \
   --parameters sdk_container_image=us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/custom_sdk_container:latest \
   --parameters output="gs://rgagnon-df-test/distroless_test/template/output" \
   --parameters input="gs://dataflow-samples/shakespeare/*" \
   --additional-experiments=use_runner_v2