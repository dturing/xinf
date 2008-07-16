/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package xinf.ony.type;

/**
	Defines a list of Float values.
	
	Used mainly (only?) for the keyTimes property of Animations
*/
class FloatList {
	public var list:Array<Float>;
	
	public function new( l:Array<Float> ) {
		list=l;
	}
	
	public function toString() {
		if( list==null ) return "";
		return list.join(",");
	}
}
