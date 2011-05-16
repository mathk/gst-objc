CScalar subclass: CCGFloat [
    
    CCGFloat class >> basicCObject [
	^self sizeof = CFloat sizeof 
            ifTrue: [CFloat]
	    ifFalse: [CDouble]
    ]

    CCGFloat class >> type [
	^self basicCObject type
    ]
    
    CCGFloat class >> sizeof [
	<cCall: 'objc_sizeofCGFloat' returning: #int args: #()>
    ]

    CCGFloat class >> cObjStoredType [
	^self basicCObject cObjStoredType
    ]
    
    CCGFloat class >> alignof [
	^self basicCObject alignof
    ]

    type [
	^self basicCObject type
    ]

    basicCObject [
	^self sizeof = CFloat sizeof 
            ifTrue: [CFloat]
	    ifFalse: [CDouble]
    ]

    sizeof [
	<cCall: 'objc_sizeofCGFloat' returning: #int args: #()>
    ]

    cObjStoredType [
	^self basicCObject cObjStoredType
    ]

    alignof [
	^self basicCObject alignof
    ]
]

CObject subclass: CObjcId [
    CObjcId class >> objcTypeStr [ ^'@']
    objcTypeStr [ ^'@']
]

CObject subclass: CVoid [
    CVoid class >> objcTypeStr [ ^'v']
    objcTypeStr [ ^'v']
]

CObject subclass: CObjcSel [
    CObjcSel class >> objcTypeStr [ ^':']
    objcTypeStr [ ^':']
]

CStruct subclass: NSSize [
    <declaration: #((#width #{CCGFloat}) (#height #{CCGFloat}))>

    NSSize class >> gcWidth: width height: height [
	| return |
	return := self gcNew.
	return width value: width.
	return height value: height.
	^return
    ]
]

CStruct subclass: NSPoint [
    <declaration: #((#x #{CCGFloat}) (#y #{CCGFloat}))>

    NSPoint class >> gcX: xValue y: yValue [
	| return |
	return := self gcNew.
	return x value: xValue.
	return y value: yValue.
	^return
    ]
]

CStruct subclass: NSRect [
    <declaration: #((#origin #{NSPoint})(#size #{NSSize}))>

    NSRect class >> gcOriginX: x y: y width: width height: height [
	| return |
	return := self gcNew.
	return origin x value: x.
	return origin y value: y.
	return size width value: width.
	return size height value: height.
	^return
    ]
    
]

CStruct subclass: NSRange [
    <declaration: #((#location #uLong)(#length #uLong))>
    NSRange class >> gcLocation: location length: length [
	| return |
	return := self gcNew.
	return location value: location.
	return length value: length.
	^return
    ]
]


CFloat extend [
    CFloat class >> objcTypeStr [^'f']
    objcTypeStr [^'f']
]

CDouble extend [
    CDouble class >> objcTypeStr [^'d']
    objcTypeStr [^'d']
]

CInt extend [
    CInt class >> objcTypeStr [^'i']
    objcTypeStr [^'i']
]

CUInt extend [
    CUInt class >> objcTypeStr [^'I']
    objcTypeStr [^'I']
]

CLong extend [
    CLong class >> objcTypeStr [^'l']
    objcTypeStr [^'l']
]

CULong extend [
    CULong class >> objcTypeStr [^'L']
    objcTypeStr [^'L']
]

CChar extend [
    CChar class >> objcTypeStr [^'c']
    objcTypeStr [^'c']
]

CUChar extend [
    CUChar class >> objcTypeStr [^'C']
    objcTypeStr [^'C']
]

CShort extend [
    CShort class >> objcTypeStr [^'s']
    objcTypeStr [^'s']
]

CUShort extend [
    CUShort class >> objcTypeStr [^'S']
    objcTypeStr [^'S']
]

CBoolean extend [
    CBoolean class >> objcTypeStr [^'B']
    objcTypeStr [^'B']
]

CObject subclass: COOP [
    COOP class >> objcTypeStr [
	^'^{oop_s=ll}'
    ]

    COOP class >> sizeof [
	^CPtr sizeof
    ]

    COOP class >> alignof [
	^CPtr alignof
    ]

    sizeof [
	^CPtr sizeof
    ]

    alignof [
	^CPtr alignof
    ]

    objcTypeStr [
	^'^{oop_s=ll}'
    ]
]
