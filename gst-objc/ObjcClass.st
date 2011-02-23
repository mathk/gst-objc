ObjcObject subclass: ObjcClass [
    
    ObjcObject class >> fromPtr: aCObject [
	<category: 'private'>
	^self basicFromPtr: aCObject
    ]

    
    isClass [
	^true
    ]

    finalize [
    ]

    alloc [
	^ObjcObject fromPtr: (ObjcRuntime classCreateInstance: objcPtr size: 0).

    ]

    noRetainAlloc [
	^ObjcObject basicFromPtr: (ObjcRuntime classCreateInstance: objcPtr size: 0).
    ]
]
