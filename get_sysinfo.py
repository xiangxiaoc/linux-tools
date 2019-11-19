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
            self.windows_version = platform.release()
            self.windows_revision = platform.version()
        elif self.system == "Linux":
            self.linux_version = ''


if __name__ == "__main__":
    a = SystemInfoCollector()
    print(a.__dict__)
