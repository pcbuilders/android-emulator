# Android development environment for ubuntu precise (12.04 LTS) (i386).
# version 0.0.4

# Start with ubuntu 12.04 (i386).
FROM ubuntu-debootstrap:wily

MAINTAINER momon <momon@gmail.com>

ENV ROOTPASSWORD=android \
    DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/usr/local/android-sdk \
    PATH=$PATH:$ANDROID_HOME/tools \
    PATH=$PATH:$ANDROID_HOME/platform-tools \
    ANT_HOME=/usr/local/apache-ant \
    PATH=$PATH:$ANT_HOME/bin \
    JAVA_HOME=/usr/lib/jvm/java-7-oracle \
    NOTVISIBLE="in users profile"

RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    apt-get -y update && \
    apt-get -y install software-properties-common bzip2 net-tools socat ruby-full openssh-server && \
    gem install bundler --no-ri --no-rdoc && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get -y update && \
    apt-get -y install oracle-java7-installer && \
    wget http://dl.google.com/android/android-sdk_r23-linux.tgz && \
    tar -xvzf android-sdk_r23-linux.tgz && \
    mv android-sdk-linux /usr/local/android-sdk && \
    wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.4-bin.tar.gz && \
    tar -xvzf apache-ant-1.8.4-bin.tar.gz && \
    mv apache-ant-1.8.4 /usr/local/apache-ant && \
    cd / && \
    rm -f *gz && \
    chown -R root:root /usr/local/android-sdk/ && \
    export ANDROID_HOME=/usr/local/android-sdk && \
    export PATH=$PATH:$ANDROID_HOME/tools && \
    export PATH=$PATH:$ANDROID_HOME/platform-tools && \
    export ANT_HOME=/usr/local/apache-ant && \
    export PATH=$PATH:$ANT_HOME/bin && \
    export JAVA_HOME=/usr/lib/jvm/java-7-oracle && \
    export NOTVISIBLE="in users profile" && \
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
    echo "root:$ROOTPASSWORD" | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    wget -O /entrypoint.sh https://raw.githubusercontent.com/pcbuilders/android-emulator/master/entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

EXPOSE  22 \
        5037 \
        5554 \
        5555 \
        5900

ENTRYPOINT ["/entrypoint.sh"]
