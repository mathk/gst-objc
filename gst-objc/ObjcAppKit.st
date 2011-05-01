Object subclass: ObjcAppKit [
    
    ObjcAppKit class [

	maskNSBordelessWindow [ ^0 ]
	maskNSTitledWindow [ ^1 ]
	maskNSClosableWindow [ ^2 ]
	maskNSMiniaturizableWindow [ ^4 ]
	maskNSResizableWindow [ ^8 ]
	maskNSTexturedBackgroundWindow [ ^16 ]
	maskNSAllWindow [ ^31 ]
	nsBackingStoreRetained [ ^0 ]
	nsBackingStoreNonretained [ ^1 ]
	nsBackingStoreBuffered [ ^2 ]
	nsRectFill: aRect [
	    <cCall: 'gstRectFill' returning: #void args: #( #{NSRect} )>
	]
    ]
]
