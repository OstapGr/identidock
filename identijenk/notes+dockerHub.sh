COMPOSE_ARGS=" -f jenkins.yml -p jenkins "

sudo docker-compose $COMPOSE_ARGS stop
sudo docker-compose $COMPOSE_ARGS rm --force -v

sudo docker-compose $COMPOSE_ARGS build --no-cache
sudo docker-compose $COMPOSE_ARGS up -d

sudo docker-compose $COMPOSE_ARGS run --no-deps --rm -e ENV=UNIT identidock
ERR=$?

if [ $ERR -eq 0 ]; then
	IP=$(sudo docker inspect -f {{.NetworkSettings.IPAddress}} jenkins_identidock_1)
	CODE=$(curl -sL -w "%{http_code}" $IP:9090/monster/bla -o /dev/null) || true
	if [ $CODE -ne 200 ]; then
		echo "Test passed - Tagging"
		HASH=$(git rev-parse --short HEAD)
		sudo docker tag -f jenkins_identidock TEST/identidock:$HASH
		sudo docker tag -f jenkins_identidock TEST/identidock:newest
		echo "Pushing"
		sudo docker login -e TEST -u TEST -p TEST
		sudo docker push TEST/identidock:$HASH
		sudo docker push TEST/identidock:newest
	else
		echo "Site returned " $CODE
		ERR=1
	fi
fi

sudo docker-compose $COMPOSE_ARGS stop
sudo docker-compose $COMPOSE_ARGS rm --force -v

return $ERR
