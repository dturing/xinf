/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

class Selectable<T> implements ISelectable {

    public var selected(default,setSelected):Bool;
    public var item:T;
    
    public function new( item:T ) :Void {
        this.item = item;
        this.selected=false;
    }
    
    public function setSelected( sel:Bool ) :Bool {
        selected=sel;
        return sel;
    }
    
    public function toString() :String {
        return( ""+item );
    }

}
