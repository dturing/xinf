/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import Xinf;
import xinf.ul.Component;
import xinf.ul.Container;

class Orientation {
    public function new();
    
    public function A(d:{x:Float,y:Float}):Float { throw("unimplemented"); return 0.; }
    public function B(d:{x:Float,y:Float}):Float { throw("unimplemented"); return 0.; }
    public function get(a:Float,b:Float):{x:Float,y:Float} { throw("unimplemented"); return null; }

    public function firstA(d:{l:Float,t:Float}):Float { throw("unimplemented"); return 0.; }
    public function firstB(d:{l:Float,t:Float}):Float { throw("unimplemented"); return 0.; }
    public function alignA(s:Component):Float { throw("unimplemented"); return 0.; }
    public function alignB(s:Component):Float { throw("unimplemented"); return 0.; }
}

class Vertical extends Orientation {
    override public function A(d:{x:Float,y:Float}):Float { return d.y; }
    override public function B(d:{x:Float,y:Float}):Float { return d.x; }
    override public function get(a:Float,b:Float):{x:Float,y:Float} { return({x:b,y:a}); }
    override public function firstA(d:{l:Float,t:Float}):Float { return d.t; }
    override public function firstB(d:{l:Float,t:Float}):Float { return d.l; }
    override public function alignA(s:Component):Float { return( s.verticalAlign ); }
    override public function alignB(s:Component):Float { return( s.horizontalAlign ); }
}

class Horizontal extends Orientation {
    override public function A(d:{x:Float,y:Float}):Float { return d.x; }
    override public function B(d:{x:Float,y:Float}):Float { return d.y; }
    override public function get(a:Float,b:Float):{x:Float,y:Float} { return({x:a,y:b}); }
    override public function firstA(d:{l:Float,t:Float}):Float { return d.l; }
    override public function firstB(d:{l:Float,t:Float}):Float { return d.t; }
    override public function alignA(s:Component):Float { return( s.horizontalAlign ); }
    override public function alignB(s:Component):Float { return( s.verticalAlign ); }
}



class FlowLayout implements Layout {
    public static var VERTICAL:Orientation = new Vertical();
    public static var HORIZONTAL:Orientation = new Horizontal();
    public static var Horizontal0:FlowLayout = new FlowLayout( FlowLayout.HORIZONTAL );
    public static var Vertical0:FlowLayout = new FlowLayout( FlowLayout.VERTICAL );
    public static var Horizontal5:FlowLayout = new FlowLayout( FlowLayout.HORIZONTAL, 5 );
    public static var Vertical5:FlowLayout = new FlowLayout( FlowLayout.VERTICAL, 5 );
    
    public var pad:Float; // FIXME: no way to trigger relayout...
    public var o:Orientation;
    
    public function new( ?o:Orientation, ?pad:Float ) :Void {
        if( pad==null ) pad=0;
        this.pad = pad;
        if( o==null ) o=VERTICAL;
        this.o = o;
    }
    
    public function layoutContainer( parent:Container ) {
        var first = o.firstA(parent.padding) + o.firstA(parent.border);
        var acc = first;
        var bPad = o.firstB(parent.padding) + o.firstB(parent.border);
        var max = 0.;
        var positions = new Array<{x:Float,y:Float}>();
        
        for( c in parent.getComponents() ) {
            positions.push( o.get( acc, bPad ) );
            
            var s = Helper.clampSize( c.prefSize, c );
			c.size = {x:s.x, y:s.y}; // somewhere else?
			acc += o.A(c.size) + pad;
            max = Math.max( o.B(c.size), max );
        }
        var total = acc-(first+pad);
    
        // parent alignment
        var s = Helper.removePadding(parent.size,parent);
        var ashift = ( o.A( s ) - total ) * o.alignA( parent );
        var bshift = ( o.B( s ) - max   ) * o.alignB( parent );
        for( c in parent.getComponents() ) {
            var p = positions.shift();
            var cshift = ( max - o.B( c.size ) ) * o.alignB( parent ); // FIXME, maybe, align by child alignment? (o.alignB(c))
            var q = o.get( o.A(p)+ashift, o.B(p)+bshift+cshift );
            c.position = { x:q.x, y:q.y };
        }

        parent.setPrefSize( o.get(total,max) );
    }
}
