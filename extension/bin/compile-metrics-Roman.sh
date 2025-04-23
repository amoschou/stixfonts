#!/bin/bash

cat ${1} | jq '
    .font.glyphs
	| [
	    .[]
	    | select(.name == (
			"alpha","epsilon","eta","iota","omicron","rho","upsilon","omega",
			"alphatonos","epsilontonos","etatonos","iotatonos","omicrontonos","upsilontonos","omegatonos",
			"iotadialytika","upsilondialytika",
            "dialytikacomb","tonoscomb","dialytikatonoscomb","brevecomb","macroncomb",
            "Alpha","Epsilon","Eta","Iota","Omicron","Rho","Upsilon","Omega",
            "Alphatonos","Epsilontonos","Etatonos","Iotatonos","Omicrontonos","Upsilontonos","Omegatonos",
            "tonos","brevecomb.cap","macroncomb.cap"
		))
	]
	| map({
		(.name): {
			"unicode": .unicode,
			"regular": (
				.layers[]
				| select(.name == "Regular")
				| {
					"advance-width": .advanceWidth,
					"anchors": .anchors
						| map({(.name): .point | split(" ") | to_entries | map(.value | tonumber)})
						| add
				}
			),
			"bold": (
				.layers[]
				| select(.name == "Bold")
				| {
					"advance-width": .advanceWidth,
					"anchors": .anchors
						| map({(.name): .point | split(" ") | to_entries | map(.value | tonumber)})
						| add
				}
			)
		}
	})
	| add
	| {
        common: {
            coordinates: {
                regular: {
                    "tonoscomb": (.tonoscomb.regular.anchors),
                    "dialytikacomb": (.dialytikacomb.regular.anchors),
                    "dialytikatonoscomb": (.dialytikatonoscomb.regular.anchors),
                    "brevecomb": (.brevecomb.regular.anchors),
                    "macroncomb": (.macroncomb.regular.anchors),
                    "brevecomb.cap": (."brevecomb.cap".regular.anchors),
                    "macroncomb.cap": (."macroncomb.cap".regular.anchors)
                },
                bold: {
                    "tonoscomb": (.tonoscomb.bold.anchors),
                    "dialytikacomb": (.dialytikacomb.bold.anchors),
                    "dialytikatonoscomb": (.dialytikatonoscomb.bold.anchors),
                    "brevecomb": (.brevecomb.bold.anchors),
                    "macroncomb": (.macroncomb.bold.anchors),
                    "brevecomb.cap": (."brevecomb.cap".bold.anchors),
                    "macroncomb.cap": (."macroncomb.cap".bold.anchors)
                }
            }
        },
		alpha: {
            base: .alpha,
            basetonos: .alphatonos,
            coordinates: {
                regular: {
                    "topaxis": .alpha.regular.anchors.top.[0],
                    "diff": ((.alphatonos.regular.anchors."top.mkmk".[0]) - (.alpha.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.alpha.regular.anchors.top.[0])) - (.alphatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.alpha.regular.anchors.top.[0]) + 230)) - (((.alphatonos.regular.anchors."top.mkmk".[0]) - (.alpha.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.alpha.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.alpha.regular.anchors.top.[0]) + 230)) + (((.alphatonos.regular.anchors."top.mkmk".[0]) - (.alpha.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.alphatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.alpha.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .alpha.bold.anchors.top.[0],
                    "diff": ((.alphatonos.bold.anchors."top.mkmk".[0]) - (.alpha.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.alpha.bold.anchors.top.[0])) - (.alphatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.alpha.bold.anchors.top.[0]) + 200)) - (((.alphatonos.bold.anchors."top.mkmk".[0]) - (.alpha.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.alpha.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.alpha.bold.anchors.top.[0]) + 200)) + (((.alphatonos.bold.anchors."top.mkmk".[0]) - (.alpha.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.alphatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.alpha.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
		epsilon: {
            base: .epsilon,
            basetonos: .epsilontonos,
            coordinates: {
                regular: {
                    "topaxis": .epsilon.regular.anchors.top.[0],
                    "diff": ((.epsilontonos.regular.anchors."top.mkmk".[0]) - (.epsilon.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.epsilon.regular.anchors.top.[0])) - (.epsilontonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.epsilon.regular.anchors.top.[0]) + 230)) - (((.epsilontonos.regular.anchors."top.mkmk".[0]) - (.epsilon.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.epsilon.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.epsilon.regular.anchors.top.[0]) + 230)) + (((.epsilontonos.regular.anchors."top.mkmk".[0]) - (.epsilon.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.epsilontonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.epsilon.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .epsilon.bold.anchors.top.[0],
                    "diff": ((.epsilontonos.bold.anchors."top.mkmk".[0]) - (.epsilon.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.epsilon.bold.anchors.top.[0])) - (.epsilontonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.epsilon.bold.anchors.top.[0]) + 200)) - (((.epsilontonos.bold.anchors."top.mkmk".[0]) - (.epsilon.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.epsilon.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.epsilon.bold.anchors.top.[0]) + 200)) + (((.epsilontonos.bold.anchors."top.mkmk".[0]) - (.epsilon.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.epsilontonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.epsilon.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
		eta: {
            base: .eta,
            basetonos: .etatonos,
            coordinates: {
                regular: {
                    "topaxis": .eta.regular.anchors.top.[0],
                    "diff": ((.etatonos.regular.anchors."top.mkmk".[0]) - (.eta.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.eta.regular.anchors.top.[0])) - (.etatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.eta.regular.anchors.top.[0]) + 230)) - (((.etatonos.regular.anchors."top.mkmk".[0]) - (.eta.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.eta.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.eta.regular.anchors.top.[0]) + 230)) + (((.etatonos.regular.anchors."top.mkmk".[0]) - (.eta.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.etatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.eta.regular.anchors.bottom.[0]) + 230 - 141)
                },
                bold: {
                    "topaxis": .eta.bold.anchors.top.[0],
                    "diff": ((.etatonos.bold.anchors."top.mkmk".[0]) - (.eta.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.eta.bold.anchors.top.[0])) - (.etatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.eta.bold.anchors.top.[0]) + 200)) - (((.etatonos.bold.anchors."top.mkmk".[0]) - (.eta.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.eta.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.eta.bold.anchors.top.[0]) + 200)) + (((.etatonos.bold.anchors."top.mkmk".[0]) - (.eta.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.etatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.eta.bold.anchors.bottom.[0]) + 200 - 107)
                }
            }
        },
		iota: {
            base: .iota,
            basetonos: .iotatonos,
            basedialytika: .iotadialytika,
            coordinates: {
                regular: {
                    "topaxis": .iota.regular.anchors.top.[0],
                    "diff": ((.iotatonos.regular.anchors."top.mkmk".[0]) - (.iota.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.iota.regular.anchors.top.[0])) - (.iotatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.iota.regular.anchors.top.[0]) + 230)) - (((.iotatonos.regular.anchors."top.mkmk".[0]) - (.iota.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.iota.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.iota.regular.anchors.top.[0]) + 230)) + (((.iotatonos.regular.anchors."top.mkmk".[0]) - (.iota.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.iotatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.iota.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .iota.bold.anchors.top.[0],
                    "diff": ((.iotatonos.bold.anchors."top.mkmk".[0]) - (.iota.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.iota.bold.anchors.top.[0])) - (.iotatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.iota.bold.anchors.top.[0]) + 200)) - (((.iotatonos.bold.anchors."top.mkmk".[0]) - (.iota.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.iota.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.iota.bold.anchors.top.[0]) + 200)) + (((.iotatonos.bold.anchors."top.mkmk".[0]) - (.iota.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.iotatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.iota.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
		omicron: {
            base: .omicron,
            basetonos: .omicrontonos,
            coordinates: {
                regular: {
                    "topaxis": .omicron.regular.anchors.top.[0],
                    "diff": ((.omicrontonos.regular.anchors."top.mkmk".[0]) - (.omicron.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.omicron.regular.anchors.top.[0])) - (.omicrontonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.omicron.regular.anchors.top.[0]) + 230)) - (((.omicrontonos.regular.anchors."top.mkmk".[0]) - (.omicron.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.omicron.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.omicron.regular.anchors.top.[0]) + 230)) + (((.omicrontonos.regular.anchors."top.mkmk".[0]) - (.omicron.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.omicrontonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.omicron.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .omicron.bold.anchors.top.[0],
                    "diff": ((.omicrontonos.bold.anchors."top.mkmk".[0]) - (.omicron.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.omicron.bold.anchors.top.[0])) - (.omicrontonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.omicron.bold.anchors.top.[0]) + 200)) - (((.omicrontonos.bold.anchors."top.mkmk".[0]) - (.omicron.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.omicron.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.omicron.bold.anchors.top.[0]) + 200)) + (((.omicrontonos.bold.anchors."top.mkmk".[0]) - (.omicron.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.omicrontonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.omicron.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
		rho: {
            base: .rho,
            basetonos: {
                regular: {
                    anchors: {
                        "top.mkmk": [null, 699]
                    }
                },
                bold: {
                    anchors: {
                        "top.mkmk": [null, 704]
                    }
                }
            },
            coordinates: {
                regular: {
                    "topaxis": .rho.regular.anchors.top.[0],
                    "axisoffset": ((.rho.regular.anchors.top.[0]) + 230)
                },
                bold: {
                    "topaxis": .rho.bold.anchors.top.[0],
                    "axisoffset": ((.rho.bold.anchors.top.[0]) + 200)
                }
            }
        },
		upsilon: {
            base: .upsilon,
            basetonos: .upsilontonos,
            basedialytika: .upsilondialytika,
            coordinates: {
                regular: {
                    "topaxis": .upsilon.regular.anchors.top.[0],
                    "diff": ((.upsilontonos.regular.anchors."top.mkmk".[0]) - (.upsilon.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.upsilon.regular.anchors.top.[0])) - (.upsilontonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.upsilon.regular.anchors.top.[0]) + 230)) - (((.upsilontonos.regular.anchors."top.mkmk".[0]) - (.upsilon.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.upsilon.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.upsilon.regular.anchors.top.[0]) + 230)) + (((.upsilontonos.regular.anchors."top.mkmk".[0]) - (.upsilon.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.upsilontonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.upsilon.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .upsilon.bold.anchors.top.[0],
                    "diff": ((.upsilontonos.bold.anchors."top.mkmk".[0]) - (.upsilon.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.upsilon.bold.anchors.top.[0])) - (.upsilontonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.upsilon.bold.anchors.top.[0]) + 200)) - (((.upsilontonos.bold.anchors."top.mkmk".[0]) - (.upsilon.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.upsilon.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.upsilon.bold.anchors.top.[0]) + 200)) + (((.upsilontonos.bold.anchors."top.mkmk".[0]) - (.upsilon.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.upsilontonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.upsilon.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
		omega: {
            base: .omega,
            basetonos: .omegatonos,
            coordinates: {
                regular: {
                    "topaxis": .omega.regular.anchors.top.[0],
                    "diff": ((.omegatonos.regular.anchors."top.mkmk".[0]) - (.omega.regular.anchors.top.[0])),
                    "variaoffset": ((2 * (.omega.regular.anchors.top.[0])) - (.omegatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "breathvariaoffset": ((((.omega.regular.anchors.top.[0]) + 230)) - (((.omegatonos.regular.anchors."top.mkmk".[0]) - (.omega.regular.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.omega.regular.anchors.top.[0]) + 230),
                    "breathoxiaoffset": ((((.omega.regular.anchors.top.[0]) + 230)) + (((.omegatonos.regular.anchors."top.mkmk".[0]) - (.omega.regular.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.omegatonos.regular.anchors."top.mkmk".[0]) + 230),
                    "iotaoffset": ((.omega.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .omega.bold.anchors.top.[0],
                    "diff": ((.omegatonos.bold.anchors."top.mkmk".[0]) - (.omega.bold.anchors.top.[0])),
                    "variaoffset": ((2 * (.omega.bold.anchors.top.[0])) - (.omegatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "breathvariaoffset": ((((.omega.bold.anchors.top.[0]) + 200)) - (((.omegatonos.bold.anchors."top.mkmk".[0]) - (.omega.bold.anchors.top.[0])) / 2)) | round,
                    "axisoffset": ((.omega.bold.anchors.top.[0]) + 200),
                    "breathoxiaoffset": ((((.omega.bold.anchors.top.[0]) + 200)) + (((.omegatonos.bold.anchors."top.mkmk".[0]) - (.omega.bold.anchors.top.[0])) / 2)) | round,
                    "oxiaoffset": ((.omegatonos.bold.anchors."top.mkmk".[0]) + 200),
                    "iotaoffset": ((.omega.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Alpha: {
            base: .Alpha,
            basetonos: .Alphatonos,
            coordinates: {
                regular: {
                    "topaxis": .Alpha.regular.anchors.top.[0],
                    "axisoffset": ((.Alpha.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Alpha.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Alpha.bold.anchors.top.[0],
                    "axisoffset": ((.Alpha.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Alpha.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Epsilon: {
            base: .Epsilon,
            basetonos: .Epsilontonos,
            coordinates: {
                regular: {
                    "topaxis": .Epsilon.regular.anchors.top.[0],
                    "axisoffset": ((.Epsilon.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Epsilon.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Epsilon.bold.anchors.top.[0],
                    "axisoffset": ((.Epsilon.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Epsilon.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Eta: {
            base: .Eta,
            basetonos: .Etatonos,
            coordinates: {
                regular: {
                    "topaxis": .Eta.regular.anchors.top.[0],
                    "axisoffset": ((.Eta.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Eta.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Eta.bold.anchors.top.[0],
                    "axisoffset": ((.Eta.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Eta.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Iota: {
            base: .Iota,
            basetonos: .Iotatonos,
            coordinates: {
                regular: {
                    "topaxis": .Iota.regular.anchors.top.[0],
                    "axisoffset": ((.Iota.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Iota.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Iota.bold.anchors.top.[0],
                    "axisoffset": ((.Iota.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Iota.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Omicron: {
            base: .Omicron,
            basetonos: .Omicrontonos,
            coordinates: {
                regular: {
                    "topaxis": .Omicron.regular.anchors.top.[0],
                    "axisoffset": ((.Omicron.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Omicron.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Omicron.bold.anchors.top.[0],
                    "axisoffset": ((.Omicron.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Omicron.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Rho: {
            base: .Rho
        },
        Upsilon: {
            base: .Upsilon,
            basetonos: .Upsilontonos,
            coordinates: {
                regular: {
                    "topaxis": .Upsilon.regular.anchors.top.[0],
                    "axisoffset": ((.Upsilon.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Upsilon.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Upsilon.bold.anchors.top.[0],
                    "axisoffset": ((.Upsilon.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Upsilon.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        Omega: {
            base: .Omega,
            basetonos: .Omegatonos,
            coordinates: {
                regular: {
                    "topaxis": .Omega.regular.anchors.top.[0],
                    "axisoffset": ((.Omega.regular.anchors.top.[0]) + 230),
                    "iotaoffset": ((.Omega.regular.anchors.bottom.[0]) + 230)
                },
                bold: {
                    "topaxis": .Omega.bold.anchors.top.[0],
                    "axisoffset": ((.Omega.bold.anchors.top.[0]) + 200),
                    "iotaoffset": ((.Omega.bold.anchors.bottom.[0]) + 200)
                }
            }
        },
        tonos: .tonos
	}
' > ${2}
