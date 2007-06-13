
package xinf.ony;

interface Group implements Element {

    function attach( o:Element, ?after:Element ) :Void;
    function detach( o:Element ) :Void;
    
    function children() :Iterator<Element>;
    
}
