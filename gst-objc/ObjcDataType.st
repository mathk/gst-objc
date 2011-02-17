Object subclass: ObjcDataType [

    ObjcDataType class [

	nsMakeRectX: orgX y: orgY w: width h: height [
	    <cCall: 'nsMakeRect' returning: #cObject args: #( #double #double #double #double )>
	]

    ]

]
