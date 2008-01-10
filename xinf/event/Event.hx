/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/** 
    Base class for all events.
    The type argument (T) has to be set to a child class of Event.
**/

class Event<T> {
    
    public var type(default,null) : EventKind<T>;
    public var origin:haxe.PosInfos; // FIXME if debug_events
	public var preventBubble:Bool;
    
    public function new( t ) {
        type = t;
		preventBubble = false;
    }
    
    public function toString() :String {
        // FIXME #if debug
        var r = ""+type;
        if( origin != null ) r+=", from "+origin.fileName+":"+origin.lineNumber;
        r+=" { ";
        for( field in Reflect.fields(this) ) {
            if( field != "origin" )
                r+=field+":"+Reflect.field(this,field)+", ";
        }
        r+="}";
        
        return r;
    }
    
}
