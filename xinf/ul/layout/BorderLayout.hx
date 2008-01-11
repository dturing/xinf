/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import xinf.ul.Component;
import xinf.ul.Container;

enum Border {
    Center;
    North;
    East;
    South;
    West;
}

class BorderLayout extends ConstrainedLayout<Border>, implements Layout {
    var pad:Float;
    
    public function new( ?pad:Float ) :Void {
        super();
        if( pad==null ) pad=0;
        this.pad = pad;
    }
    
    public function layoutContainer( parent:Container ) {
        var N:Component;
        var E:Component;
        var S:Component;
        var W:Component;
        var C:Component;
        
        for( c in parent.getComponents() ) {
			var con = getConstraints( c );
			if( con!=null ) {
				switch( con ) {
					case North:
						N=c;
					case East:
						E=c;
					case South:
						S=c;
					case West:
						W=c;
					case Center:
						C=c;
					default:
				}
			}
        }

        var p = Helper.removePadding( parent.size, parent );
        var tl = Helper.innerTopLeft( parent );
        var n=tl.y;
        var w=tl.x;
        var s=0.;
        var e=0.;
        
        if( N!=null ) {
            var s = Helper.clampSize( {x:p.x, y:N.prefSize.y}, N );
            n += s.y;
            N.set_size( {x:s.x, y:s.y} );
            N.set_position( {x:tl.x, y:tl.y} );
        }
        if( S!=null ) {
            var sz = Helper.clampSize( {x:p.x, y:S.prefSize.y}, S );
            s = sz.y;
            S.set_size( {x:sz.x, y:sz.y} );
            S.set_position( {x:tl.x, y:(tl.y+p.y) - s} );
        }
        if( W!=null ) {
            var s = Helper.clampSize( {x:W.prefSize.x, y:(tl.y+p.y) - (n+s)}, W );
            w += s.x;
            W.set_size( {x:s.x, y:s.y} );
            W.set_position( {x:tl.x, y:n} );
        }
        if( E!=null ) {
            var s = Helper.clampSize( {x:E.prefSize.x, y:(tl.y+p.y) - (n+s)}, E );
            e = s.x;
            E.set_size( {x:s.x, y:s.y} );
            E.set_position( {x:(tl.x+p.x) - e, y:n} );
        }
        if( C!=null ) {
            C.set_position( {x:w, y:n} );
            C.set_size( {x:(tl.x+p.x) - (w+e), y:(tl.y+p.y) - (n+s)} );
        }
    }
}
