A python app needed to be Dockerized, and then it needs to be deployed on App Server 3. We have already copied a requirements.txt 
file (having the app dependencies) under /python_app/src/ directory on App Server 3. Further complete this task as per details mentioned below:

Create a Dockerfile under /python_app directory:

Use any python image as the base image.
Install the dependencies using requirements.txt file.
Expose the port 8083.
Run the server.py script using CMD.

Build an image named nautilus/python-app using this Dockerfile.


Once image is built, create a container named pythonapp_nautilus:

Map port 8083 of the container to the host port 8099.

Once deployed, you can test the app using curl command on App Server 3.


curl http://localhost:8099/


 Step 1: Verify app files

On App Server 3

cd /python_app/src
ls


You should see something like:

requirements.txt  server.py

 Step 2: Create the Dockerfile

cd /python_app
sudo vi Dockerfile

dockerfile
# Use Python as base image
FROM python:3.10-slim

# Set working directory inside the container
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY src/ .

# Expose port 8083
EXPOSE 8083

# Run the app
CMD ["python", "server.py"]


 Step 3: Build the image

sudo docker build -t nautilus/python-app /python_app

Step 4: Run the container

sudo docker run -d --name pythonapp_nautilus -p 8099:8083 nautilus/python-app


This maps:

Host port 8099 → Container port 8083

Step 5: Verify it’s running

sudo docker ps

CONTAINER ID   IMAGE                  PORTS                     NAMES
abc1234def56   nautilus/python-app    0.0.0.0:8099->8083/tcp    pythonapp_nautilus

Step 6: Test the application

curl http://localhost:8099/

