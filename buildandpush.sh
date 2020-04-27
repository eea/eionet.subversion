
VERS=1.3.2
#BUILDTIME=$(date '+%Y-%m-%dT%H%M')
LATEST=latest
NAME=eeacms/subversion
REGISTRY=docker.io

docker build -t ${REGISTRY}/${NAME}:${LATEST} .
docker tag ${REGISTRY}/${NAME} ${REGISTRY}/${NAME}:${VERS}
#docker tag ${NAME} ${REGISTRY}/${NAME}:${BUILDTIME}
docker push ${REGISTRY}/${NAME}:${LATEST}
docker push ${REGISTRY}/${NAME}:${VERS}
#docker push ${REGISTRY}/${NAME}:${BUILDTIME}

