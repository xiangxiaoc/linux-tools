#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Time:    2019/12/4 23:25
# @Name:    random_string.py
# @CodeBy:  PyCharm

"""
Generate random string
"""

from string import ascii_letters, digits
from random import sample
from math import ceil
from argparse import ArgumentParser


class RandomStringGenerator:
    suggest_str_max_len = 1024

    def __init__(self, str_len, special_char=False):
        self.__type = 'both'
        self.__len = str_len
        self.__sp = special_char

    def generate_string(self):
        total_str_library = ''
        char_pool_num = 0
        if self.__sp:
            str_library = '!@#$%^&*'
            total_str_library += str_library
            char_pool_num += str_library.__len__()
        if self.__type == 'both':
            str_library = ascii_letters + digits
            total_str_library += str_library
            char_pool_num += str_library.__len__()
        if self.__type == 'letter':
            str_library = ascii_letters
            total_str_library += str_library
            char_pool_num += str_library.__len__()
        if self.__type == 'digit':
            str_library = digits
            total_str_library += str_library
            char_pool_num += str_library.__len__()
        repeat_time = ceil(self.__len / char_pool_num)
        char_list = sample(total_str_library * repeat_time, self.__len)
        return ''.join(char_list)


def parse_arguments():
    parser = ArgumentParser(description="generate secret")
    parser.add_argument("-l", "--length", required=False, type=int, metavar='num', default=8,
                        help="length of secret")
    parser.add_argument("-s", "--special-char", action="store_true", default=False,
                        help="secret with special characters")

    return parser.parse_args()


if __name__ == '__main__':
    args = parse_arguments()
    run = RandomStringGenerator(args.length, args.special_char)
    secret = run.generate_string()
    print(secret)
