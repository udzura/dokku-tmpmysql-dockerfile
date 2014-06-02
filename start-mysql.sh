mysqld_safe &
while ! lsof -i:3306
do
    echo -n .
    sleep 0.1
done

if [[ ! -f /root/mysql-initialized ]]; then
    echo "CREATE DATABASE db;" | mysql -u root --password=mysq1
    echo "UPDATE mysql.user SET Password=PASSWORD('$ROOT_PASSWORD') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=mysq1 mysql
    echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root --password="$ROOT_PASSWORD" mysql
    touch /root/mysql-initialized
fi
