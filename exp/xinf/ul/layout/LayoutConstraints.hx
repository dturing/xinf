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
    var x:Value;
    var y:Value;
    var width:Value;
    var height:Value;
    var east:Value;
    var south:Value;
    
    public function new( ?x:Value, ?y:Value, ?width:Value, ?height:Value ) :Void {
        this.x=new Slot(x);
        this.y=new Slot(y);
        this.width=new Slot();
        this.height=new Slot();
        east=new Slot();
        south=new Slot();
        if( width!=null ) setWidth(width);
        if( height!=null ) setHeight(height);
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

    public function getX() :Value { return x; }
    public function getY() :Value { return y; }
    public function getWidth() :Value { return width; }
    public function getHeight() :Value { return height; }
    public function getEast() :Value { return east; }
    public function getSouth() :Value { return south; }
    
    public function setConstraint( edge:Edge, s:Value ) {
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
        width.set( Value.sum(x,Value.minus(east)) );
        return east;
    }

    public function setSouth( s:Value ) :Value {
        south.set(s);
        height.set( Value.sum(y,Value.minus(south)) );
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
