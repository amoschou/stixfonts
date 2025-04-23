#!/bin/bash

cat ${1} | jq '
    .font.glyphs
	| [
	    .[]
	    | select(.name == (
			"alpha","epsilon","eta","iota","omicron","rho","upsilon","omega",
			"alphatonos","epsilontonos","etatonos","iotatonos","omicrontonos","upsilontonos","omegatonos",
			"iotadialytika","upsilondialytika"
		))
	]
	| map({
		(.name): {
			"unicode": .unicode,
			"italic": (
				.layers[]
				| select(.name == "Italic")
				| {
					"advance-width": .advanceWidth,
					"anchors": .anchors
						| map({(.name): .point | split(" ")})
						| add
				}
			),
			"bold-italic": (
				.layers[]
				| select(.name == "BoldItalic")
				| {
					"advance-width": .advanceWidth,
					"anchors": .anchors
						| map({(.name): .point | split(" ")})
						| add
				}
			)
		}
	})
	| add
	| {
		alpha:   {base: .alpha,   basetonos: .alphatonos                                    },
		epsilon: {base: .epsilon, basetonos: .epsilontonos                                  },
		eta:     {base: .eta,     basetonos: .etatonos                                      },
		iota:    {base: .iota,    basetonos: .iotatonos,    basedialytika: .iotadialytika   },
		omicron: {base: .omicron, basetonos: .omicrontonos                                  },
		rho:     {base: .rho,     basetonos: .rho                                           },
		upsilon: {base: .upsilon, basetonos: .upsilontonos, basedialytika: .upsilondialytika},
		omega:   {base: .omega,   basetonos: .omegatonos                                    }
	}
' > ${2}