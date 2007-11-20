package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.SimpleEventDispatcher;

class Group extends xinf.ony.Group {
    
    override public function destroy() :Void {
		// destroy all children
		for( child in children ) {
			detach( child );
			untyped child.destroy(); // FIXME
		}
		super.destroy();
    }

    override public function attach( child:xinf.ony.Element, ?after:xinf.ony.Element ) :Void {
		super.attach( child, after );
		scheduleRedraw();
    }
	
    override public function detach( child:xinf.ony.Element ) :Void {
		super.detach( child );
        scheduleRedraw();
    }

	
    override public function drawContents( g:Renderer ) :Void {
        super.drawContents(g);
        
        // draw children
        for( child in children ) {
            g.showObject( child.xid );
        }
    }

}
