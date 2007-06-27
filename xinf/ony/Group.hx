
package xinf.ony;

interface Group implements Element {

    function attach( o:Element, ?after:Element ) :Void;
    function detach( o:Element ) :Void;
    
    var children(get_children,null) :Iterator<Element>;
    
}
