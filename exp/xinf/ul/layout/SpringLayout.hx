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

import xinf.ony.Object;
import xinf.ul.Component;
import xinf.ul.layout.Spring;
import xinf.ul.layout.Constraints;

class DeferredSpring extends SimpleSpring {
    var sl:SpringLayout;
    var edge:Edge;
    var o:Component;
    
    public function new( s:SpringLayout, e:Edge, o:Component ) :Void { 
        super();
        sl=s;
        edge=e;
        this.o=o;
    }
    function resolve() :Spring {
        return sl.getConstraints(o).getConstraint(edge);
    }
    public function getMin() :Float {
        return resolve().getMin();
    }
    public function getPref() :Float {
        return resolve().getPref();
    }
    public function getMax() :Float {
        return resolve().getMax();
    }
    public function getValue() :Float {
        _value = resolve().getValue();
        if( _value == Spring.UNSET ) _value = getPref();
        return _value;
    }
    public function toString() :String {
        return(" >#"+o._id+"."+edge+":"+resolve()+" ");
    }
}

class WidthSpring extends SimpleSpring {
    var c:Object;
    
    public function new( component:Object ) :Void {
        super();
        c = component;
    }
    public function getMin() :Float {
        return 0;
    }
    public function getPref() :Float {
        return c.size.x;
    }
    public function getMax() :Float {
        return Spring.MAX;
    }
    public function toString() :String {
        return("Width("+c+")");
    }
}

class HeightSpring extends WidthSpring {
    public function new( component:Object ) :Void {
        super(component);
    }
    override public function getPref() :Float {
        return c.size.y;
    }
    override public function toString() :String {
        return("Height("+c+")");
    }
}

class SpringLayout {
    var index:IntHash<Constraints>;
    
    public function new() :Void {
        index = new IntHash<Constraints>();
    }
    
    public function getConstraint( edge:Edge, o:Component ) {
        return new DeferredSpring( this, edge, o );
    }
    
    public function getConstraints( o:Object ) :Constraints {
        var c:Constraints = index.get( o._id );
        if( c==null ) {
            c = new Constraints();
            c.setWidth( new WidthSpring(o) );
            c.setHeight( new HeightSpring(o) );
            c.setX( Spring.constant(0) );
            c.setY( Spring.constant(0) );
            index.set( o._id, c );
        }
        return c;
    }
    
    public function initContainer( p:Component ) :Constraints {
        var c = getConstraints( p );
        c.setX( Spring.constant(0) );
        c.setY( Spring.constant(0) );
      //  c.setWidth( Spring.constant(p.size.x) );
      //  c.setHeight( Spring.constant(p.size.y) );
        trace("initContainer "+p+" east: "+c.getEast() );
        if( c.getEast() == null )
            c.setEast( Spring.constant(0,0,Spring.MAX) );
        if( c.getSouth() == null )
            c.setSouth( Spring.constant(0,0,Spring.MAX) );
        return c;
    }
    
    public function layoutContainer( p:Component ) {
        var cs = initContainer( p );
        cs.dropCalcResult();
        
        for( c in p.children ) {
            getConstraints(c).dropCalcResult();
        }
        
        
        for( c in p.children ) {
            var constraints = getConstraints(c);
            
            var x = constraints.getX().getValue();
            var y = constraints.getY().getValue();
            var width = constraints.getWidth().getValue();
            var height = constraints.getHeight().getValue();
            
            //trace("Layout "+c+": "+x+","+y+"-"+width+"x"+height+":\n\t"+constraints );
            c.moveTo(x,y);
            c.resize(width,height);
        }

        var x = cs.getX().getValue();
        var y = cs.getY().getValue();
        var width = cs.getWidth().getValue();
        var height = cs.getHeight().getValue();
        trace("Layout Self "+p+": "+x+","+y+"-"+width+"x"+height );
        //p.moveTo(x,y);
        p.resize(width,height); 
    }
    
    public function putConstraint( e1:Edge, c1:Component, ?s:Spring, 
                                   e2:Edge, c2:Component ) {
        var constraints1 = getConstraints(c1);
        var otherEdge = getConstraint(e2,c2);
        var sp = if( s!=null ) Spring.sum(s,otherEdge) else otherEdge;
        constraints1.setConstraint(e1, sp);
    }
}
