/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

import xinf.event.SimpleEventDispatcher;

class Selection<T:ISelectable> extends SimpleEventDispatcher {
    var selected:Array<T>;
    var maxSelected:Int;
    
    public function new( ?maxSelected:Int ) :Void {
        super();
        
        if( maxSelected==null ) maxSelected==0;
        this.maxSelected = maxSelected;
        selected = new Array<T>();
    }
    
    public function select( item:T, isSelected:Bool ) {
        if( isSelected ) {
            while( selected.length >= this.maxSelected ) selected.pop().setSelected(false);
            selected.push( item );
            item.setSelected(true);
        } else {
            selected.remove( item );
            item.setSelected(false);
        }
    }
    
    public function clear() {
        for( item in selected ) item.setSelected(false);
        selected = new Array<T>();
    }
}
