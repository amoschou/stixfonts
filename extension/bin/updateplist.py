import argparse
import io
from fontTools.misc import plistlib

parser = argparse.ArgumentParser(prog='updateplist', description='Update a plist file with a key and a value')
parser.add_argument('path')
parser.add_argument('key')
parser.add_argument('--append', default=False, action=argparse.BooleanOptionalAction)
parser.add_argument('value')
args = parser.parse_args()

f = open(args.path, mode='r')
dict = plistlib.load(f)
f.close()

if args.append:
    dict[args.key] = dict[args.key] + "\n\n" + args.value
else:
    dict[args.key] = args.value

f = open(args.path, mode='wb')
plistlib.dump(dict, f)
f.close()




