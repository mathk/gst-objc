Object subclass: ObjcRuntime [


    ObjcRuntime class >> at: aClassName [
	| nsClass |
	nsClass := self objcGetClass: aClassName.
	^ObjcObject classFromPtr: nsClass
    ]

    ObjcRuntime class >> objcGetClass: name [
	<cCall: 'objc_getClass' returning: #cObject args: #( #string )>
    ]
    
    ObjcRuntime class >> classCreateInstance: aClass size: anInt [
	<cCall: 'class_createInstance' returning: #cObject args: #( #cObject #int)>
    ]
    
    ObjcRuntime class >> selRegisterName: name [
	<cCall: 'sel_registerName' returning: #cObject args: #( #string )>
    ]
    
    ObjcRuntime class >> primObjcGetClassList: buffer size: length [
	<cCall: 'objc_getClassList' returning: #int args: #(#cObject #int)>
    ]

    ObjcRuntime class >> classGetName: aClass [
	<cCall: 'class_getName' returning: #string args: #( #cObject )>
    ]

    ObjcRuntime class >> objcMsgSend: receiver selector: sel args: args [
	<cCall: 'objc_msgSend' returning: #cObject args: #( #cObject #cObject #variadic )>
    ]

    ObjcRuntime class >> intObjcMsgSend: receiver selector: sel args: args [
	<cCall: 'objc_msgSend' returning: #int args: #( #cObject #cObject #variadic )>
    ]

    ObjcRuntime class >> retain: receiver [
	<cCall: 'CFRetain' returning: #cObject args: #( #cObject )>
    ]

    ObjcRuntime class >> release: receiver [
	<cCall: 'CFRelease' returning: #void args: #( #cObject )>
    ]

    ObjcRuntime class >> log: object [
	<cCall: 'NSLog' returning: #void args: #( #cObject )>
    ]

    ObjcRuntime class >> primObjcAllocateClassPair: aClassName super: aSuperName indexable: aInt [
	<cCall: 'objc_allocateClassPair' returning: #cObject args: #( #cObject #string #int )>
    ]

    ObjcRuntime class >> objcAllocateClassPair: aClassName super: aSuperName indexable: aInt [
	^self primObjcAllocateClassPair: (self at: aClassName) objcPtr super: aSuperName indexable: aInt
    ]

    ObjcRuntime class >> objcGetClassList [
	| bufferType classes buffer |
	bufferType := CArrayCType elementType: (CObjectType ptrType) 
				  numberOfElements: self objcGetClassCount.
	buffer := bufferType gcNew.
	self primObjcGetClassList: buffer size: bufferType numberOfElements.
	classes := OrderedCollection new.
	0 to: bufferType numberOfElements - 1 do: [ :index |
	    classes add: (buffer at: index)
	].
	^classes
    ]

    ObjcRuntime class >> objcGetClassCount [
	^self primObjcGetClassList: nil size: 0
    ]

]
