Object subclass: ObjcObject [

    | objcPtr isClass |

    ObjcObject class >> fromPtr: aCObject [
	<category: 'private'>
	^(self new)
	    objcPtr: aCObject;
	    isClass: false;
	    yourself
    ]

    ObjcObject class >> classFromPtr: aObjcClass [
	^(self new)
	    basicObjcPtr: aObjcClass;
	    isClass: true;
	    yourself
    ]

    isObjc [
	^true
    ]

    isClass: aBool [
	isClass := aBool
    ]

    isClass [
	^isClass
    ]

    send: selector with: arguments [
	| objcSel return |
	objcSel := ObjcRuntime selRegisterName: selector.
	return := ObjcRuntime 
	    objcMsgSend: objcPtr 
	    selector: objcSel 
	    args: (arguments collect: [:each | each isObjc ifTrue: [each objcPtr] ifFalse: [each] ]).
	^return = objcSel 
            ifFalse: [self class fromPtr: return]
	    ifTrue: [self]
    ]

    send: selector [
	self send: selector with: #()
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

    alloc [
	self isClass ifTrue: [^self class fromPtr: (ObjcRuntime classCreateInstance: objcPtr size: 0)].
	self error: 'Non objc class can''t send alloc'
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
	string := nsString alloc.
	string send: #initWithUTF8String: with: {self asCData: CStringType}.
	^string
    ]
]
