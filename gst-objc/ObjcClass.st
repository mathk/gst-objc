ObjcObject subclass: ObjcClass [
    | stClass |

    ObjcClass class >> initialize [
	ObjcRuntime objcGetClassList do: [:each | 
	    | className |
	    className := ObjcRuntime classGetName: each.
	    Namespace current 
		    at: className asSymbol 
		    put: (self fromPtr: each)
	]
    ]
    
    isClass [
	^true
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
]

Eval [
    ObjcClass initialize
]
