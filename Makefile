
.PHONY: build run test push down

build:
	@docker build --no-cache --pull -t krates/openvpn:latest .

run:
	@docker-compose run toolbox

test:
	@docker-compose run toolbox -c "bundle install && rspec spec/"

push:
	@docker push krates/openvpn:latest

down:
	@docker-compose down && docker volume rm -f openvpn