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
]
