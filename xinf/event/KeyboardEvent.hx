/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

class KeyboardEvent extends Event<KeyboardEvent> {
    
    static public var KEY_DOWN = new EventKind<KeyboardEvent>("keyDown");
    static public var KEY_UP   = new EventKind<KeyboardEvent>("keyUp");

    public var code:Int;
    public var key:String;
    public var shiftMod:Bool;
    public var altMod:Bool;
    public var ctrlMod:Bool;
    
    public function new( _type:EventKind<KeyboardEvent>, 
            code:Int, key:String, ?shiftMod:Bool, ?altMod:Bool, ?ctrlMod:Bool ) {
        super(_type);
        this.code=code; this.key=key;
        this.shiftMod = if( shiftMod==null ) false else shiftMod;
        this.altMod = if( altMod==null ) false else altMod;
        this.ctrlMod = if( ctrlMod==null ) false else ctrlMod;
    }

    override public function toString() :String {
        // FIXME #if debug
        var r = ""+type+"(";
        if( shiftMod ) r+="Shift-";
        if( altMod ) r+="Alt-";
        if( ctrlMod ) r+="Ctrl-";
        if( key==null ) r+="[null]";
        else if( key.length==1 ) r+="'"+key+"'";
        else r+=key;
        r+=")";
        return r;
    }
    
}
