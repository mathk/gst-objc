Object subclass: ObjcRuntime [

    ObjcRuntime class [
	at: aClassName [
	    | nsClass |
	    nsClass := self objcGetClass: aClassName.
	    ^ObjcClass fromPtr: nsClass
	]

	objcGetClass: name [
	    <cCall: 'objc_getClass' returning: #cObject args: #( #string )>
	]

	objectGetClass: id [
	    <cCall:'object_getClass' returning: #cObject args: #( #cObject )>
	]
    
	classCreateInstance: aClass size: anInt [
	    <cCall: 'class_createInstance' returning: #cObject args: #( #cObject #int)>
	]
    
	selRegisterName: name [
	    <cCall: 'sel_registerName' returning: #cObject args: #( #string )>
	]
    
	primObjcGetClassList: buffer size: length [
	    <cCall: 'objc_getClassList' returning: #int args: #(#cObject #int)>
	]

	classGetName: aClass [
	    <cCall: 'class_getName' returning: #string args: #( #cObject )>
	]
    
	objcMsgSend: receiver selector: sel args: args [
	    <cCall: 'objc_msgSend' returning: #cObject args: #( #cObject #cObject #variadic )>
	]

	objcGNUMsgSendClass: class receiver: receiver sel: selector argc: aInt argv: args [
	    <cCall: 'sendMsg' returning: #cObject args: #( #cObject #cObject #cObject #uint #variadic )>
	]

	intObjcMsgSend: receiver selector: sel args: args [
	    <cCall: 'objc_msgSend' returning: #int args: #( #cObject #cObject #variadic )>
	]

	retain: receiver [
	    <cCall: 'CFRetain' returning: #cObject args: #( #cObject )>
	]

	release: receiver [
	    <cCall: 'CFRelease' returning: #void args: #( #cObject )>
	]

	log: nsString [
	    <cCall: 'NSLog' returning: #void args: #( #cObject )>
	]

	log: nsString with: arg [
	    <cCall: 'NSLog' returning: #void args: #( #cObject #cObject )>
	]

	logObject: object [
	    self log: '%@' asNSString objcPtr with: object
	]

	primObjcAllocateClassPairSuper: aSuperClass name: aName indexable: aInt [
	    <cCall: 'objc_allocateClassPair' returning: #cObject args: #( #cObject #string #int )>
	]

	primObjcRegisterClassPair: aClass [
	    <cCall: 'objc_registerClassPair' returning: #void args: #( #cObject)>
	]

	objcRegisterClassPair: aClass [
	    self primObjcRegisterClassPair: aClass objcPtr
	]

	objcAllocateClassPairSuper: aSuperName name: aName indexable: aInt [
	    ^ObjcClass fromPtr: (self primObjcAllocateClassPairSuper: (self at: aSuperName) objcPtr name: aName indexable: aInt)
	]

	primClassAddMethod: class sel: selector body: ccallback type: typeStr [
	    <cCall: 'class_addMethod' returning: #void args: #( #cObject #cObject #cObject #string )>
	]
	
	classAddMethod: class sel: selector body: block type: typeStr [
	    self primClassAddMethod: class objcPtr 
		 sel: (self selRegisterName: selector)
		 body: (CCallbackDescriptor for: [:objcSelf :cmd :arg1 | block value: (ObjcObject fromPtr: objcSelf) value: arg1] 
					    returning: #void 
					    withArgs: #(#cObject #cObject #cObject))
		                            type: typeStr
	]

	objcGetClassList [
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
    
	objcGetClassCount [
	    ^self primObjcGetClassList: nil size: 0
	]
]

]
