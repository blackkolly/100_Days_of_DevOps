Nautilus project developers are planning to start testing on a new project. As per their meeting with the DevOps team,
they want to test containerized environment application features. As per details shared with DevOps team, we need to accomplish the following task:

a. Pull busybox:musl image on App Server 3 in Stratos DC and re-tag (create new tag) this image as busybox:media.


Step 1: SSH into App Server 3

From jump host:
ssh banner@stapp03   # password: BigGr33n

Switch to root if needed:

sudo -i

Step 2: Pull the `busybox:musl` image

docker pull busybox:musl

 Step 3: Re-tag the image as `busybox:media`

docker tag busybox:musl busybox:media

Step 4: Verify both tags exist

docker images busybox

You should see something like:

REPOSITORY   TAG     IMAGE ID       CREATED        SIZE
busybox      musl    <image_id>     <time>         <size>
busybox      media   <image_id>     <time>         <size>





