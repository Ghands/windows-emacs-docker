FROM ubuntu:18.04
LABEL maintainer="Windows docker emacs client <623482199@qq.com>"
LABEL version="0.0.1"

ENV LANG C.UTF-8

RUN rm -rf /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list

COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

RUN apt-get clean \
    && apt-get update -y \
    && apt-get install emacs hunspell git texlive-full wget curl evince \
    ttf-mscorefonts-installer ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming -y

ADD hunspell-dict.tar.gz /usr/share/hunspell

RUN wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-1-amd64.deb \
    && dpkg -i pandoc-2.7.3-1-amd64.deb && rm -f pandoc-2.7.3-1-amd64.deb

RUN mkdir ~/.emacs.d/
ADD init.el ~/.emacs.d/

CMD ["emacs", "--display"]
