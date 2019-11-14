#!/bin/bash

cat > /etc/yum.repos.d/CentOS-AppStream-aliyun.repo << 'EOF'
[AppStream-aliyun]
name=CentOS-$releasever - AppStream-aliyun
baseurl=https://mirrors.aliyun.com/centos/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF

cat > /etc/yum.repos.d/CentOS-Base-aliyun.repo << 'EOF'
[BaseOS-aliyun]
name=CentOS-$releasever - BaseOS-aliyun
baseurl=https://mirrors.aliyun.com/centos/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF

cat > /etc/yum.repos.d/CentOS-Extras-aliyun.repo << 'EOF'
[extras-aliyun]
name=CentOS-$releasever - Extras-aliyun
baseurl=https://mirrors.aliyun.com/centos/$releasever/extras/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF