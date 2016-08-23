# Android + ruby development environment for ubuntu wily.

FROM ubuntu-debootstrap:wily

MAINTAINER momon <momon@gmail.com>

ENV PUBLIC_KEY='' \
    ANDROID_HOME=/usr/local/android-sdk \
    PATH=$PATH:/usr/local/android-sdk/tools \
    PATH=$PATH:/usr/local/android-sdk/platform-tools \
    ANT_HOME=/usr/local/apache-ant \
    PATH=$PATH:/usr/local/apache-ant/bin \
    JAVA_HOME=/usr/lib/jvm/java-7-oracle

ARG DEBIAN_FRONTEND noninteractive

ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh && \
    echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    apt-get -y -qq update && \
    apt-get -y -qq install software-properties-common bzip2 net-tools socat ruby-full ssh && \
    gem install bundler --no-ri --no-rdoc -q && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get -y -qq update && \
    apt-get -y -qq install oracle-java7-installer && \
    mkdir -p {$ANDROID_HOME,$ANT_HOME} && \
    wget -qO- http://dl.google.com/android/android-sdk_r23-linux.tgz | tar xz -C $ANDROID_HOME  --strip-components=1 && \
    wget -qO- http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz | tar xz -C $ANT_HOME      --strip-components=1 && \
    chown -R root:root $ANDROID_HOME && \
    echo "y" | android update sdk --filter platform-tool --no-ui --force && \
    echo "y" | android update sdk --filter platform --no-ui --force && \
    echo "y" | android update sdk --filter build-tools-22.0.1 --no-ui -a && \
    echo "y" | android update sdk --filter sys-img-x86-android-19 --no-ui -a && \
    echo "y" | android update sdk --filter sys-img-x86-android-21 --no-ui -a && \
    echo "y" | android update sdk --filter sys-img-x86-android-22 --no-ui -a && \
    echo "y" | android update sdk --filter sys-img-armeabi-v7a-android-19 --no-ui -a && \
    echo "y" | android update sdk --filter sys-img-armeabi-v7a-android-21 --no-ui -a && \
    echo "y" | android update sdk --filter sys-img-armeabi-v7a-android-22 --no-ui -a && \
    echo "y" | android update adb && \
    mkdir $ANDROID_HOME/tools/keymaps && \
    touch $ANDROID_HOME/android-sdk/tools/keymaps/en-us && \
    mkdir ~/.ssh && \
    echo $PUBLIC_KEY > ~/.ssh/authorized_keys && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

EXPOSE  22 \
        5037 \
        5554 \
        5555 \
        5900

ENTRYPOINT ["/entrypoint.sh"]
