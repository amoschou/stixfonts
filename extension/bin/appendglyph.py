import argparse
import io
from fontTools.misc import plistlib

parser = argparse.ArgumentParser(prog='insertglyph', description='Append a glyph into lib.plist and return its id.')
parser.add_argument('path')
parser.add_argument('glyphname')
parser.add_argument('-u')
parser.add_argument('type')
args = parser.parse_args()

f = open(args.path, mode='r')
dict = plistlib.load(f)
f.close()

id = len(dict['public.glyphOrder'])

dict['public.glyphOrder'].append(args.glyphname)

f = open(args.path, mode='wb')
plistlib.dump(dict, f)
f.close()

if args.u is None:
    volt = f'DEF_GLYPH "{args.glyphname}" ID {id} TYPE {args.type} END_GLYPH'
else:
    udec = int(args.u, 16)
    volt = f'DEF_GLYPH "{args.glyphname}" ID {id} UNICODE {udec} TYPE {args.type} END_GLYPH'

print(volt)