import argparse
import io
from fontTools.misc import plistlib

parser = argparse.ArgumentParser(prog='updateplist', description='Read a plist file and format results')
parser.add_argument('format')
parser.add_argument("-i")
parser.add_argument('path')
args = parser.parse_args()

f = open(args.path, mode='r')
dict = plistlib.load(f)
f.close()

if args.format == 'keys':
    print(' '.join(dict.keys()))

if args.format == 'val':
    print(dict[args.i])
