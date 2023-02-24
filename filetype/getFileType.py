#!/usr/bin/env python3
import filetype
import boto3
import sys
import os
# import getopt

def main():
    # future programming: catch error with getopt
    argv = sys.argv[1:]
    print("this is the first arg: ",argv[0])
    print("this is the second arg: ",argv[1])
    #kind = filetype.guess(file)
    #if kind is None:
    #    print('Cannot guess file type!')
    #    return

    #print('File extension: %s' % kind.extension)
    #print('File MIME type: %s' % kind.mime)

if __name__ == '__main__':
    main()