CStruct subclass: ObjcType [
    <declaration: #((#value #long))>
]

Object subclass: ObjcRuntime [

    ObjcRuntime class [
	at: aClassName [
	    | nsClass |
	    nsClass := self objcGetClass: aClassName.
	    ^ObjcClass fromPtr: nsClass
	]

	objcGetClass: name [
	    <category: 'class'>
	    <cCall: 'objc_getClass' returning: #cObject args: #( #string )>
	]

	objectGetClass: id [
	    <category: 'instance'>
	    <cCall:'object_getClass' returning: #cObject args: #( #cObject )>
	]
    
	classCreateInstance: aClass size: anInt [
	    <category: 'class'>
	    ^self primCreateInstance: aClass size: anInt zone: 0
	]

        primCreateInstance: aClass size: anInt zone: default [
	    <category: 'private class'>
	    <cCall: 'NSAllocateObject'  returning: #cObject args: #( #cObject #int #int)>
	]
    
	selRegisterName: name [
	    <category: 'runtime query'>
	    <cCall: 'sel_registerName' returning: #cObject args: #( #string )>
	]
    
	primObjcGetClassList: buffer size: length [
	    <category: 'runtime query'>
	    <cCall: 'objc_getClassList' returning: #int args: #(#cObject #int)>
	]

	classGetName: aClass [
	    <category: 'class'>
	    <cCall: 'class_getName' returning: #string args: #( #cObject )>
	]

	objcMsgSend: receiver sel: selector argc: aInt argv: args super: class [
	    <category: 'instance'>
	    <cCall: 'objc_sendMsg' returning: #{ObjcType} args: #( #cObject #cObject #uint #smalltalk #cObject )>
	]
	
	retain: receiver [
	    <category: 'instance'>
	    <cCall: 'objc_retain' returning: #void args: #( #cObject )>
	]

	release: receiver [
	    <category: 'instance'>
	    <cCall: 'objc_release' returning: #void args: #( #cObject )>
	]

	log: nsString [
	    <category: 'instance'>
	    <cCall: 'NSLog' returning: #void args: #( #cObject )>
	]

	log: nsString with: arg [
	    <category: 'instance'>
	    <cCall: 'NSLog' returning: #void args: #( #cObject #cObject )>
	]

	logObject: object [
	    <category: 'instance'>
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
