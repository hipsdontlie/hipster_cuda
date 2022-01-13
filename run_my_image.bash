#Docker file for hipster environment
#Author: Kaushik Balasundar (kbalasun@andrew.cmu.edu)
XAUTH=/tmp/.docker.xauth
WORKSPACE_DIR=~/arthur_ws
CONTAINER_NAME="hipster-melodic-cuda-configured"
IMAGE_NAME="kaushikbalasundar/manipulation_env_cuda_10_1:cuda"
USER_NAME=root
HOME_DIR=~/

# Get the current version of docker-ce
# Strip leading stuff before the version number so it can be compared
DOCKER_VER=$(dpkg-query -f='${Version}' --show docker-ce | sed 's/[0-9]://')
if dpkg --compare-versions 19.03 gt "$DOCKER_VER"
then
    echo "Docker version is less than 19.03, using nvidia-docker2 runtime"
    if ! dpkg --list | grep nvidia-docker2
    then
        echo "Please either update docker-ce to a version greater than 19.03 or install nvidia-docker2"
	exit 1
    fi
    DOCKER_OPTS="$DOCKER_OPTS --runtime=nvidia"
else
    DOCKER_OPTS="$DOCKER_OPTS --gpus all"
fi

CMD=""

if [ "$3" != "" ]; then
    CMD=$3
    echo "$CMD will be passed to the container ..."
fi

echo "Welcome to the Arthur Robot Development Environment!"
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

if [ "$(docker ps -aq -f name=${CONTAINER_NAME})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${CONTAINER_NAME})" ]; then
        # cleanup
        docker start ${CONTAINER_NAME}
    fi
    if [ -z "$CMD" ]; then
        docker exec -it --user $USER_NAME ${CONTAINER_NAME} bash
    else
        docker exec -it --user $USER_NAME ${CONTAINER_NAME} bash -c "$CMD"
    fi
else

    if [ -z "$CMD" ]; then

	docker run -it \
	    --env="DISPLAY=$DISPLAY" \
	    --env="QT_X11_NO_MITSHM=1" \
	    --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" \
	    --env="XAUTHORITY=$XAUTH" \
	    --volume="$XAUTH:$XAUTH" \
	    --volume="$WORKSPACE_DIR:/home/hipster/arthur_ws:rw" \
	    --volume="ros_melodic:/opt/ros:rw" \
	    --volume="/etc/localtime:/etc/localtime:ro" \
	    --volume="/dev/input:/dev/input" \
	    --runtime=nvidia \
	    --privileged \
	    --name=${CONTAINER_NAME} \
	    -p 8181:8181 \
	    -p 9090:9090 \
	    -p 3883:3883 \
	    --workdir="/home/hipster/arthur_ws" \
	    $IMAGE_NAME \
	    bash

       else

	docker run -it \
	    --env="DISPLAY=$DISPLAY" \
	    --env="QT_X11_NO_MITSHM=1" \
	    --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" \
	    --env="XAUTHORITY=$XAUTH" \
	    --volume="$XAUTH:$XAUTH" \
	    --volume="$WORKSPACE_DIR:/home/hipster/arthur_ws:rw" \
	    --volume="ros_melodic:/opt/ros:rw" \
	    --volume="/etc/localtime:/etc/localtime:ro" \
	    --volume="/dev/input:/dev/input" \
	    --runtime=nvidia \
	    --privileged \
	    --name=${CONTAINER_NAME} \
	    -p 8181:8181 \
	    -p 9090:9090 \
	    -p 3883:3883 \
	    --workdir="/home/hipster" \
	    $IMAGE_NAME \
	    bash -c "$CMD"
	fi
fi

