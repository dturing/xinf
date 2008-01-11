/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.erno;

import xinf.erno.Renderer;

/**
    A Pen structure keeps the style with which to draw graphic objects
    for a $xinf.erno.PenRenderer$. There should
    be no need to use this structure, except if you implement
    your own Renderer that derives from PenRenderer.
**/
class Pen {
    /**
        current fill color, may be [null].
    **/
    public var fill :Paint;
    
	public var stroke:Paint;
	public var width:Float;
	public var caps:Int;
	public var join:Int;
	public var miterLimit:Float;
	public var dashArray:Array<Int>;
	public var dashOffset:Int;

    /**
        constructor, initializes a new Pen structure with default values.
    **/
    public function new() :Void {
    }
    
    /**
        return a new Pen structure with the same properties as this Pen.
    **/
    public function clone() :Pen {
        var p = new Pen();
        
		p.fill = fill;
        
		p.stroke = stroke;
		p.width = width;
		p.caps = caps;
		p.join = join;
		p.miterLimit = miterLimit;
		p.dashArray = dashArray;
		p.dashOffset = dashOffset;
		
        return p;
    }
}


/**
    A PenRenderer implements the <i>style part</i> of the 
    $xinf.erno.Renderer$ interface ([setFill] and [setStroke]),
    maintaining a <a href="Pen.html">Pen</a> structure.

	Renderers deriving from this can access the current Pen from the [pen] member variable.
    </p>
**/
// FIXME: does this actually have to be a stack? i dont think so...
class PenRenderer extends BasicRenderer {
    
    private var pen:Pen;

    public function new() :Void {
        super();
        pen = new Pen();
    }
    
    override public function setFill( ?paint:Paint ) :Void {
		pen.fill = paint;
    }
    
    override public function setStroke( ?paint:Paint, width:Float, ?caps:Int, ?join:Int, ?miterLimit:Float, ?dashArray:Array<Int>, ?dashOffset:Int ) :Void {
		pen.stroke = paint;
		pen.width = width;
		pen.caps = caps;
		pen.join = join;
		pen.miterLimit = miterLimit;
		pen.dashArray = dashArray;
		pen.dashOffset = dashOffset;
    }
        
}
