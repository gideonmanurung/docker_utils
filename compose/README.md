## DOCKER COMPOSE NOTE

### FIle Structure
- python file
- Dockerfile (if the image builded from scracth)
- docker-compose.yml
- requirements (optional, called from Dockerfile)

### Commands
- `docker-compose up` : deploying-up the docker compose
- `docker-compose up -d` : deploying-up the docker compose in the background (silent) mode
- `docker-compose stop` : stopping the application (BUT the volume still mounted to the docker)
- `docker-compose down --volumes` : stopping the application and releasing the binded volumes
- `docker-compose stop && docker-compose rm -f` and `docker-compose up -d ` : restart docker compose
- `docker-compose ps -a` : see the docker compose images list
- `docker-compose run <service name>` : run only one of the services (part of services)
- `docker-compose logs` or `docker-compose logs --tail="all"`: see all logs
- `docker-compose logs --tail="all" <service_name>` : see logs in a certain service

another references, find [here](https://docs.docker.com/compose/reference/overview/)

