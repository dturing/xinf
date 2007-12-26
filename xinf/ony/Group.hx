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

/*
	public function getElementByName( name:String ) :ElementImpl {
		for( child in children ) {
			if( child.name == name ) return child;
		}
		throw( "no child with name '"+name+"'" );
	}
	
	public function getTypedElementByName<T>( name:String, cl:Class<T> ) :T {
		var r = getElementByName( name );
		if( !Std.is( r, cl ) ) throw("ElementImpl '"+name+"' is not of class "+Type.getClassName(cl)+" (but instead "+Type.getClassName(Type.getClass(r))+")" );
        return cast(r);
	}
*/	
}
