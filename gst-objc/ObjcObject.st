Object subclass: ObjcObject [

    | objcPtr isClass |

    ObjcObject class [
	| objcClass |
    ]
		
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

    ObjcObject class >> objcSubclass: aString [
	objcClass := ObjcRuntime objcAllocateClassPairSuper: aString name: self name indexable: 0.
	objcClass stClass: self.
	objcClass addIvar: 'stObject' type: CPtr.
	objcClass register.
	self registerHandler: [:method :message | 
	    self addObjcMethod: method selector type: message argument.
	    'Method register' printNl.
	    nil] forPragma: #objcTypeStr:
	    
    ]

    ObjcObject class >> alloc [
	objcClass ifNil: [self error: 'You must use ObjcClass or a subclass to instanciate a NSObject'].
	^objcClass alloc
    ]

    ObjcObject class >> noRetainAlloc [
	objcClass ifNil: [self error: 'You must use ObjcClass or a subclass to instanciate a NSObject'].
	^objcClass noRetainAlloc
    ]


    ObjcObject class >> addObjcMethod: selector type: typeStr [
	self primAddObjcMethod: selector in: objcClass objcPtr type: typeStr
    ]

    ObjcObject class >> primAddObjcMethod: selector in: class type: typeStr [
	<cCall: 'objc_addMethod' returning: #void args: #(#symbol #cObject #string)>
    ]

    ObjcObject class >> addSelector: sel withMethod: cm [
	super addSelector: sel withMethod: cm
    ]

    doesNotUnderstand: aMessage [
	^self send: aMessage selector with: aMessage arguments
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
	| message |
	message := ObjcMessage receiver: self objcPtr selector: (ObjcRuntime selGetUid: selector).
	^message performWith: arguments
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
