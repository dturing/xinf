/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */

package xinf.type;

class StringList {
    public var list:Array<String>;
    
    public function new( l:Array<String> ) {
        list=l;
    }
    
    public function toString() {
        return list.join(", ");
    }
}
