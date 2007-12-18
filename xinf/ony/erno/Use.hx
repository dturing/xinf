/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;

class Use extends xinf.ony.base.Use {

    override public function drawContents( g:Renderer ) :Void {
		if( peer != null ) {
			#if neko
				g.showObject( peer.xid );
			#else true
				peer.drawContents(g);
			#end
		}
	}
	
}
