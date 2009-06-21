/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.xml.Node;
import xinf.geom.Types;

class Group extends ElementImpl {

	static var tagName = "g";

	override public function appendChild( newChild:Node ) :Node {
		redraw();
		return super.appendChild( newChild );
	}

	// TODO: insertChild

	override public function removeChild( oldChild:Node ) :Node {
		redraw();
		return super.removeChild( oldChild );
	}

	override public function getBoundingBox() : TRectangle {
		var bbox:xinf.geom.Rectangle = null;
		for( child in mChildren ) {
			if( untyped child.xid != null ) {
				if( bbox==null ) {
					bbox = new xinf.geom.Rectangle( untyped child.getBoundingBox() );
				} else {
					bbox.merge( untyped child.getBoundingBox() );
				}
			}
		}
		if( bbox==null ) return({l:0.,t:0.,r:0.,b:0.});
		return bbox;
	}

}
