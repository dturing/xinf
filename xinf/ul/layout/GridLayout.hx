/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import xinf.ul.Container;

class GridLayout extends SpringLayout {
    public var cols:Int;
    public var compact:Bool;
    var springsDone:Bool;
    
    public function new( ?cols:Int, ?compact:Bool ) :Void {
        super();
        springsDone=false;
        cols = if( cols==null ) 1 else cols;
        compact = if( compact==null ) false else compact;
    }
    
    public function layoutContainer( p:Container ) {
        if( !springsDone ) {
            var count = p.children.length;
            var rows = Math.ceil( count/cols );
            if( compact ) {
                trace("MakeCompactGrid "+cols+"x"+rows );
                SpringUtilities.makeCompactGrid(
                    p, this, cols, rows, 1, 1 ); // FIXME pad
            } else {
                trace("MakeGrid "+cols+"x"+rows );
                SpringUtilities.makeGrid(
                    p, this, cols, rows, 3, 3 ); // FIXME pad
            }
            springsDone=true;
        }
        super.layoutContainer(p);
    }
}