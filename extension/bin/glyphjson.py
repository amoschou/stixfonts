from fontTools.pens.boundsPen import BoundsPen
from fontTools.ufoLib.glifLib import GlyphSet
import argparse
import json

parser = argparse.ArgumentParser(prog='glyphjson', description='Gets the properties of glyph in json format')
parser.add_argument('glyphsetpath')
parser.add_argument('glyphname')
args = parser.parse_args()

g = GlyphSet(args.glyphsetpath)

boundspen = BoundsPen(g)

g[args.glyphname].draw(boundspen)

class MyGlyphClass:
    name = None
    width = None
    height = None
    unicodes = None
    note = None
    lib = None
    image = None
    guidelines = None
    anchors = None
    box = None

glyph = MyGlyphClass()

g.readGlyph(args.glyphname, glyph)

glyph.box = {
    "left": boundspen.bounds[0],
    "bottom": boundspen.bounds[1],
    "right": boundspen.bounds[2],
    "top": boundspen.bounds[3],
    "width": boundspen.bounds[2] - boundspen.bounds[0],
    "height": boundspen.bounds[3] - boundspen.bounds[1]
}

result = json.dumps(glyph.__dict__)

print(result)
