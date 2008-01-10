/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

class SimpleListModel<T> implements ListModel<T> {

    private var items:Array<T>;
    
    public function new() :Void {
        items = new Array<T>();
    }
    
    public function addItem( item:T ) :Void {
        items.push( item );
    }

    public function addItems( items:Iterator<T> ) :Void {
        for( item in items ) {
            this.items.push( item );
        }
    }

    public function getLength() :Int {
        return items.length;
    }

    public function getItemAt( index:Int ) :T {
        return items[index];
    }
    
    public function sort( f:T->T->Int ) :Void {
        items.sort( f );
    }
    
    public static function create<T>( items:Iterator<T> ) :SimpleListModel<T> {
        var r = new SimpleListModel<T>();
        r.addItems(items);
        return r;
    }
    
}
