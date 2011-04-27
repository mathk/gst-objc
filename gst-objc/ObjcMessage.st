Object subclass: ObjcMessage [
    | selector receiver returnHolder  |
    
    ObjcMessage class [
	| unboxRoutine |
    ]

    ObjcMessage class >> receiver: ptr selector: sel [
	^(self new)
	    receiver: ptr;
	    selector: sel;
	    yourself
    ]

    ObjcMessage class >> initialize [
	unboxRoutine := Dictionary new.
	unboxRoutine at: $@ put: [:array | ObjcObject fromPtr: (CObject address: (array longAt: 1))].
	unboxRoutine at: $^ put: [:array | CObject address: (array longAt: 1)].
	unboxRoutine at: $# put: [:array | ObjcClass fromPtr: (CObject address: (array longAt: 1))].

	"unboxRoutine at: '(' put: [todo]."
	"unboxRoutine at: '{' put: [todo]."

	unboxRoutine at: $c put: [:array | (array charAt: 1) value].
	unboxRoutine at: $C put: [:array | (array ucharAt: 1) value].
	unboxRoutine at: $s put: [:array | (array shortAt: 1) value].
	unboxRoutine at: $S put: [:array | (array ushortAt: 1) value].
	unboxRoutine at: $i put: [:array | (array intAt: 1) value].
	unboxRoutine at: $I put: [:array | (array uintAt: 1) value].
	unboxRoutine at: $l put: [:array | (array longAt: 1) value].
	unboxRoutine at: $L put: [:array | (array ulongAt: 1) value].
	unboxRoutine at: $q put: [:array | 
	    Memeory bigEndian 
                       ifTrue: [ ((array intAt: 1) value * 16r100000000) bitOr: (array uintAt: 5) value ]
	               ifFalse:[ ((array intAt: 5) value * 16r100000000) bitOr: (array uintAt: 1) value ]].
	unboxRoutine at: $Q put: [:array |
	    Memeory bigEndian
                       ifTrue: [ ((array uintAt: 1) value * 16r100000000) + (array uintAt: 5) value ]
	               ifFalse:[ ((array uintAt: 5) value * 16r100000000) + (array uintAt: 1) value ]].

	unboxRoutine at: $f put: [:array | (array floatAt: 1) value].
	unboxRoutine at: $d put: [:array | (array doubleAt: 1) value].
	unboxRoutine at: $B put: [:array | (array uintAt: 1) value = 1].
	unboxRoutine at: $: put: [:array | ObjcRuntime selGetName: (CObject address: (array longAt: 1))].
	unboxRoutine at: $v put: [:array | nil ].
    ]

    ObjcMessage class >> unboxRoutine [
	^unboxRoutine
    ]

    unboxRoutine [
	^self class unboxRoutine
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
	| routine |
	routine := self unboxRoutine 
	    at: (self returnType at: 1) 
	    ifAbsent: [self error: 'unsuported unboxing type ',self returnType ].
	^routine cull: returnHolder cull: self returnType
    ]

    returnSize [
	^self primReturnSize: receiver sel: selector
    ]

    returnType [
	^self primReturnType: receiver sel: selector
    ]

    primReturnSize: receiver sel: selector [
	<cCall: 'objc_sendReturnSize' returning: #int args: #( #cObject #cObject )>
    ]

    primReturnType: receiver sel: selector [
	<cCall: 'objc_sendReturnType' returning: #string args: #( #cObject #cObject )>
    ]
	
]


Eval [
    ObjcMessage initialize
]
