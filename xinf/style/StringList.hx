
package xinf.style;

class StringList {
    public var list:Array<String>;
    
    public function new( l:Array<String> ) {
        list=l;
    }
    
    public function toString() {
        return list.join(", ");
    }
}
