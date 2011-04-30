ObjcObject subclass: ObjcClass [
    | stClass |
    ObjcClass class >> fromPtr: aCObject [
	<category: 'private'>
	^self basicFromPtr: aCObject
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

    noRetainAlloc [
	^self stClass basicFromPtr: (ObjcRuntime classCreateInstance: objcPtr size: 0).
    ]

    addIvar: name type: type [
	ObjcRuntime classAddIvar: self name: name type: type
    ]

    register [
	ObjcRuntime objcRegisterClassPair: self
    ]
]
