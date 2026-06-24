#!/bin/bash
set -e

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

container_name="jrvs-psql"
volume_name="pgdata"

# Start docker if not running
sudo systemctl status docker >/dev/null 2>&1 || sudo systemctl start docker

# Check if container exists
docker container inspect "${container_name}" >/dev/null 2>&1
container_status=$?

case "${cmd}" in
  create)
    # Check if container already exists
    if [ "${container_status}" -eq 0 ]; then
      echo "Container already exists"
      exit 1
    fi

    # Check number of arguments
    if [ $# -ne 3 ]; then
      echo "Create requires username and password"
      exit 1
    fi

    # Create docker volume if not exists
    docker volume create "${volume_name}" >/dev/null

    # Create and start postgres container
    docker run --name "${container_name}" \
      -e POSTGRES_USER="${db_username}" \
      -e POSTGRES_PASSWORD="${db_password}" \
      -d \
      -v "${volume_name}:/var/lib/postgresql/data" \
      -p 5432:5432 \
      postgres:9.6-alpine

    exit $?
    ;;

  start|stop)
    # If container not created, exit
    if [ "${container_status}" -ne 0 ]; then
      echo "Container is not created"
      exit 1
    fi

    docker container "${cmd}" "${container_name}"
    exit $?
    ;;

  *)
    echo "Illegal command"
    echo "Commands: start|stop|create"
    exit 1
    ;;
esac

