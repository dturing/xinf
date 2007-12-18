/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

class SelectableListModel<T> implements ListModel<Selectable<T>> {

    private var items:Array<Selectable<T>>;
    
    public function new() :Void {
        items = new Array<Selectable<T>>();
    }
    
    public function addItem( item:T ) :Void {
        items.push( new Selectable(item) );
    }

    public function addItems( items:Array<T> ) :Void {
        for( item in items ) {
            this.items.push( new Selectable(item) );
        }
    }

    public function getLength() :Int {
        return items.length;
    }

    public function getItemAt( index:Int ) :Selectable<T> {
        return items[index];
    }
    
    public function sort( f:T->T->Int ) :Void {
        items.sort( function(a,b) {
                return f( a.item, b.item );
            });
    }
    
    public static function create<T>( items:Array<T> ) :SelectableListModel<T> {
        var r = new SelectableListModel<T>();
        r.addItems(items);
        return r;
    }
    
}
