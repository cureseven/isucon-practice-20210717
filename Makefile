.PHONY: build stop-services start-services bench gogo truncate-logs kataribe

all: gogo

build:
	make -C go isuda
	make -C go isutar

truncate-logs:
	sudo truncate --size 0 /var/log/nginx/access.log
	sudo truncate --size 0 /var/log/nginx/error.log
	sudo truncate --size 0 /var/log/mysql/error.log
	sudo truncate --size 0 /var/log/mysql/mysql-slow.log

stop-services:
	sudo systemctl stop nginx
	sudo systemctl stop isuda.go.service
	sudo systemctl stop isutar.go.service
	sudo systemctl stop mysql

start-services:
	sudo systemctl start mysql
	sleep 5
	sudo systemctl start isuda.go.service
	sudo systemctl start isutar.go.service
	sudo systemctl start nginx

bench:
	cd ~/isucon6q && ./isucon6q-bench

kataribe:
	sudo cp /var/log/nginx/access.log /tmp/last-access.log && sudo chmod 666 /tmp/last-access.log
	cat /tmp/last-access.log | ./kataribe -conf kataribe.toml > /tmp/kataribe.log
	cat /tmp/kataribe.log

gogo: stop-services truncate-logs build start-services bench
