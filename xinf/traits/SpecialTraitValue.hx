/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.traits;

import xinf.xml.XMLElement;

class SpecialTraitValue {
	
	public function new() {
	}
	
	public function get( name:String, type:Dynamic, c:XMLElement ) :Dynamic {
		return null;
	}
}

class Inherit extends SpecialTraitValue {
	public static var inherit:Inherit = new Inherit();
	
	override public function get( name:String, type:Dynamic, c:XMLElement ) :Dynamic {
		var p = c.parentElement;
		if( p==null ) return null;
		return( p.getStyleTrait(name,type,true) );
	}
	
	public function toString() {
		return("inherit");
	}
}

class CurrentColor extends SpecialTraitValue {
	public static var currentColor:CurrentColor = new CurrentColor();
	
	override public function get( name:String, type:Dynamic, c:XMLElement ) :Dynamic {
		var p = c; //.parentElement;
		while( p!=null ) {
			var v = p.getStyleTrait("color",type,true);
			if( v!=null ) return v;
			p=p.parentElement;
		}
		return null;
	}
	
	public function toString() {
		return("currentColor");
	}
}
