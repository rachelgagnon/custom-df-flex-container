This Dockerfile pulls the necessary files out of the base Python template image and copying them into the python:3.11-slim image. From there, we install beam as we normally would, removing any pre-installed python packages.

This assumes the template is called "main.py" and you want to install Beam 2.59.0 - If you would like to change either of these assumptions, modify the variables in the TODO section. 

You can also include an optional requirements.txt file that includes any additional packages you would like to install, just make sure to add apache-beam (with desired targets - gcp, dataframe, azure, etc.) to the requirements file as well.

To build the image, you can use docker or cloud build, just make sure to put all the build artifacts (main.py, Dockerfile, and the optional requirements.txt) in the build directory where you run the command from.

TEMPLATE_IMAGE = us-central1-docker.pkg.dev/data-analytics-pocs/rgagnon-df-test-repo/dataflow/Dockerfile:latest
TEMPLATE_PATH = gs://rgagnon-df-test/custom_image_test/template/pipeline.json

## BUILD THE IMAGE 
# Cloud Build
gcloud builds submit --tag $TEMPLATE_IMAGE .

# Docker
docker build . --tag $TEMPLATE_IMAGE
docker push $TEMPLATE_IMAGE

## BUILD THE FLEX TEMPLATE
gcloud dataflow flex-template build $TEMPLATE_PATH
   --image-gcr-path $TEMPLATE_IMAGE \
   --sdk-language "PYTHON" \
   --flex-template-base-image ????
   

## RUN THE FLEX TEMPLATE
gcloud dataflow flex-template run $JOB_NAME \
   --region=$REGION \
   --template-file-gcs-location=$TEMPLATE_PATH \
   --parameters=sdk_container_image=$CUSTOM_CONTAINER_IMAGE \
   --additional-experiments=use_runner_v2