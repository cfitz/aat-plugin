EXAMPLE ARCHIVESSPACE SETUP ON RHEL
====

#### Update the server and install a couple of things
sudo yum update                                                                                                              

#### Setup Nginx for Reverse Proxy
vi /etc/yum.repos.d/nginx.repo

sudo yum install nginx

```
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/rhel/6/$basearch/
gpgcheck=0
enabled=1
```

vi /etc/nginx/conf.d/aspace.me.conf 

```
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
                                   
  access_log  /var/log/nginx/nginxlog/aspace.access.log  main;
                                       
}
```

#### Install and setup mysql

sudo yum install mysql-server mysql 
mysqladmin -u root password aspace123
sudo service mysqld start

mysql -u root -p
mysql>  create database archivesspace default character set utf8;
mysql> grant all on archivesspace.* to 'as'@'localhost' identified by 'as123';
mysql> exit;

#### Install Aspace

cd ~
wget "https://github.com/archivesspace/archivesspace/releases/download/v1.0.7.1/archivesspace-v1.0.7.1.zip"
unzip archivesspace-v1.0.7.1.zip 
mv archivesspace /usr/share/archivesspace-1.0.7/
ln -s /usr/share/archivesspace-1.0.7/ /usr/share/archivesspace
sudo mkdir -p /var/archivesspace/data
rm -r /usr/share/archivesspace/data
sudo ln -s /var/archivesspace/data /usr/share/archivesspace/data


#### Start Aspace

sudo /usr/share/archivesspace/archivesspace.sh start


