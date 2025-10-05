One of the Nautilus developer was working to test new changes on a container. He wants to keep a backup of his changes to the container.
A new request has been raised for the DevOps team to create a new image from this container. Below are more details about it:
a. Create an image news:nautilus on Application Server 3 from a container ubuntu_latest that is running on same server

Step 1: SSH into App Server 3

From jump host:
ssh banner@stapp03   # password: BigGr33n
Switch to root if needed:
sudo -i
Step 2: Verify the container
Check that `ubuntu_latest` is running:
docker ps --filter "name=ubuntu_latest"

Step 3: Commit the container to a new image

docker commit ubuntu_latest news:nautilus
docker commit → saves the state of a container into a new image.
news:nautilus → `news` is the repo name, `nautilus` is the tag.

 Step 4: Verify the new image exists

docker images news
You should see something like:
REPOSITORY   TAG        IMAGE ID       CREATED          SIZE
news         nautilus   <image_id>     <X seconds ago>  <size>

