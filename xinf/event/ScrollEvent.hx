/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
    
**/
class ScrollEvent extends Event<ScrollEvent> {
    
    static public var SCROLL_STEP = new EventKind<ScrollEvent>("scrollStep");
    static public var SCROLL_LEAP = new EventKind<ScrollEvent>("scrollLeap");
    static public var SCROLL_TO   = new EventKind<ScrollEvent>("scrollTo");

    public var value:Float; // delta (+-1.0) or absolute (0..1) - depending on the kind
    public var targetId:Null<Int>;
    
    public function new( _type:EventKind<ScrollEvent>, value:Float, ?targetId:Int ) {
        super(_type);
        this.value = value;
        this.targetId = targetId;
    }
    
    override public function toString() :String {
        var r = ""+type+"("+value+")";
        if( targetId != null ) r+="to #"+targetId;
        return r;
    }
}
