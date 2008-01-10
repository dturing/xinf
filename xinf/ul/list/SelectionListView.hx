/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import xinf.ul.model.ISelectable;
import xinf.ul.model.ISettable;
import xinf.ul.model.Selection;
import xinf.ul.model.ListModel;

class SelectionListView<T:ISelectable> extends ListView<T> {

    var lastPickedIndex:Int;
    var selection:Selection<T>;
    
    public function new( model:ListModel<T>, ?maxSelected:Int, ?createItem:Void->ISettable<T> ) :Void {
        if( createItem==null ) {
            createItem = function() :ISettable<T> {
                return new SelectableListItem<T>();
            }
        }
        
        super( model, createItem );
		
        selection = new Selection<T>( maxSelected );
        lastPickedIndex=0;
        addEventListener( untyped PickEvent.ITEM_PICKED, onPick );
    }
    
    public function onPick( e:PickEvent<T> ) {
        trace( ""+e );
        var item = model.getItemAt( e.index );
        if( item==null ) return;
        /*
        if( item.selected ) {
            selection.select( item, false );
            rr.redoAll();
            return;
        }
        */
        if( e.addModifier ) {
            lastPickedIndex = e.index;
            trace("select "+( if( item.selected ) "-" else "+" )+" "+e.index );
            selection.select( item, !item.selected );
        } else if( e.extendModifier ) {
            selection.clear();
            var a=lastPickedIndex;
            var b=e.index;
            if( a>b ) { b=a; a=e.index; }
            trace("SEL "+a+" - "+b );
            for( i in a...b+1 ) {
                var item = model.getItemAt( i );
                if( !item.selected )
                    selection.select( item, true );
              }
//            trace("select "+lastPickedIndex+" to "+e.index );
        } else {
            trace("select = "+e.index+" -- "+item );
            selection.clear();
            selection.select( item, true );
            lastPickedIndex = e.index;
        }
        rr.redoAll();
    }
}