
Object subclass: ObjcApplication [
    | nsApp delay |

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
	nsApp := NSApplication sharedApplication.
	delay := Delay untilMilliseconds: 20.
    ]

    pollEvent [
	| event pool |
	pool := NSAutoreleasePool alloc init.
	event := nsApp nextEventMatchingMask: self class defaultNSAnyEventMask 
	      untilDate: NSDate distantFuture 
	      inMode: 'NSDefaultRunLoopMode' 
	      dequeue: YES.
	[nsApp sendEvent: event] forkAt: Processor userSchedulingPriority.
	delay wait.
	pool drain.
	^true
    ]

    run [
	[[self pollEvent] whileTrue] forkAt: Processor highIOPriority
    ]
]
