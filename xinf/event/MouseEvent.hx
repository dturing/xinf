/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
    
**/
class MouseEvent extends Event<MouseEvent> {
    
	// FIXME: review the bubbling... do a cancel state that prevents bubble?
    static public var MOUSE_DOWN = new EventKind<MouseEvent>("mouseDown",true);
    static public var MOUSE_UP   = new EventKind<MouseEvent>("mouseUp");
    static public var MOUSE_MOVE = new EventKind<MouseEvent>("mouseMove");
    static public var MOUSE_OVER = new EventKind<MouseEvent>("mouseOver",true);
    static public var MOUSE_OUT  = new EventKind<MouseEvent>("mouseOut",true);

    public var x:Float;
    public var y:Float;
    public var button:Int;
    public var targetId:Null<Int>;
    
    public var shiftMod:Bool;
    public var altMod:Bool;
    public var ctrlMod:Bool;
    
    public function new( _type:EventKind<MouseEvent>, _x:Int, _y:Int, ?_button:Int, ?targetId:Int, ?shiftMod:Bool, ?altMod:Bool, ?ctrlMod:Bool ) {
        super(_type);
        x=_x; y=_y; button=_button;
        this.targetId = targetId;
        this.shiftMod = if( shiftMod==null ) false else shiftMod;
        this.altMod = if( altMod==null ) false else altMod;
        this.ctrlMod = if( ctrlMod==null ) false else ctrlMod;
    }
    
    override public function toString() :String {
        var r = ""+type+"("+x+","+y+", ";
        if( shiftMod ) r+="Shift+";
        if( altMod ) r+="Alt+";
        if( ctrlMod ) r+="Ctrl+";
        r+="Button "+button+")";
        if( targetId != 0 ) r+=" to #"+targetId;
        return r;
    }
    
}
