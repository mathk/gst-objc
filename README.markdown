Getting gst-objc
================

(If you have a better name idea feel free to give me suggestions.)

You can fetch the source from [github](https://github.com/mathk/gst-objc):

    $ git clone git://github.com/mathk/gst-objc.git

Then you have to build it.

    $ autoreconf -vi
    $ ./configure
    $ make
    $ [sudo] make install

Depending on you platform you may need gnustep.  You can find all the
instruction to build gnustep
[here](http://wiki.gnustep.org/index.php/GNUstep_SVN_Installation_Guide)

Here you should be able to load Objc package:

    GNU Smalltalk ready

    st> PackageLoader fileInPackage: 'Objc'
    Loading package Objc
    2011-05-01 22:17:52.971 gst[91826:903] Load complete
    PackageLoader
    st> 


First window
============

Now that you can load `Objc`, I will show you how to create an `NSWindow`.
For convenience I will drop every thing in a file `myFirstWindow.st`.

    "First load the package"
    Eval [
      PackageLoader fileInPackage: 'Objc'.
    ]

After that we need to create an `NSApplication` that will handle the main event
loop.

    nsApplication := Objc.ObjcRuntime at: 'NSApplication'.
    nsApp := nsApplication sharedApplication.

As you can see, when sending `#sharedApplication` to the object, you are in fact
forwarding the message to Objective-C.

We can then create our first `NSWindows`:

    nsRect := Objc.NSRect gcOriginX: 0.0
                                  y: 0.0
                              width: 100.0
                             height: 100.0.

    nsWindow := Objc.ObjcRuntime at: 'NSWindow'.
    nsWindow := nsWindow alloc.
    nsWindow initWithContentRect: nsRect styleMask: 15 backing:Objc.ObjcAppKit nsBackingStoreBuffered defer: (Character value:1).
    nsWindow setTitle: 'Test windows' asNSString.

`nsRect` is just a CStruct that tell which size the window is going to have.
`#initWithContentRect:styleMask:backing:defer:` and `#setTitle:` are again
forwarded to Objective-C. You have to be careful to chose the right type when
passing argument to Ojective-C. For instance the last parameter is of type 'c'
in Objective-C which is a Character.

`#asNSString` is a helper to convert from Smalltalk string to Objective-C string,
like `@"Testing window"`.

After that we have to create a `NSView`.  The way `NSWindow` handles the drawing
is by calling `#drawRect:` on a view.  So we have to subclass `NSView` and
implement the `#drawRect:` method.

The way to do this is by using class and method pragma.

    Objc.ObjcObject subclass: MyNSView [
      <objcSubclass: 'NSView'>

      drawRect: rect [
            "if you are running on gnustep you have to use:
             v@:{_NSRect={_NSPoint=dd}{_NSSize=dd}}
            and use f or d depending on you arch 32 or 64bit.
            This need to be improve.
            "
        <objcTypeStr:'v@:{CGRect={CGPoint=dd}{CGSize=dd}}'>
        | nsColor |
        nsColor := Objc.ObjcRuntime at: 'NSColor'.
        nsColor redColor set.
        Objc.ObjcAppKit nsRectFill: self bounds
      ]
    ]

The pragma `objcSubclass:` tells what is the super class. In other words
`MyNSView` is a subclass of `NSView`.

The pragma `objcTypeStr:`  tells the type of the Objective-C method.  You can
found out more
[here](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html).

The `#drawRect:` method is pretty simple. It just fills the window in red.

Now we can use this newly created class:

    "Create a new view but don't retain it. Instead autorelease it."
    view := MyNSView noRetainAlloc.
    view init.
    view autorelease.

    nsWindow setContentView: view.
    nsWindow center.
    nsWindow orderFront: 0.
    nsWindow contentView.
    nsApp run.


At this point you should see a small window fill of red.
That is it for this tutorial.

I hope you  enjoy it. Feel free to ask questions or comments.

Last I would like to thanks Paolo Bonzini and David Chisnall for theirs help
and advice.

Complete code:

    Eval [
      PackageLoader fileInPackage: 'Objc'.
    ]

    Objc.ObjcObject subclass: MyNSView [
      <objcSubclass: 'NSView'>

      drawRect: rect [
        <objcTypeStr:'v@:{CGRect={CGPoint=dd}{CGSize=dd}}'>
        | nsColor |
        nsColor := Objc.ObjcRuntime at: 'NSColor'.
        nsColor redColor set.
        Objc.ObjcAppKit nsRectFill: self bounds
      ]
    ]

    Eval [
      | view nsInstance nsApplication nsApp nsWindow |

      nsApplication := Objc.ObjcRuntime at: 'NSApplication'.
      nsApp := nsApplication sharedApplication.
      nsRect :=  Objc.NSRect gcOriginX: 0.0
                                     y: 0.0
                                 width: 100.0
                                height: 100.0.

      nsWindow :=  Objc.ObjcRuntime at: 'NSWindow'.
      nsWindow := nsWindow alloc.
      nsWindow initWithContentRect: nsRect 
                         styleMask: 15
                           backing: Objc.ObjcAppKit nsBackingStoreBuffered 
                             defer: (Character value:1).

      nsWindow setTitle: 'Test windows' asNSString.

      view := MyNSView noRetainAlloc.
      view init.
      view autorelease.

      nsWindow setContentView: view.
      nsWindow center.
      nsWindow orderFront: 0.
      nsWindow contentView.
      nsApp run.
    ]

