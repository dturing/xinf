/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */

package xinf.ony.type;

/**
	Defines a list of String values.
	
	Used mainly for the fontFamily property of
	SVG Text.
	
	FIXME: maybe drop this, and just use Array<String>?
*/
class StringList {
    public var list:Array<String>;
    
    public function new( l:Array<String> ) {
        list=l;
    }
    
    public function toString() {
        return list.join(", ");
    }
}
