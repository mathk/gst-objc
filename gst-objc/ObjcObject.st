Object subclass: ObjcObject [

    | objcPtr |

    ObjcObject class [
	| objcClass objcSelectors |
	
    ]

    ObjcObject class >> initialize [
	
    ]

    ObjcObject class >> className [
	self subclassResponsibility
    ]

    ObjcObject class >> alloc [
	"This is the default allocator for Objective-C object"
	<category: 'instance-creation'>
	^self fromPtr: (ObjcRuntime classCreateInstance: objcClass)
    ]

    ObjcObject class >> allocAndInit [
	<category: 'instance-creation'>
	^self alloc init; yourself
    ]

    ObjcObject class >> fromPtr: aCObject [
	<category: 'private'>
	^(self new)
	    objcPtr: aCObject;
	    yourself
    ]

    objcPtr: aCObject [
	<category: 'ptivate'>
	objcPtr := aCObject.
    ]


   finalize [

   ]
]
