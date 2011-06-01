Object subclass: ObjcApplication [

    | nsApp |

    ObjcApplication class [
	| uniqueInstance |
    ]

    ObjcApplication class >> uniqueInstance [
	^uniqueInstance ifNil: [uniqueInstance := self new initialize; yourself]
    ]

    ObjcApplication class >> defaultNSAnyEventMask [
	^16rFFFFFFF
    ]

    initialize [
	nsApp := NSApplication sharedApplication
    ]

    pollEvent [
	| event |
	event := nsApp nextEventMatchingMask: self class defaultNSAnyEventMask 
	      untilDate: NSDate distantFuture 
	      inMode: 'NSDefaultRunLoopMode' 
	      dequeue: YES.
	[nsApp sendEvent: event] forkAt: Processor userSchedulingPriority
    ]
]
