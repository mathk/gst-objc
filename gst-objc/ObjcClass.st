ObjcObject subclass: ObjcClass [
    | stClass |

    ObjcClass class >> fromPtr: aCObject [
	<category: 'private - construct'>
	^(self new)
	    objcPtr: aCObject;
	    yourself
    ]

    ObjcClass class >> initialize [
	ObjcRuntime objcGetClassList do: [:each | 
	    | className |
	    className := ObjcRuntime classGetName: each.
	    Namespace current 
		    at: className asSymbol 
		    put: (self fromPtr: each).
	    Namespace current at: #YES put: (Character value: 1).
	    Namespace current at: #NO put: (Character value: 0)
	]
    ]
    
    isClass [
	^true
    ]

    superclass [
	^self class fromPtr: (ObjcRuntime classGetSuperclass: self objcPtr)
    ]
    
    stClass [
	^stClass ifNil: [ObjcObject] ifNotNil: [stClass]
    ]

    stClass: aClass [
	stClass := aClass
    ]

    finalize [
    ]

    alloc [
	^self stClass fromPtr: (ObjcRuntime classCreateInstance: objcPtr size: 0).

    ]

    addIvar: name type: type [
	ObjcRuntime classAddIvar: self name: name type: type
    ]

    register [
	ObjcRuntime objcRegisterClassPair: self
    ]

    addMutator: string type: aType [
	ObjcRuntime objcAddGetter: string selector: string inClass: self type: aType.
	ObjcRuntime objcAddSetter: string selector: string, ':' inClass: self type: aType.
    ]

    addStObjectMutator [
	ObjcRuntime objcAddSetter: 'stObject' selector: 'stObject:' inClass: self type: CObjcId.
	ObjcRuntime objcAddStObjectGetter: self.
	
    ]

    
]

Eval [
    ObjcClass initialize
]
