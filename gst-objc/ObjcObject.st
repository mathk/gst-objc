Object subclass: ObjcObject [

    | objcPtr isClass |

    ObjcObject class >> fromPtr: aCObject [
	<category: 'private'>
	^(self new)
	    objcPtr: aCObject;
	    yourself
    ]

    ObjcObject class >> basicFromPtr: aCObject [
	<category: 'private'>
	^(self new)
	   basicObjcPtr: aCObject;
	    yourself
    ]

    privObjcClass [
	^ObjcRuntime objectGetClass: self objcPtr
    ]

    isObjc [
	^true
    ]

    isClass [
	^false
    ]

    send: selector with: arguments [
	self sendGNU: selector with: arguments
    ]

    sendApple: selector with: arguments [
	| objcSel return |
	objcSel := ObjcRuntime selRegisterName: selector.
	return := ObjcRuntime 
	    objcMsgSend: objcPtr 
	    selector: objcSel 
	    args: (arguments collect: [:each | each isObjc ifTrue: [each objcPtr] ifFalse: [each] ]).
	^return = objcPtr
            ifFalse: [self class basicFromPtr: return]
	    ifTrue: [self]
    ]

    sendGNU: selector with: arguments [
	| return bufferType buffer |
	bufferType := CArrayCType elementType: CLongType
	    numberOfElements: arguments size.
	buffer := bufferType gcNew.
	buffer address printNl.
	arguments doWithIndex: [ :each :i | 
	    each isObjc ifTrue: [buffer at: i - 1 put: each objcPtr] 
			ifFalse: [
			   " each isInteger ifTrue: [buffer at: i put: each type: CIntType valueType]
					   ifFalse: ["buffer at: i - 1 put: each "type: CLongType valueType]"
			]
	].
	return := ObjcRuntime objcGNUMsgSendClass: nil
	    receiver: self objcPtr
	    sel: selector
	    argc: arguments size
	    argv: buffer.
	^return = objcPtr
            ifFalse: [self class basicFromPtr: return]
	    ifTrue: [self]
    ]

    intSend: selector with: arguments [
	| objcSel |
	objcSel := ObjcRuntime selRegisterName: selector.
	^ObjcRuntime 
	    intObjcMsgSend: objcPtr 
	    selector: objcSel 
	    args: (arguments collect: [:each | each isObjc ifTrue: [each objcPtr] ifFalse: [each] ]).
    ]

    send: selector [
	^self send: selector with: #()
    ]

    basicObjcPtr: aCObject [
	objcPtr := aCObject
    ]

    objcPtr: aCObject [
	<category: 'ptivate'>
	ObjcRuntime retain: aCObject.
	self basicObjcPtr: aCObject
    ]
    
    objcPtr [
	^objcPtr
    ]


    finalize [
       ObjcRuntime release: objcPtr
    ]

    
    log [
	ObjcRuntime logObject: objcPtr
    ]
]

Object extend [
    isObjc [
	^false
    ]
]

String extend [
    primAsNSString [
	<cCall: 'toNSString' returnning: #cObject args: #( #self )>
    ]

    asNSString [
	^Objc.ObjcObject basicFromPtr: self primAsNSString
    ]
]
