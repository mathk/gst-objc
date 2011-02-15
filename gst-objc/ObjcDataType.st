Object subclass: ObjcDataType [

    ObjcDataType class [

	nsMakeRectX: orgX y: orgY w: width h: height [
	    <cCall: 'NSMakeRect' returning: #cObject args: #( #float #float #float #float )>
	]

    ]

]
