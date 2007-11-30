package xinf.ony.erno;

import xinf.erno.Renderer;

class Use extends xinf.ony.base.Use {

    override public function drawContents( g:Renderer ) :Void {
		if( peer != null ) {
			// FIXME: in inity, reuse xid!
			#if neko
				g.showObject( peer.xid );
			#else true
				peer.draw(g);
			#end
		}
	}
	
}
