/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.ony.base.Implementation;
import xinf.erno.Renderer;
import xinf.erno.Runtime;

class Use extends xinf.ony.base.Use {
	var clone:ElementImpl;
	var wrapper:Int;

	override function set_peer(v:ElementImpl) :ElementImpl {
		clone = cast(v.cloneNode(true));
		clone.parentElement = this;
		clone.styleChanged();
		return super.set_peer(v);
	}

	override public function cloneNode( deep:Bool ) :xinf.xml.Node {
		var n = super.cloneNode(deep);
		var u:Use = cast(n);
		u.set_peer(peer);
		return n;
	}

	override function construct() :Void {
		if( clone!=null ) {
			clone.construct();
			wrapper = Runtime.runtime.getNextId();
		}
		super.construct();
	}
	
    override public function draw( g:Renderer ) :Void {
		if( clone!=null ) {
			clone.draw(g);
			g.setTransform( wrapper, x, y, 1, 0, 0, 1 );
			g.startObject( wrapper );
				g.showObject( clone.xid );
			g.endObject();
		}
		super.draw(g);
	}
	
    override public function drawContents( g:Renderer ) :Void {
		if( wrapper!=null ) {
			g.showObject(wrapper);
		}
		
	/*	if( peer != null ) {
			#if neko
				g.showObject( peer.xid );
			#else true
				peer.drawContents(g);
			#end
		} */
	}
	
}
