#!/usr/bin/env python
"""
Overview System Information
"""

import platform


class SystemInfoCollector:
    def __init__(self):
        self.hostname = platform.node()
        self.python_version = platform.python_version()
        self.python_version_primary = platform.python_version_tuple()[0]
        self.python_version_second = platform.python_version_tuple()[1]
        self.python_version_third = platform.python_version_tuple()[2]
        self.system = platform.system()  # Windows | Linux
        if self.system == "Windows":
            self.os_version = platform.release()
            self.os_revision = platform.version()
        elif self.system == "Linux":
            self.os_version = ''


if __name__ == "__main__":
    a = SystemInfoCollector()
    for k, v in a.__dict__.items():
        if k in ("python_version_primary", "python_version_second", "python_version_third"):
            continue
        print("{:>30}: {:20}".format(k, v))
