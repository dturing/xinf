/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import xinf.ul.Container;

class GridLayout extends SpringLayout {
    public var cols:Int;
	public var xPad:Float;
	public var yPad:Float;
    public var compact:Bool;
    var springsDone:Bool;
    
    public function new( ?cols:Int, ?xpad:Float, ?ypad:Float, ?compact:Bool ) :Void {
        super();
        springsDone=false;
        this.cols = if( cols==null ) 1 else cols;
        this.compact = if( compact==null ) false else compact;
		xPad = if( xpad!=null ) xpad else 0;
		yPad = if( ypad!=null ) ypad else xPad;
    }
    
    override public function layoutContainer( p:Container ) {
        if( !springsDone ) {
            var count = p.getComponents().length;
			var rows = Math.ceil( count/cols );
            if( compact ) {
                trace("MakeCompactGrid "+cols+"x"+rows+" pad "+xPad+"/"+yPad );
                SpringUtilities.makeCompactGrid(
                    p, this, cols, rows, xPad, yPad );
            } else {
                trace("MakeGrid "+cols+"x"+rows+" pad "+xPad+"/"+yPad );
                SpringUtilities.makeGrid(
                    p, this, cols, rows, xPad, yPad );
            }
            springsDone=true;
        }
        super.layoutContainer(p);
    }
}