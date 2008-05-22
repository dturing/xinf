/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim;

import xinf.xml.XMLElement;
import xinf.traits.StringTrait;

import xinf.ony.Path;

class MPath extends XMLElement {
	
	static var TRAITS = {
		href:new StringTrait(),
	}

	public var href(get_href,set_href):String;
	function get_href() :String { return getTrait("href",String); }
	function set_href( v:String ) :String { setTrait("href",v); return v; }

	public function getPath() :Path {
		if( href==null ) return null;

		// for now, we dont support external references FIXME
		var id = href.split("#")[1];
		var peer = ownerDocument.getTypedElementById( id, Path );
		return peer;
	}
	
}
