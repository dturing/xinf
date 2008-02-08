/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.xml.Node;

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

}
