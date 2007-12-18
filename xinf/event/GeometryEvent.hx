/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
    GeometryEvent is used to propagate information about changes
    in position or size of some Element.
**/
class GeometryEvent extends Event<GeometryEvent> {
    
    static public var STAGE_SCALED     = new EventKind<GeometryEvent>("stageScaled");
    static public var SIZE_CHANGED     = new EventKind<GeometryEvent>("sizeChanged");
    
    public var x:Float; // x coordinate of position or width
    public var y:Float; // y coordinate of position or height
    
    public function new( _type:EventKind<GeometryEvent>, _x:Float, _y:Float ) {
        super(_type);
        x=_x; y=_y;
    }

    override public function toString() :String {
        return( ""+type+"("+x+","+y+")" );
    }
    
}