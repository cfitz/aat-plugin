vi /etc/yum.repos.d/nginx.repo

[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/rhel/6/$basearch/
gpgcheck=0
enabled=1

cd ~
wget "https://github.com/archivesspace/archivesspace/releases/download/v1.0.7.1/archivesspace-v1.0.7.1.zip"
unzip archivesspace-v1.0.7.1.zip 
mv archivesspace /usr/share/archivesspace-1.0.7/
ln -s /usr/share/archivesspace-1.0.7/ /usr/share/archivesspace
sudo mkdir /var/archivesspace
sudo mkdir /var/archivesspace/data
rm -r /usr/share/archivesspace/data
sudo ln -s /var/archivesspace/data /usr/share/archivesspace/data


sudo yum update
sudo yum install mysql-server mysql nginx
mysqladmin -u root password aspace123
sudo service mysqld start

mysql -u root -p
mysql>  create database archivesspace default character set utf8;
mysql> grant all on archivesspace.* to 'as'@'localhost' identified by 'as123';
mysql> exit;



vi /etc/nginx/conf.d/aspace.me.conf 

AppConfig[:frontend_url] = "http://localhost:8080/staff"
AppConfig[:db_url] =
"jdbc:mysql://localhost:3306/archivesspace?user=as&password=as123&useUnicode=true&characterEncoding=UTF-8"

AppConfig[:plugins] = ['local', 'aspace_feedack', 'lcnaf', "aat"]




upstream frontend {
     server localhost:8080;
}

upstream public {
     server localhost:8081;
}


server {
  listen       80;
  server_name  aspace.me;
          
  location /staff {
    proxy_pass http://frontend;
  }
                           
  location / {
    locationproxy_pass http://public;
   } 
location /plugins {
   proxy_pass http://frontend;
}
        
  access_log  /var/log/nginx/nginxlog/aspace.access.log  main;
                                       
}

vi /usr/share/archivespace/config/config.rb



