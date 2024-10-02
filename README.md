# Custom Dataflow Image
This repo demonstrates how to use a custom container image to build and deploy Dataflow flex templates. The custom container is a Dockerfile that pulls the necessary files out of the base Python template image and copies them into Google's distroless Python image. From there, Beam is installed as usual, removing any pre-installed python packages.

This assumes the template is called "main.py" and you want to install Beam 2.59.0. You can also include an optional requirements.txt file that includes any additional packages you would like to install, just make sure to add apache-beam (with desired targets - gcp, dataframe, azure, etc.) to the requirements file as well.

### Set Args
PROJECT = data-analytics-pocs
REGION = us-central1
BUCKET = rgagnon-df-test
REPO = rgagnon-df-test-repo
TEMPLATE_IMAGE = us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/dataflow/pipeline:latest
TEMPLATE_PATH = gs://rgagnon-df-test/distroless_test/template/pipeline.json
JOB_NAME = "flex-test-`date+%Y%m%d-%H%M%S`" \

# BUILD THE IMAGE
Use either Docker or Cloud Build to build the image. Put all the build artifacts (main.py, Dockerfile, and the optional requirements.txt) in the build directory where you run the command from.

### Cloud Build
gcloud builds submit --tag $TEMPLATE_IMAGE .

### Docker
docker build . --tag $TEMPLATE_IMAGE
docker push $TEMPLATE_IMAGE

# BUILD THE FLEX TEMPLATE
gcloud dataflow flex-template build $TEMPLATE_PATH
   --image-gcr-path $TEMPLATE_IMAGE \
   --sdk-language "PYTHON" \
   --sdk_container_image=$TEMPLATE_IMAGE \
   --sdk_location=container \
   --py-path "." \
   --metadata-file "metadata.json" \
   --env "FLEX_TEMPLATE_PYTHON_PY_FILE=pipeline.py"
   --env "FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE=requirements.txt"
   

# RUN THE FLEX TEMPLATE
gcloud dataflow flex-template run $JOB_NAME \
   --region=$REGION \
   --template-file-gcs-location=$TEMPLATE_PATH \
   --parameters=sdk_container_image=$CUSTOM_CONTAINER_IMAGE \
   --parameter output="gs://$BUCKET/pipeline.json"
   --additional-experiments=use_runner_v2
