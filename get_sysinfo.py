#!/usr/bin/env python
"""
System Information Overview
"""

import platform
import socket


class SystemInfoCollector:
    def __init__(self, name='undefine'):
        self.name = name
        self.hostname = platform.node()
        self.python_version = platform.python_version()
        self.python_version_primary = platform.python_version_tuple()[0]
        self.python_version_second = platform.python_version_tuple()[1]
        self.python_version_third = platform.python_version_tuple()[2]
        self.processor = platform.processor()
        self.os = platform.system()  # Windows | Linux
        self.os_architecture = platform.architecture()[0]
        if self.os == "Windows":
            self.os_version = platform.release()
            self.os_revision = platform.version()
        elif self.os == "Linux":
            self.kernel_version = platform.release()
            self.os_name = platform.dist()[0]
            self.os_version = platform.dist()[1]
            self.os_version_name = platform.dist()[2]
        self.ip = socket.gethostbyname(self.hostname)

    def get_public_ip(self):
        pass


if __name__ == "__main__":
    a = SystemInfoCollector()
    hidden_info = ("name", "python_version_primary", "python_version_second", "python_version_third")
    for k, v in a.__dict__.items():
        if k in hidden_info:
            continue
        print("{:>30}: {:20}".format(k, v))
