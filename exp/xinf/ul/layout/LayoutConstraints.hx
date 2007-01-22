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

package xinf.ul.layout;

import xinf.value.Value;

enum Edge {
    North;
    East;
    South;
    West;
}

class LayoutConstraints {
    var x:Slot;
    var y:Slot;
    var width:Slot;
    var height:Slot;
    var east:Slot;
    var south:Slot;
    
    public function new( ?x:Slot, ?y:Slot, ?width:Slot, ?height:Slot ) :Void {
        this.x = if(x!=null) x else new Slot();
        this.y = if(y!=null) y else new Slot();
        this.width = if(width!=null) width else new Slot();
        this.height = if(height!=null) height else new Slot();

        east=new Slot();
        south=new Slot();
        if( width!=null )
            east.set( Value.sum(x,width) );
        if( height!=null ) 
            south.set( Value.sum(y,height) );
    }

    public function getConstraint( edge:Edge ) {
        return(
            switch( edge ) {
                case West:
                    getX();
                case North:
                    getY();
                case East:
                    getEast();
                case South:
                    getSouth();
            }
            );
    }

    public function getX() :Slot { return x; }
    public function getY() :Slot { return y; }
    public function getWidth() :Slot { return width; }
    public function getHeight() :Slot { return height; }
    public function getEast() :Slot { return east; }
    public function getSouth() :Slot { return south; }
    
    public function setConstraint( edge:Edge, s:Slot ) {
        switch( edge ) {
            case West:
                setX(s);
            case North:
                setY(s);
            case East:
                setEast(s);
            case South:
                setSouth(s);
        }
        //trace("set "+edge+" to "+s+", now "+this );
    }
    
    public function setX( s:Value ) :Value {
        x.set(s);
        return x;
    }

    public function setY( s:Value ) :Value {
        y.set(s);
        return y;
    }
    
    public function setWidth( s:Value ) :Value {
        width.set(s);
        east.set( Value.sum(x,width) );
        return width;
    }

    public function setHeight( s:Value ) :Value {
        height.set(s);
        south.set( Value.sum(y,height) );
        return height;
    }

    public function setEast( s:Value ) :Value {
        east.set(s);
        width.set( Value.sum(east,Value.minus(x)) );
        trace("set East, width now "+width );
        return east;
    }

    public function setSouth( s:Value ) :Value {
        south.set(s);
        height.set( Value.sum(south,Value.minus(y)) );
        return south;
    }
    
    public function toString() :String {
        var r = "[[\n\t";
        
            if( x!=null ) r+="x:"+x.toString()+";\n\t";
            if( y!=null ) r+="y:"+y.toString()+";\n\t";
            if( width!=null ) r+="w:"+width.toString()+";\n\t";
            if( height!=null ) r+="h:"+height.toString()+";\n\t";
            if( east!=null ) r+="E:"+east.toString()+";\n\t";
            if( south!=null ) r+="S:"+south.toString()+";\n\t";
        
        r+="]]";
        return r;
    }
}
