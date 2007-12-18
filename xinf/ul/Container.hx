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

import xinf.ul.layout.Layout;
import Xinf;

class Container extends Component {
    var relayoutNeeded:Bool;
    public var layout:Layout;
    
    public var children(default,null):Array<Component>;    

    var group:Group;

    public function new( ?g:Group, ?traits:Dynamic ) :Void {
		group = g;
		if( group==null ) group = new Group();
        super( group, traits );
		
		_skin.attachBackground( group );
		_skin.attachForeground( group );
		
        children = new Array<Component>();
        relayoutNeeded = true;
    }
    
    public function attach( child:Component ) :Void {
        children.push( child );
        
        relayoutNeeded = true;
        var l = child.addEventListener( ComponentSizeEvent.PREF_SIZE_CHANGED, onComponentResize );
        child.__parentSizeListener = l;
		child.attachedTo( this );

		_skin.detachForeground( group );
        group.attach(child.getElement());
		_skin.attachForeground( group );
		
		relayout();
    }

    public function detach( child:Component ) :Void {
        if( child==null ) throw("trying to detach null");
        children.remove( child );
        child.removeEventListener( ComponentSizeEvent.PREF_SIZE_CHANGED, child.__parentSizeListener );
		child.detachedFrom( this );
        group.detach(child.getElement());
    }

    function onComponentResize( e:ComponentSizeEvent ) :Void {
        if( layout==null ) {
            e.component.size = e;
        } else {
            relayoutNeeded=true;
			relayout();
        }
    }

    public function relayout() :Void {
        if( layout!=null && relayoutNeeded ) {
            var oldSize = size;
//            trace("relayout "+this);
            layout.layoutContainer( this );
            relayoutNeeded = false;
        }
    }
    
    override public function getElement() :Element {
        return group;
    }
    
    public function getComponent( index:Int ) :Component {
        return children[index];
    }
    public function getComponents() :Iterator<Component> {
        return children.iterator();
    }

}
