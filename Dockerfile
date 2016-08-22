# Android development environment for ubuntu precise (12.04 LTS) (i386).
# version 0.0.4

# Start with ubuntu 12.04 (i386).
FROM ubuntu:12.04

MAINTAINER momon <momon@gmail.com>

RUN export ROOTPASSWORD=android && \
    export DEBIAN_FRONTEND=noninteractive && \
    echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    apt-get -y update && \
    apt-get -y install python-software-properties bzip2 ssh net-tools socat && \
    add-apt-repository ppa:webupd8team/java && \
    echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install oracle-java7-installer && \
    apt-get install -y nginx openssh-server git-core openssh-client curl && \
    apt-get install -y nano && \
    apt-get install -y build-essential && \
    apt-get install -y openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config && \
    wget http://dl.google.com/android/android-sdk_r23-linux.tgz && \
    tar -xvzf android-sdk_r23-linux.tgz && \
    mv android-sdk-linux /usr/local/android-sdk && \
    wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz && \
    tar -xvzf apache-ant-1.8.4-bin.tar.gz && \
    mv apache-ant-1.8.4 /usr/local/apache-ant && \
    export ANDROID_HOME=/usr/local/android-sdk && \
    export PATH=$PATH:$ANDROID_HOME/tools && \
    export PATH=$PATH:$ANDROID_HOME/platform-tools && \
    export ANT_HOME=/usr/local/apache-ant && \
    export PATH=$PATH:$ANT_HOME/bin && \
    export JAVA_HOME=/usr/lib/jvm/java-7-oracle && \
    cd / && \
    rm -f *gz && \
    chown -R root:root /usr/local/android-sdk/ && \
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
    mkdir /usr/local/android-sdk/tools/keymaps && \
    touch /usr/local/android-sdk/tools/keymaps/en-us && \
    mkdir /var/run/sshd && \
    echo "root:$ROOTPASSWORD" | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    export NOTVISIBLE="in users profile" && \
    echo "export VISIBLE=now" >> /etc/profile && \
    wget -O /entrypoint.sh https://raw.githubusercontent.com/pcbuilders/android-emulator/master/entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    curl -L https://get.rvm.io | bash -s stable && \
    /bin/bash -l -c "rvm requirements" && \
    /bin/bash -l -c "rvm install 2.0" && \
    /bin/bash -l -c "gem install bundler --no-ri --no-rdoc" && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

ENV ROOTPASSWORD=android \
    DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/usr/local/android-sdk \
    PATH=$PATH:$ANDROID_HOME/tools \
    PATH=$PATH:$ANDROID_HOME/platform-tools \
    ANT_HOME=/usr/local/apache-ant \
    PATH=$PATH:$ANT_HOME/bin \
    JAVA_HOME=/usr/lib/jvm/java-7-oracle \
    NOTVISIBLE="in users profile"

EXPOSE  22 \
        5037 \
        5554 \
        5555 \
        5900

ENTRYPOINT ["/entrypoint.sh"]
