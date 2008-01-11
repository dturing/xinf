/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */

package xinf.ony.type;

/**
	Defines a list of Int values.
	
	Used mainly for the stroke-dasharray property.
*/
class IntList {
    public var list:Array<Int>;
    
    public function new( l:Array<Int> ) {
        list=l;
    }
    
    public function toString() {
		if( list==null ) return "";
        return list.join(",");
    }
}
