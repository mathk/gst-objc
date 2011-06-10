Object subclass: ObjcObject [

    | objcPtr isClass owned |

    ObjcCache := WeakValueLookupTable new.

    ObjcObject class [
	| objcClass |
    ]

    ObjcObject class >> typeMap [
	<category: 'private - accessing'>
	^##(| dict |
	    dict := LookupTable new.
	    dict at: #id put: CObjcId.
	    dict at: #sel put: CObjcSel.
	    dict at: #CGFloat put: CCGFloat.
	    dict at: #ulong put: CULong.
	    dict at: #uLong put: CULong.
	    dict at: #uint put: CUInt.
	    dict at: #uInt put: CUInt.
	    dict at: #uchar put: CUChar.
	    dict at: #uChar put: CUChar.
	    dict at: #ushort put: CUShort.
	    dict at: #uShort put: CUShort.
	    dict at: #long put: CLong.
	    dict at: #short put: CShort.
	    dict at: #int put: CInt.
	    dict at: #char put: CChar.
	    dict at: #void put: CVoid.
	    dict at: #oop put: CObjcId.
	    dict
	    )
    ]

		
    ObjcObject class >> fromPtr: aCObject [
	<category: 'private - construct'>
	^ObjcCache at: aCObject ifAbsentPut: [
	    (self new)
		objcPtr: aCObject;
		yourself
	]
    ]

    ObjcObject class >> objcSubclass: aString [
	self objcSubclass: aString iVars: #()    
    ]

    ObjcObject class >> objcSubclass: aString iVars: array [
	objcClass := ObjcRuntime objcAllocateClassPairSuper: aString name: self name indexable: 0.
	objcClass stClass: self.
	objcClass addIvar: 'stObject' type: (self typeMap at: #oop).
	objcClass addStObjectMutator.
	array do: [:each |
	    each size < 2 ifTrue: [self error: 'You must declare the name and the type of the instance variable'].
	    objcClass addIvar: each first type: (self typeMap at: each second).
	    objcClass addMutator: each first type: (self typeMap at: each second).
	].
	objcClass register.
	self registerHandler: [:method :message | 
	    self addObjcMethod: method selector type: message argument.
	    nil] forPragma: #objcTypeStr:.
	self registerHandler: [:method :message |
	    self addObjcMethod: method selector.
	    nil] forPragma: #objc.
	self registerHandler: [:method :message |
	    self addObjcMethod: method selector typeBuildWith: message arguments.
	    nil] forPragma: #objcReturning:args:
    ]

    ObjcObject class >> alloc [
	^self objcClass alloc.
    ]
    
    ObjcObject class >> objcSuperclass [
	self objcClass superclass
    ]

    ObjcObject class >> objcClass [
	objcClass ifNil: [self error: 'You must use ObjcClass or a subclass to instanciate a NSObject'].
	^objcClass
    ]

    ObjcObject class >> addObjcMethod: selector type: typeStr [
	self primAddObjcMethod: selector in: objcClass objcPtr type: typeStr
    ]

    ObjcObject class >> addObjcMethod: selector typeBuildWith: args [
	| typeStr |
	typeStr := self buildObjcTypeStrReturning: args first args: args second.
	self primAddObjcMethod: selector in: objcClass objcPtr type: typeStr
    ]

    ObjcObject class >> buildObjcTypeStrReturning: returning args: args [
	| typeList |
	typeList := OrderedCollection new.
	typeList add: (self typeMap at: returning) objcTypeStr.
	typeList add: (self typeMap at: #id) objcTypeStr.
	typeList add: (self typeMap at: #sel) objcTypeStr.
	args do: [:each |
	    typeList add: (self typeMap at: each) objcTypeStr.
	].
	^typeList join
    ]

    ObjcObject class >> addObjcMethod: selector [
	self primAddObjcMethod: selector in: objcClass objcPtr type: nil
    ]

    ObjcObject class >> primAddObjcMethod: selector in: class type: typeStr [
	<cCall: 'objc_addMethod' returning: #void args: #(#symbol #cObject #string)>
    ]

    ObjcObject class >> addSelector: sel withMethod: cm [
	super addSelector: sel withMethod: cm
    ]

    doesNotUnderstand: aMessage [
	(self respondsTo: aMessage selector) ifTrue: [
	    ^self superSend: aMessage selector with: aMessage arguments
	].
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
    
    superSend: selector with: arguments [
	| message |
	message := ObjcMessage receiver: self objcPtr selector: (ObjcRuntime selGetUid: selector) super: self objcClass superclass objcPtr.
	^message performSuperWith: arguments
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

    objcPtr: aCObject [
	<category: 'ptivate'>
	objcPtr := aCObject
    ]
    
    objcPtr [
	^objcPtr
    ]

    objcClass [
	^self class objcClass
    ]

    
    log [
	ObjcRuntime logObject: objcPtr
    ]

    finalize [
	self objcPtr release
    ]
]

Object extend [
    isObjc [
	^false
    ]
]
