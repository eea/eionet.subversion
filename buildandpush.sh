
VERS=1.3
#BUILDTIME=$(date '+%Y-%m-%dT%H%M')
LATEST=latest
NAME=eeacms/subversion

docker build -t ${NAME}:${LATEST} .
docker tag ${NAME} ${NAME}:${VERS}
#docker tag ${NAME} ${NAME}:${BUILDTIME}
docker push ${NAME}:${LATEST}
docker push ${NAME}:${VERS}
#docker push ${NAME}:${BUILDTIME}

