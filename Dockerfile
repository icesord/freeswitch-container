FROM debian:latest
MAINTAINER xuzhenhai<xuzhenhai@x-y-t.cn>
COPY sources.list.163.stretch /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
  --no-install-recommends --no-install-suggests \
  build-essential automake autoconf 'libtool-bin|libtool' wget curl \
  python uuid-dev zlib1g-dev 'libjpeg8-dev|libjpeg62-turbo-dev' \
  libncurses5-dev libssl1.0-dev libpcre3-dev libcurl4-openssl-dev \
  libedit-dev libspeexdsp-dev libspeexdsp-dev \
  libsqlite3-dev perl libgdbm-dev libdb-dev bison libvlc-dev pkg-config \
  libsndfile1-dev libopus-dev lua5.2-dev libtiff-dev libavresample-dev libfreetype6\
  libpng16-16 yasm nasm libavformat-dev libswscale-dev libavfilter-dev \
  libavresample-dev libshout-dev libmpg123-dev libmp3lame-dev \
  libmagickcore-dev \
  uuid zlib1g 'libjpeg8|libjpeg62-turbo' \
  libncurses5 libssl1.0 libpcre3 libcurl3 \
  libedit2 libspeexdsp1 \
  libsqlite3-0 libgdbm3 libdb5.3 libvlc5 \
  libsndfile1 libopus0 liblua5.2-0 libtiff5 libavresample3 libfreetype6 \
  libpng16-16 yasm nasm libavformat57 libswscale4 libavfilter6 \
  libavresample3 libshout3 libmpg123-0 libmp3lame0 \
  libmagickcore-6.q16-3 libjemalloc1 \
  libhiredis0.13 unixodbc \
  unixodbc unixodbc-dev sqlite3 odbc-postgresql \
  git htop procps gdb ca-certificates locales\
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && rm -rf /var/lib/apt/lists/*

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 

WORKDIR /usr/src
RUN git clone https://freeswitch.org/stash/scm/fs/freeswitch.git 

WORKDIR freeswitch
RUN ./bootstrap.sh 
ADD  modules.conf /usr/src/freeswitch/modules.conf
RUN ./configure && make && make install && make cd-sounds-install && make cd-moh-install
RUN rm -fr /usr/src/freeswitch
ADD modules.conf.xml /usr/local/freeswitch/conf/autoload_configs/
RUN ln -sf /usr/local/freeswitch/bin/freeswitch /usr/bin/
RUN ln -sf /usr/local/freeswitch/bin/fs_cli /usr/bin/

WORKDIR /usr/local/freesitch
ADD docker-entrypiont.sh /
RUN chmod a+x /docker-entrypiont.sh
CMD ["/docker-entrypiont.sh"]
