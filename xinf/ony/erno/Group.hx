/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.SimpleEventDispatcher;
import xinf.xml.Node;
import xinf.ony.type.Display;

class Group extends xinf.ony.Group {
    
    override function destroy() :Void {
		// destroy all children
		/* FIXME maybe yes? 
		for( child in mChildren ) {
			removeChild( child );
			if( Std.is(child,Element) ) 
				cast(child).destroy();
		}
		*/
		super.destroy();
    }

	override public function appendChild( newChild:Node ) :Node {
		if( newChild.parentElement != null ) {
			trace("child "+newChild+" is already attached to a parent ("+newChild.parentElement+", new "+this+")");
			newChild.parentElement.removeChild(newChild);
		}
		if( Std.is(newChild,Element) )
			cast(newChild).construct();
			
		return super.appendChild( newChild );
    }

    override public function removeChild( oldChild:Node ) :Node {
		if( Std.is(oldChild,Element) ) 
			cast(oldChild).destroy();
		return super.removeChild( oldChild );
    }

    override public function draw( g:Renderer ) :Void {
		// a group renders its children even if its "visibility:hidden",
		// but children inherit that property. they might override, though.
		if( xid==null ) throw("no xid: "+this);
        g.startObject( xid );
			if( display != Display.None )
				drawContents(g);
        g.endObject();
        reTransform(g); // FIXME: needed
    }

    override public function drawContents( g:Renderer ) :Void {
        // super.drawContents(g);
        
        // draw children
        for( child in mChildren ) {
			if( untyped child.xid != null ) {
				g.showObject( untyped child.xid );
			}
        }
    }

}
