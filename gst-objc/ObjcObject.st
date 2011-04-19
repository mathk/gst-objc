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

    doesNotUnderstand: aMessage [
	^self send: aMessage selector with: aMessage argument
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

    prepareArgument: array into: recipient [
	<cCall: 'objc_prepareArguments' returning: #cObject args: #(#smalltalk #smalltalk)>
    ]

    sendGNU: selector with: arguments [
	| return "bufferType buffer" |
	"bufferType := CArrayCType elementType: CLongType
	    numberOfElements: arguments size.
	buffer := bufferType new.
	buffer address printNl.
	arguments doWithIndex: [ :each :i | 
	    each isObjc ifTrue: [buffer at: i - 1 put: each objcPtr address  type: CObjectType valueType] 
			ifFalse: [
			   each isInteger ifTrue: [buffer at: i-1 put: each type: CIntType valueType]
					   ifFalse: [buffer at: i - 1 put: each type: CLongType valueType]
			]
	]."
	return := ObjcRuntime objcMsgSendClass: nil
	    receiver: self objcPtr
	    sel: selector
	    argc: arguments size
	    argv: arguments.
"	buffer free."
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
	<category: 'Objc'>
	<cCall: 'objc_toNSString' returning: #cObject args: #( #self )>
    ]

    asNSString [
	<category: 'Objc'>
	^Objc.ObjcObject basicFromPtr: self primAsNSString
    ]
]
