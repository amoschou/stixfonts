import argparse
from defcon import Font
from ufo2ft import compileTTF

parser = argparse.ArgumentParser(prog='ufo2ttf', description='Convert UFO to TTF')
parser.add_argument('ufo')
parser.add_argument('ttf')
args = parser.parse_args()

compileTTF(Font(args.ufo)).save(args.ttf)
