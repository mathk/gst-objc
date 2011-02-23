Object subclass: ObjcRuntime [


    ObjcRuntime class >> at: aClassName [
	| nsClass |
	nsClass := self objcGetClass: aClassName.
	^ObjcClass fromPtr: nsClass
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

    ObjcRuntime class >> primObjcAllocateClassPairSuper: aSuperClass name: aName indexable: aInt [
	<cCall: 'objc_allocateClassPair' returning: #cObject args: #( #cObject #string #int )>
    ]

    ObjcRuntime class >> primObjcRegisterClassPair: aClass [
	<cCall: 'objc_registerClassPair' returning: #void args: #( #cObject)>
    ]

    ObjcRuntime class >> objcRegisterClassPair: aClass [
	self primObjcRegisterClassPair: aClass objcPtr
    ]

    ObjcRuntime class >> objcAllocateClassPairSuper: aSuperName name: aName indexable: aInt [
	^ObjcClass fromPtr: (self primObjcAllocateClassPairSuper: (self at: aSuperName) objcPtr name: aName indexable: aInt)
    ]

    ObjcRuntime class >> primClassAddMethod: class sel: selector body: ccallback type: typeStr [
	<cCall: 'class_addMethod' returning: #void args: #( #cObject #cObject #cObject #string )>
    ]
	
    ObjcRuntime class >> classAddMethod: class sel: selector body: block type: typeStr [
	self primClassAddMethod: class objcPtr 
	     sel: (self selRegisterName: selector)
	     body: (CCallbackDescriptor for: [:objcSelf :cmd :arg1 | block value: (ObjcObject fromPtr: objcSelf) value: arg1] 
					returning: #void 
					withArgs: #(#cObject #cObject #cObject))
	    type: typeStr
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
