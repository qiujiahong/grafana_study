# docker安装

在操作之前读者需要提前安装好docker


## 快速安装使用

```bash
docker run -d -p 3000:3000 grafana/grafana:6.2.5 
```


## 配置

* 所有在文件conf/grafana.ini中定义的变量都可以使用环境变量重写，语法为``GF_<SectionName>_<KeyName>``,如:

```bash
# 例 1
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_SECURITY_ADMIN_PASSWORD=123456" \
  grafana/grafana:6.2.5 
# 例 2 多个变量
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_SERVER_ROOT_URL=http://grafana.server.name" \
  -e "GF_SECURITY_ADMIN_PASSWORD=123456" \
  grafana/grafana:6.2.5 
```

> 更多配置可参考[官方文档](https://grafana.com/docs/installation/configuration/)

* 在docker启动的时候，默认路径只能通过环境变量，而不能通过修改文件conf/grafana.ini来配置，默认路径配置参数如下： 

| Setting               | Default value             |
|-----------------------|---------------------------|
| GF_PATHS_CONFIG       | /etc/grafana/grafana.ini  |
| GF_PATHS_DATA         | /var/lib/grafana          |
| GF_PATHS_HOME         | /usr/share/grafana        |
| GF_PATHS_LOGS         | /var/log/grafana          |
| GF_PATHS_PLUGINS      | /var/lib/grafana/plugins  |
| GF_PATHS_PROVISIONING | /etc/grafana/provisioning |



## 安装plugins


传递想要安装的插件给环境变量GF_INSTALL_PLUGINS即可安装对应的插件，如果有多个插件，可以使用逗号隔开.这个环境变量将会传递值给grafana，在grafana启动的时候执行对应的安装命令``grafana-cli plugins install ${plugin}``.

```bash
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
  grafana/grafana:6.2.5 
```


## 自定义编译一个已经安装好插件的docker image

在[grafana-docker](https://github.com/grafana/grafana-docker)有一个custom/文件夹，该文件夹包含一个 Dockerfile可以被用来编译自定义的image. 可以配置GRAFANA_VERSION 和 GF_INSTALL_PLUGINS 做为编译参数.

例子如下:

```bash
cd custom
docker build -t grafana:latest-with-plugins \
  --build-arg "GRAFANA_VERSION=latest" \
  --build-arg "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" .

docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  grafana:latest-with-plugins
```






# 从自定义源安装插件
> 只在v5.3.1+版本后使用

可以通过一个自定义的url安装插件只需要传递值给GF_INSTALL_PLUGINS环境变量即可，语法：``GF_INSTALL_PLUGINS=<url to plugin zip>;<plugin name>``

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -e "GF_INSTALL_PLUGINS=http://plugin-domain.com/my-custom-plugin.zip;custom-plugin" \
  grafana/grafana
```

## 持久化数据和plugins,/var/lib/grafana

```
docker volume create grafana-storage
# start grafana
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -v grafana-storage:/var/lib/grafana \
  grafana/grafana
```

* 使用主机文件挂载

```
mkdir data # creates a folder for your data
ID=$(id -u) # saves your user id in the ID variable
# starts grafana with your user id and using the data folder
docker run -d --user $ID --volume "$PWD/data:/var/lib/grafana" -p 3000:3000 grafana/grafana:6.2.5 
```

## 系统升级

待完善


## 登录


运行Grafana，打开浏览器访问http://localhost:3000/. 后续跟随指引[快速入门](./get_started.md)

