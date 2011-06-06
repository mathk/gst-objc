
Object subclass: ObjcApplication [
    | nsApp delay delayDisp loop event dispLoop |

    ObjcApplication class [
	| uniqueInstance |
    ]

    ObjcApplication class >> uniqueInstance [
	^uniqueInstance ifNil: [uniqueInstance := self new initialize; yourself]
    ]

    ObjcApplication class >> defaultNSAnyEventMask [
	^16rFFFFFFFF
    ]

    initialize [
	nsApp := NSApplication sharedApplication.
	delay := Delay forMilliseconds: 20.
	delayDisp := Delay forMilliseconds: 20
    ]

    loadNibNamed: aName [
	nsApp inspect.
	NSBundle loadNibNamed: aName owner: nsApp.
    ]

    dispatchLoop [
	event ifNotNil: [
	    | pool |
	    pool := NSAutoreleasePool alloc init.
	    nsApp sendEvent: event.
	    pool drain.
	    event := nil.
	].
	(Delay forMilliseconds: 20) wait.
	^nsApp isRunning = YES
    ]

    pollEvent [
	| evt |
	"event ifNotNil: [(Delay forMilliseconds: 20) wait. ^nsApp isRunning = YES]."
	evt := nsApp nextEventMatchingMask: self class defaultNSAnyEventMask 
	      untilDate: nil 
	      inMode: 'NSDefaultRunLoopMode' 
	      dequeue: YES.
	evt ifNotNil: [
	    [nsApp sendEvent: evt] forkAt: Processor userSchedulingPriority.
	].
	(Delay forMilliseconds: 20) wait.
	^nsApp isRunning = YES
    ]

    run [
	|pool|
	nsApp setRunning.
	nsApp setLaunched.
	pool := NSAutoreleasePool alloc init.
	nsApp finishLaunching.
	pool drain.
	"dispLoop := [[self dispatchLoop] whileTrue] forkAt: Processor userSchedulingPriority."
	loop := [[self pollEvent] whileTrue] forkAt: Processor highIOPriority.
	[(Delay forSeconds: 10000) wait] whileTrue
    ]
]
