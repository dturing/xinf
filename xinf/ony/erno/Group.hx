/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.SimpleEventDispatcher;

class Group extends xinf.ony.base.Group {
    
    override public function destroy() :Void {
		// destroy all children
		for( child in mChildren ) {
			removeChild( child );
			untyped child.destroy(); // FIXME
		}
		super.destroy();
    }
	
    override public function drawContents( g:Renderer ) :Void {
        // super.drawContents(g);
        
        // draw children
        for( child in mChildren ) {
			if( untyped child.xid != null ) 
				g.showObject( untyped child.xid );
        }
    }

}
