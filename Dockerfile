FROM ruby:2.6.5 as base

ENV TZ=America/New_York
ENV LANG=C.UTF-8

# System packages
RUN apt-get update && \
  apt-get install --no-install-recommends libstdc++6 libffi-dev wget libpng-dev make curl unzip -y && \
  rm -rf /var/lib/apt/lists/*

# FITS!
RUN curl -Lo /tmp/fits.zip https://github.com/harvard-lts/fits/releases/download/1.5.0/fits-1.5.0.zip

RUN mkdir -p /usr/share/fits
RUN unzip /tmp/fits.zip -d /usr/share/fits

RUN mkdir -p /usr/share/man/man1

RUN apt-get update && \ 
    apt-get install --no-install-recommends tomcat9 libmediainfo-dev openjdk-11-jre-headless -y && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /usr/share/tomcat9/conf
RUN ln -s /etc/tomcat9/catalina.properties /usr/share/tomcat9/conf/
RUN ln -s /etc/tomcat9/tomcat-users.xml /usr/share/tomcat9/conf/
RUN ln -s /etc/tomcat9/server.xml /usr/share/tomcat9/conf/

RUN echo 'fits.home=/usr/share/fits' >> /usr/share/tomcat9/conf/catalina.properties
RUN echo 'shared.loader=${fits.home}/lib/*.jar' >> /usr/share/tomcat9/conf/catalina.properties
RUN mkdir /usr/share/tomcat9/webapps
RUN mkdir /usr/share/tomcat9/logs
RUN curl -Lo /usr/share/tomcat9/webapps/fits.war https://projects.iq.harvard.edu/files/fits/files/fits-1.2.1.war

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle install

COPY . /app/
CMD [ "/app/entrypoint.sh" ]