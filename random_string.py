#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time:    2019/12/4 23:25
# @Name:    random_string.py
# @CodeBy:  PyCharm

"""
Generate random string
"""

import random
import string

from argparse import ArgumentParser


class RandomStringGenerator:
    suggest_str_max_len = 1024

    def __init__(self, str_len, sp):
        self.name = 'run'
        self.__type = 'both'
        self.__len = str_len
        self.__sp = sp

    def generate_string(self):
        if self.__sp:
            repeat_time = int(self.__len / 70 + 1)
            return ''.join(random.sample((string.ascii_letters + string.digits + '!@#$%^&*') * repeat_time, self.__len))
        elif self.__type == 'both':
            repeat_time = int(self.__len / 62 + 1)
            return ''.join(random.sample((string.ascii_letters + string.digits) * repeat_time, self.__len))
        elif self.__type == 'letter':
            repeat_time = int(self.__len / 52 + 1)
            return ''.join(random.sample(string.ascii_letters * repeat_time, self.__len))
        elif self.__type == 'digit':
            repeat_time = int(self.__len / 10 + 1)
            return ''.join(random.sample(string.digits * repeat_time, self.__len))


def parse_arguments():
    parser = ArgumentParser(description="generate secret")
    parser.add_argument("-l", "--length", required=False, type=int, metavar='num', default=8,
                        help="length of secret")
    parser.add_argument("-s", "--special-char", action="store_true", default=False,
                        help="secret with special characters")

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_arguments()
    run = RandomStringGenerator(str_len=args.length, sp=args.special_char)
    secret = run.generate_string()
    print(secret)
