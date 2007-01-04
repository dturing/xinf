
package xinf.ul;


class Item<T> extends Label {
    var value:T;
    
    public function new( ?value:T ) :Void {
        super( ""+value );
        this.value = value;
    }
    
    public function set( ?value:T ) :Void {
        this.value = value;
        this.text = if( value==null ) "" else ""+value;
    }
}

/*
      i   rr
     _
    | 0 _   ___ rrstart, 1: rr start index
   _| 1 _ 3
  | | 2 _ 4 ___ rrofs, 2: rr offset
  | | 3 _ 0 
  | | 4 _ 1
  |_| 5 _ 2
    |_6   

  n:5
*/

class RoundRobin<T> extends Pane {

    var model:ListModel<T>;
    var createItem:Void->Item<T>;
    
    var n:Int;              // number of slots
    var rr:Array<Item<T>>;  // the round-robin array
    var rrofs:Int;
    var rrstart:Int;
    
    var unit:Float;         // size of one unit (row height)
    var cOffset:Float;      // current negative offset in rows
    
    public function new( model:ListModel<T>, ?createItem:Void->Item<T>, ?unit:Float ) :Void {
        super();
        
        this.model = model;
        this.createItem = createItem;
        
        n = 0;
        rr = new Array<Item<T>>();
        rrofs = 0;
        rrstart = 0;
        
        this.unit = if( unit==null ) 20 else unit;
        cOffset = 0;
        
    }

    override public function resize( x:Float, y:Float ) :Void {
        setup( y, x );
        super.resize( x, unit*model.getLength() );
    }
    
    function setup( w:Float, total:Float ) :Void {
        // adjust n.
        var n = Math.ceil( total/unit )+1;
        if( n != this.n ) {
            for( i in this.n...n ) {
                var item = if( createItem==null ) new Item<T>();
                           else createItem();
                attach( item );
                rr.push( item );
            }
            // TODO: remove superfluous items in rr
            
            this.n = n;
        }
        
        for( item in rr ) {
            item.resize( w, unit );
        }
        
        redoAll();
    }

    function redoAll() :Void {
        rrstart = Math.floor( cOffset ); // FIXME: spare
        rrofs = 0;
        
        var pos = rrstart*unit;
        var i = rrstart;
        var j = 0;
        for( item in rr ) {
            item.moveTo( 0, pos );
            item.set( model.getItemAt(i++) );
            pos+=unit;
        }
    }
    
    function shiftDown() :Void {
        var item = rr[rrofs];
        item.moveTo( 0, (rrstart+n)*unit );
        item.set( model.getItemAt(rrstart+n) );
        
        rrstart++;
        rrofs=(rrofs+1)%n;
    }

    function shiftUp() :Void {
        rrstart--;
        rrofs=(rrofs-1);
        if( rrofs<0 ) rrofs+=n;
        
        var item = rr[rrofs];
        item.moveTo( 0, (rrstart)*unit );
        item.set( model.getItemAt(rrstart) );
    }

    public function scrollTo( offset:Float ) :Void {
        cOffset = offset;
        moveTo( 0, -(cOffset*unit) );
        redoAll();
    }
    
    public function scrollToNormalized( offset:Float ) :Void {
        scrollTo( offset * (model.getLength()-(n-1)) );
    }

    public function assureVisible( index:Int ) :Void {
        var l = cOffset+n-1;
        if( index < cOffset ) {
            scrollBy( index-cOffset );
        } else if( index >= l ) {
            scrollBy( (index-l)+1 );
        }
    }

    public function scrollBy( offset:Float ) :Void {
        var ofs = cOffset+offset;
        ofs = Math.max( 0, Math.min( (model.getLength()-(n-1)), ofs ) );
        
        if( offset >= n ) {
            scrollTo( ofs );
        } else {
            // some items will remain the same. do the robin.
            cOffset = ofs;
            moveTo( 0, -(cOffset*unit) );
            while( (rrstart+1) < ofs ) {
                shiftDown();
            }
            while( rrstart > ofs ) {
                shiftUp();
            }
        }
    }

    public function getPositionNormalized() :Float {
        return( cOffset / (model.getLength()-(n-1)) );
    }
    
    public function getPageSize() :Int {
        return( n-1 );
    }

    public function getItem( index:Int ) :Item<T> {
        var i = Math.floor( index-rrstart );
        if( i<0 || i>=n ) return null;
        return( rr[ (i+rrofs)%n ] );
    }
    
    public function indexAt( offset:Float ) :Int {
        return Math.floor( (offset/unit)+cOffset );
    }
}
