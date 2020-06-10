#!/usr/bin/env bash
#IMG=openproject/community:10.4.1
IMG=openproject/community:10.6.0
docker pull $IMG

$? && echo "Error pulling image, exiting" && exit 1
docker stop openprojectdocker || true

docker rm -f openprojectdocker || true
docker run -d -p 14080:80 --restart always --name openprojectdocker \
  --env-file /srv/docker/openprojectdocker/docker.env \
  -v /srv/docker/openprojectdocker/pgdata:/var/openproject/pgdata \
  -v /srv/docker/openprojectdocker/static:/var/openproject/assets \
  -v /srv/docker/openprojectdocker/production.rb:/app/config/environments/production.rb \
  $IMG

#sleep 20

echo "to see the logs, run:"
echo "docker logs -f openprojectdocker"

