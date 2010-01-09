/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.event.SimpleEventDispatcher;
import xinf.xml.Node;
import xinf.ony.type.Display;

class Group extends xinf.ony.Group {
	
	public function new( ?traits:Dynamic ) :Void {
		super(traits);
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
			try {
				if( untyped child.xid != null ) {
					g.showObject( untyped child.xid );
				}
			} catch(e:Dynamic) {}
		}
	}

}
