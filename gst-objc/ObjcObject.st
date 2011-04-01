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
	| return |
	return = ObjcRuntime objcGNUMsgSendClass: self privObjcClass
	    receiver: self objcPtr
	    sel: ObjcRuntime selRegisterName: selector
	    argc: arguments size
	    argv: (arguments collect: [:each | each isObjc ifTrue: [each objcPtr] ifFalse: [each] ]).
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
    asNSString [
	| nsString string |
	nsString := Objc.ObjcRuntime at: 'NSString'.
	string := nsString send: #stringWithCString: with: {self asCData: CStringType}.
	^string
    ]
]
