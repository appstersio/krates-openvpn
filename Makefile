
.PHONY: build run test push down login

test:
	@docker-compose run toolbox -c "bundle install && rspec spec/"

build:
	@docker build --no-cache --pull -t krates/openvpn:latest .

run:
	@docker-compose run toolbox

push:
	@docker push krates/openvpn:latest

down:
	@docker-compose down && docker volume rm -f openvpn

login:
	@docker login -u="krates" -p="$$DOCKER_PASSWORD"