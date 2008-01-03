/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.ony.Implementation;
import xinf.erno.Renderer;
import xinf.erno.Runtime;

class Use extends xinf.ony.Use {
	var clone:ElementImpl;
	var wrapper:Null<Int>;
	var cycleLock:Bool;

	override function set_peer(v:ElementImpl) :ElementImpl {
		clone = cast(v.cloneNode(true));
		clone.parentElement = this;
		clone.styleChanged();
		clone.construct();
		wrapper = Runtime.runtime.getNextId();
		return super.set_peer(v);
	}

	override public function cloneNode( deep:Bool ) :xinf.xml.Node {
		if( cycleLock==true ) {
			throw("Cycle in Use reference: "+href );
		}
		var n = super.cloneNode(deep);
		return n;
	}

	override public function onLoad() :Void {
		cycleLock = true;
		super.onLoad();
		if( clone!=null ) clone.onLoad();
		cycleLock = false;
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
