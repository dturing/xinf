/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

enum Edge {
    North;
    East;
    South;
    West;
}

class Constraints {
    var x:Spring;
    var y:Spring;
    var width:Spring;
    var height:Spring;
    var east:Spring;
    var south:Spring;
    var h:Spring;
    var v:Spring;
    
    public function new( ?x:Spring, ?y:Spring, ?width:Spring, ?height:Spring ) :Void {
        this.x=x;
        this.y=y;
        this.width=width;
        this.height=height;
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

    public function getX() :Spring {
        if( x!=null ) return x;
        else if( h==null && width!=null && east!=null )
            h=Spring.sum(east,Spring.minus(width));
        return h;
    }

    public function getY() :Spring {
        if( y!=null ) return y;
        else if( v==null && height!=null && south!=null )
            v=Spring.sum(south,Spring.minus(height));
        return v;
    }

    public function getWidth() :Spring {
        if( width!=null ) return width;
        else if( h==null && x!=null && east!=null )
            h=Spring.sum(east,Spring.minus(x));
        return h;
    }
    
    public function getHeight() :Spring {
        if( height!=null ) return height;
        else if( v==null && y!=null && south!=null )
            v=Spring.sum(south,Spring.minus(y));            
        return v;
    }

    public function getEast() :Spring {
        if( east!=null ) return east;
        else if( h==null && x!=null && width!=null )
            h=Spring.sum(x,width);
        return h;
    }

    
    public function getSouth() :Spring {
        if( south!=null ) return south;
        else if( v==null && y!=null && height!=null )
            v=Spring.sum(y,height);
        return v;
    }
    
    public function setConstraint( edge:Edge, s:Spring ) {
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
    
    public function setWidth( s:Spring ) {
        width=s;
        h=null;
        if( width!=null && east!=null && x!=null )
            east=null;
    }

    public function setHeight( s:Spring ) {
        height=s;
        v=null;
        if( height!=null && south!=null && y!=null )
            south=null;
    }

    public function setX( s:Spring ) {
        x=s;
        h=null;
        if( width!=null && east!=null && x!=null )
            width=null;
    }

    public function setY( s:Spring ) {
        y=s;
        v=null;
        if( height!=null && south!=null && y!=null )
            height=null;
    }

    public function setEast( s:Spring ) {
        east=s;
        h=null;
        if( width!=null && east!=null && x!=null )
            x=null;
    }

    public function setSouth( s:Spring ) {
        south=s;
        v=null;
        if( height!=null && south!=null && y!=null )
            y=null;
    }
    
    public function dropCalcResult() {
        if( x!=null ) x.setValue(Spring.UNSET);
        if( y!=null ) y.setValue(Spring.UNSET);
        if( width!=null ) width.setValue(Spring.UNSET);
        if( height!=null ) height.setValue(Spring.UNSET);
        if( south!=null ) south.setValue(Spring.UNSET);
        if( east!=null ) east.setValue(Spring.UNSET);
        if( h!=null ) h.setValue(Spring.UNSET);
        if( v!=null ) v.setValue(Spring.UNSET);
    }
    
    public function toString() :String {
        var r = "[[\n\t";
        
            if( x!=null ) r+="x:"+x.toString()+";\n\t";
            if( y!=null ) r+="y:"+y.toString()+";\n\t";
            if( width!=null ) r+="w:"+width.toString()+";\n\t";
            if( height!=null ) r+="h:"+height.toString()+";\n\t";
            if( south!=null ) r+="S:"+south.toString()+";\n\t";
            if( east!=null ) r+="E:"+east.toString()+";\n\t";
        
        r+="]]";
        return r;
    }
}
