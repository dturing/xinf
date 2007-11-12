
package xinf.ony;

interface Crop implements Group {

    var width(default,set_width):Float;
    var height(default,set_height):Float;

    function attach( o:Element, ?after:Element ) :Void;
    function detach( o:Element ) :Void;
    
    var children(get_children,null) :Iterator<Element>;
    
	function getChildByName( name:String ) :Element;
	function getTypedChildByName<T>( name:String, cl:Class<T> ) :T;
}