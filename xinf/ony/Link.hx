/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;
import xinf.ony.Implementation;

import xinf.traits.StringTrait;
import xinf.event.UIEvent;
import xinf.event.LinkEvent;

class Link extends GroupImpl {

	static var tagName = "a";
	
	static var TRAITS = {
		href:new StringTrait(),
	};

    public var href(get_href,set_href):String;
    function get_href() :String { return getTrait("href",String); }
    function set_href( v:String ) :String { setTrait("href",v); return v; }

	public function new( ?traits:Dynamic ) {
		super(traits);
		addEventListener( UIEvent.ACTIVATE, onActivate );
	}
	
	public function onActivate( e:UIEvent ) {
		postEvent( new LinkEvent( LinkEvent.ACTUATE, href ));
	}
}
