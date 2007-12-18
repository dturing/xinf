/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

class NameListModel<T> extends SimpleEventDispatcher, implements ListModel<T> {
    
    private var names:Array<String>;
    private var items:Array<T>;
    
    public function new() :Void {
        super();
        names = new Array<String>();
        items = new Array<T>();
    }
    
    public function addItem( name:String, value:T ) {
        items.push( value );
        names.push( name );
        
        // FIXME: provide a way to add a lot of items with triggering only one change event.
        postEvent( new SimpleEvent( SimpleEvent.CHANGED ) );
    }
    
    public function getLength() :Int {
        return items.length;
    }
    
    public function getItemAt( index:Int ) :T {
        return items[index];
    }

    public function getNameAt( index:Int ) :String {
        return names[index];
    }

    public function addChangedListener( f:SimpleEvent -> Void ) :Void {
        addEventListener( SimpleEvent.CHANGED, f );
    }
    
    public function removeChangedListener( f:SimpleEvent -> Void ) :Void {
        removeEventListener( SimpleEvent.CHANGED, f );
    }
    
}