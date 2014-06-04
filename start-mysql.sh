#!/bin/bash
mysqld_safe &
while ! ( echo ping | nc 127.0.0.1 3306 ) > /dev/null
do
    echo -n .
    sleep 0.1
done

if test -z "$ROOT_PASSWORD"
then
    echo 'Warn: please set $ROOT_PASSWORD env like: -e ROOT_PASSWORD=foobar.' 1>&2
    exit 127
fi

if test ! -f /root/mysql-initialized
then
    [ -z "$DB" ] && DB="db"
    echo "CREATE DATABASE $DB;" | mysql -u root --password=mysq1
    echo "UPDATE mysql.user SET Password=PASSWORD('$ROOT_PASSWORD') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=mysq1 mysql
    echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root --password="$ROOT_PASSWORD" mysql
    touch /root/mysql-initialized
fi

tailf /var/log/mysql.log
