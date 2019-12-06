FROM openjdk:8u212-jre-alpine

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone

VOLUME /tmp

EXPOSE 8125 

COPY target/demo1.jar  /demo1.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/demo1.jar"]
