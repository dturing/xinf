/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

import xinf.ul.Component;
import xinf.ul.Container;

class ConstrainedLayout<Constraint> {
    var index:IntHash<Constraint>;
    
    public function new() :Void {
        index = new IntHash<Constraint>();
    }
    
    public function getConstraints( comp:Component ) :Constraint {
    	var compId = comp.cid;
        var c:Constraint = index.get( compId );
        if( c==null ) {
            c = createConstraints();
            index.set( compId, c );
        }
        return c;
    }
    
    public function setConstraint( comp:Component, c:Constraint ) :Void {
        index.set( comp.cid, c );
    }
    
    public function createConstraints() :Constraint {
        return null;
    }
}
