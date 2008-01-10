/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import xinf.ul.Component;
import xinf.ul.Container;
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
    override public function getMin() :Null<Float> {
        return resolve().getMin();
    }
    override public function getPref() :Null<Float> {
        return resolve().getPref();
    }
    override public function getMax() :Null<Float> {
        return resolve().getMax();
    }
    override public function getValue() :Null<Float> {
        _value = resolve().getValue();
        return _value;
    }
    override public function toString() :String {
        return(""+o.getElement().xid+edge+":"+resolve());
    }
}

class WidthSpring extends SimpleSpring {
    var c:Component;
    
    public function new( component:Component ) :Void {
        super();
        c = component;
    }
    override public function getMin() :Null<Float> {
        return 0;
    }
    override public function getPref() :Null<Float> {
    	return Helper.clampSize( c.prefSize, c ).x;
    }
    override public function getMax() :Null<Float> {
        return Spring.MAX;
    }
    override public function toString() :String {
        return("W("+c+":"+getPref()+")");
    }
}

class HeightSpring extends WidthSpring {
    override public function getPref() :Null<Float> {
    	return Helper.clampSize( c.prefSize, c ).y;
    }
    override public function toString() :String {
        return("H("+c+":"+getPref()+")");
    }
}

class LeftSpring extends WidthSpring {
    override public function getPref() :Null<Float> {
        return c.padding.l + c.border.l;
    }
    override public function toString() :String {
        return("l("+c+":"+getPref()+")");
    }
}
class TopSpring extends WidthSpring {
    override public function getPref() :Null<Float> {
        return c.padding.t + c.border.t;
    }
    override public function toString() :String {
        return("t("+c+":"+getPref()+")");
    }
}
class RightSpring extends WidthSpring {
    override public function getPref() :Null<Float> {
        return c.padding.r + c.border.r;
    }
    override public function toString() :String {
        return("r("+c+":"+getPref()+")");
    }
}
class BottomSpring extends WidthSpring {
    override public function getPref() :Null<Float> {
        return c.padding.b + c.border.b;
    }
    override public function toString() :String {
        return("b("+c+":"+getPref()+")");
    }
}

/*
    FIXME: derive from ConstrainedLayout<(Spring)Constraints>
*/
class SpringLayout implements Layout {
    var index:IntHash<Constraints>;
    
    public function new() :Void {
        index = new IntHash<Constraints>();
    }
    
    public function getConstraint( edge:Edge, o:Component ) {
        return new DeferredSpring( this, edge, o );
    }
    
    public function getConstraints( comp:Component ) :Constraints {
    	var compId = comp.getElement().xid;
        var c:Constraints = index.get( compId );
        if( c==null ) {
            c = new Constraints();
            c.setWidth( new WidthSpring(comp) );
            c.setHeight( new HeightSpring(comp) );
            c.setX( Spring.constant(0) );
            c.setY( Spring.constant(0) );
            index.set( compId, c );
        }
        return c;
    }
    
    public function initContainer( p:Component ) :Constraints {
        var c = getConstraints( p );
        c.setX( Spring.constant(0) );
        c.setY( Spring.constant(0) );
      //  c.setWidth( Spring.constant(p.size.x) );
      //  c.setHeight( Spring.constant(p.size.y) );
    //    trace("initContainer "+p+" east: "+c.getEast() );
        if( c.getEast() == null )
            c.setEast( Spring.constant(0) );
        if( c.getSouth() == null )
            c.setSouth( Spring.constant(0) );
        return c;
    }
    
    public function layoutContainer( p:Container ) {
        var cs = initContainer( p );
        cs.dropCalcResult();
        
        for( c in p.getComponents() ) {
            getConstraints(c).dropCalcResult();
        }
        
        for( c in p.getComponents() ) {
            var constraints = getConstraints(c);
            //trace("child: "+constraints );
            
            var x = constraints.getX().getValue();
            var y = constraints.getY().getValue();
            var width = constraints.getWidth().getValue();
            var height = constraints.getHeight().getValue();
            
            if( c.position.x!=x || c.position.y!=y ) c.set_position({x:x,y:y});
            if( c.size.x!=width || c.size.y!=height ) c.set_size({x:width,y:height});

        }

        var x = cs.getX().getValue();
        var y = cs.getY().getValue();
        var width = cs.getWidth().getValue();
        var height = cs.getHeight().getValue();
        p.setPrefSize( {x:width,y:height} );
    }
    
    public function putConstraint( e1:Edge, c1:Component, ?s:Spring, 
                                   e2:Edge, c2:Component ) {
        var constraints1 = getConstraints(c1);
        var otherEdge = getConstraint(e2,c2);
        var sp = if( s!=null ) Spring.sum(s,otherEdge) else otherEdge;
        constraints1.setConstraint(e1, sp);
    }
}
