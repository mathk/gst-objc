Object subclass: ObjcMessage [
    | selector receiver returnHolder  |
    
    ObjcMessage class >> receiver: ptr selector: sel [
	^(self new)
	    receiver: ptr;
	    selector: sel;
	    yourself
    ]
    
    receiver: ptr [
	receiver := ptr
    ]

    selector: sel [
	selector := sel
    ]

    perform [
	^self performWith: #()
    ]

    performWith: args [
	returnHolder := ByteArray new: self returnSize.
	ObjcRuntime objcMsgSend: receiver
	    sel: selector
	    argc: args size
	    argv: args
	    super: nil
	    returning: returnHolder. 
	^self boxReturn
    ]

    boxReturn [
	self returnType printNl.
	^returnHolder
    ]

    returnSize [
	^self primReturnSize: receiver sel: selector
    ]

    returnType [
	^self primReturnType: receiver sel: selector
    ]

    primReturnSize: receiver sel: selector [
	<cCall: 'objc_sendReturnLength' returning: #int args: #( #cObject #cObject )>
    ]

    primReturnType: receiver sel: selector [
	<cCall: 'objc_sendReturnType' returning: #string args: #( #cObject #cObject )>
    ]
	
]
