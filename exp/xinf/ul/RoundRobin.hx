/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ul;

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

/**
    RoundRobin maintains a short list of Items (which must implement ISettable<T>) 
    to display a long list of values (of type T).
**/

class RoundRobin<T,Item:ISettable<T>> extends Container {

    var model:ListModel<T>;
    var createItem:Void->Item;
    
    var n:Int;              // number of slots
    var rr:Array<Item>;     // the round-robin array
    var rrofs:Int;
    var rrstart:Int;
    
    var unit:Float;         // size of one unit (row height)
    var cOffset:Float;      // current negative offset in rows
    
    public function new( model:ListModel<T>, createItem:Void->Item, ?unit:Float ) :Void {
        super();
        
        this.model = model;
        this.createItem = createItem;
        
        n = 0;
        rr = new Array<Item>();
        rrofs = 0;
        rrstart = 0;
        
        this.unit = if( unit==null ) 20 else unit;
        cOffset = 0;

    }

    override public function resize( x:Float, y:Float ) :Void {
        setup( x, y );
        super.resize( x, unit*model.getLength() );
    }
    
    function setup( w:Float, total:Float ) :Void {
        // adjust n.
        var n = Math.ceil( total/unit )+1;
        if( n != this.n ) {
            for( i in this.n...n ) {
                var item = createItem();
                item.attachTo(this);
                rr.push( item );
            }
            // TODO: remove superfluous items in rr
            
            this.n = n;
        }
        
    //    trace("resize items to "+w+"/"+unit );
        for( item in rr ) {
            item.resize( w, unit );
        }
        
        redoAll();
    }

    public function redoAll() :Void {
        rrstart = Math.floor( cOffset ); // FIXME: spare
        rrofs = 0;
        
        var pos = rrstart*unit;
        var i = rrstart;
        var j = 0;
        for( item in rr ) {
            item.moveTo( 0, pos );
            var value = if( i>=model.getLength() ) null else model.getItemAt(i);
            item.set( value );
            i++;
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
        moveTo( position.x, -(cOffset*unit) );
        redoAll();
    }
    
    public function scrollToNormalized( offset:Float ) :Void {
        scrollBy( (offset * (model.getLength()-(n-1))) - cOffset );
    }

    public function assureVisible( index:Int ) :Void {
        var l = cOffset+n-1;
        if( index < cOffset ) {
            scrollBy( index-cOffset );
        } else if( index >= l ) {
            scrollBy( (index-l)+1 );
        }
        var ofs = Math.max( 0, Math.min( (model.getLength()-(n-1)), cOffset ) );
        if( ofs != cOffset ) scrollBy( cOffset-ofs );
    }

    public function scrollBy( offset:Float ) :Void {
        var ofs = cOffset+offset;
        ofs = Math.max( 0, Math.min( (model.getLength()-(n-1)), ofs ) );
        
        if( offset >= n ) {
            scrollTo( ofs );
        } else {
            // some items will remain the same. do the robin.
            cOffset = ofs;
            moveTo( position.x, -(cOffset*unit) );
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

    public function allVisible() :Bool {
        return( n > model.getLength() );
    }

    public function getItem( index:Int ) :Item {
        var i = Math.floor( index-rrstart );
        if( i<0 || i>=n ) return null;
        return( rr[ (i+rrofs)%n ] );
    }
    
    public function indexAt( offset:Float ) :Int {
        return Math.floor( (offset/unit)+cOffset );
    }

    public function setModel( m:ListModel<T> ) :Void {
        model = m;
        redoAll();
    }
}
