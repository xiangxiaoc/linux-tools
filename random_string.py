#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time:    2019/12/4 23:25
# @Name:    random_string.py
# @CodeBy:  PyCharm

"""
Generate random string
"""

import random
import string
import sys


class RandomStringGenerator:
    suggest_str_max_len = 1024

    def __init__(self, str_type='both', str_len=8):
        self.name = str_type + '_str_generator'
        self.__type = str_type
        self.__len = str_len

    def generate_string(self):
        if self.__type == 'both':
            repeat_time = int(self.__len / 62 + 1)
            return ''.join(random.sample((string.ascii_letters + string.digits) * repeat_time, self.__len))
        elif self.__type == 'letter':
            repeat_time = int(self.__len / 52 + 1)
            return ''.join(random.sample(string.ascii_letters * repeat_time, self.__len))
        elif self.__type == 'digit':
            repeat_time = int(self.__len / 10 + 1)
            return ''.join(random.sample(string.digits * repeat_time, self.__len))


if __name__ == '__main__':
    try:
        input_str_len = int(sys.argv[1])
    except IndexError:
        input_str_len = 8
    try:
        input_str_type = sys.argv[2]
    except IndexError:
        input_str_type = "both"
    print(RandomStringGenerator(str_len=input_str_len, str_type=input_str_type).generate_string())
