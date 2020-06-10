#!/usr/bin/env bash
STORAGE_FULL_PATH=/srv/docker/openprojectdocker #don't use relative path, as it will create docker volumes!
#IMG=openproject/community:10.4.1
IMG=openproject/community:10.6.0
docker pull $IMG

$? && echo "Error pulling image, exiting" && exit 1
docker stop openprojectdocker || true

docker rm -f openprojectdocker || true
docker run -d -p 14080:80 --restart always --name openprojectdocker \
  --env-file ${STORAGE_FULL_PATH}/docker.env \
  -v ${STORAGE_FULL_PATH}/pgdata:/var/openproject/pgdata \
  -v ${STORAGE_FULL_PATH}/static:/var/openproject/assets \
  -v ${STORAGE_FULL_PATH}/production.rb:/app/config/environments/production.rb \
  $IMG

#sleep 20

echo "to see the logs, run:"
echo "docker logs -f openprojectdocker"

