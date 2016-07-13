FROM tutum/lamp:latest
MAINTAINER Florent Appointaire <florent.appointaire@gmail.com>

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get -y install wget unzip php5-curl && \
	cd /var/www/html && \
	git clone https://github.com/chriseng/nestgraph.git && \
	cd nestgraph && \
	wget https://github.com/gboudreau/nest-api/archive/master.zip && \
	unzip master.zip && \
	rm -f master.zip && \
	echo "Europe/Brussels" > /etc/timezone && \
	dpkg-reconfigure --frontend noninteractive tzdata && \
	echo "*/5 * * * *  root  /bin/rm -f /tmp/nest_php_* ; /usr/bin/php /var/www/html/nestgraph/insert.php > /dev/null" >> /etc/cron.d/datapull && \
	echo "" >> /etc/cron.d/datapull && \
	chmod 644 /etc/cron.d/datapull && \
	sed -i \ 
	-e "s/'db_pass' => 'choose_a_db_password'/'db_pass' => 'nest_password'/" \ 
	-e "s/'nest_user' => 'your_nest_username'/'nest_user' => getenv('ENV_NEST_USER')/" \ 
	-e "s/'nest_pass' => 'your_nest_password'/'nest_pass' => getenv('ENV_NEST_PASSWORD')/" \ 
	-e "s/'local_tz' => 'America\/New_York'/'local_tz' => 'Europe\/Brussels'/" \ 
	/var/www/html/nestgraph/inc/config.php && \
	sed -i -e "s/'choose_a_db_password'/'nest_password'/" /var/www/html/nestgraph/dbsetup && \
	sed -i -e "s|DocumentRoot /var/www/html|DocumentRoot /var/www/html/nestgraph|" /etc/apache2/sites-enabled/000-default.conf && \
	sed -i -e "s|.text(\"Temperature (F)\");|.text(\"Temperature (C)\");|" /var/www/html/nestgraph/index.html && \
	sed -i -e "s/+ 60//" /var/www/html/nestgraph/index.html && \
	echo "mysql -u root -e \"CREATE USER 'nest_admin'@'localhost' IDENTIFIED BY 'nest_password';\"" >> /mysql-setup.sh && \
	echo "mysql -u root < /var/www/html/nestgraph/dbsetup" >> /mysql-setup.sh && \
	echo "env >> /etc/environment" >> /mysql-setup.sh && \
	chmod +x /mysql-setup.sh && \
	echo "[program:cron]" >> /etc/supervisor/supervisord.conf && \
	echo "command = /usr/sbin/cron" >> /etc/supervisor/supervisord.conf && \
	apt-get clean
CMD	["/run.sh"]