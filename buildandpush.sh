
#VERS=1.0
#BUILDTIME=$(date '+%Y-%m-%dT%H%M')
LATEST=latest
NAME=eeacms/subversion

docker build -t ${NAME}:${LATEST} .
#docker tag -f ${NAME} ${NAME}:${VERS}
#docker tag -f ${NAME} ${NAME}:${BUILDTIME}
docker push ${NAME}:${LATEST}
#docker push ${NAME}:${VERS}
#docker push ${NAME}:${BUILDTIME}

