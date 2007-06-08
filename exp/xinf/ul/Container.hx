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

import xinf.erno.Renderer;
import xinf.ul.layout.Layout;
import xinf.event.GeometryEvent;

class Container extends Component {
    var relayoutNeeded:Bool;
    public var layout:Layout;
    
    public var children(default,null):Array<Component>;    

    public function new() :Void {
        super();
        children = new Array<Component>();
        relayoutNeeded = true;
    }
    
    public function attach( child:Component ) :Void {
        children.push( child );
        child.parent = cast(this);
        relayoutNeeded = true;
        var l = child.addEventListener( ComponentSizeEvent.PREF_SIZE_CHANGED, onComponentResize );
        child.__parentSizeListener = l;
        child.updateClassStyle();
        scheduleRedraw();
        scheduleTransform();
    }

    public function detach( child:Component ) :Void {
        if( child==null ) throw("trying to detach null");
        children.remove( child );
        child.parent = null;
        child.removeEventListener( ComponentSizeEvent.PREF_SIZE_CHANGED, child.__parentSizeListener );
        scheduleRedraw();
        scheduleTransform();
    }

    function onComponentResize( e:ComponentSizeEvent ) :Void {
        if( layout==null ) {
            e.component.resize( e.x, e.y );
        } else {
            relayoutNeeded=true;
            scheduleTransform();
        }
    }

    override public function transformChanged() :Void {
        for( child in children ) {
            child.parentTransformChanged();
        }
    }

    function relayout() :Void {
        if( layout!=null && relayoutNeeded ) {
            var oldSize = size;
//            trace("relayout "+this);
            layout.layoutContainer( this );
            relayoutNeeded = false;
        }
    }
    
    public function getComponent( index:Int ) :Component {
        return children[index];
    }
    public function getComponents() :Iterator<Component> {
        return children.iterator();
    }

    public function reTransform( g:Renderer ) :Void {
        if( relayoutNeeded ) relayout();
        super.reTransform( g );
    }

    override public function draw( g:Renderer ) :Void {
        g.startObject( _id );
            drawContents(g);
            drawChildren(g);
        g.endObject();
        reTransform(g);
    }
    
    public function drawChildren( g:Renderer ) :Void {
        for( child in children ) {
            g.showObject( child._id );
        }
    }
    
    override public function updateClassStyle() :Void {
        super.updateClassStyle();
        if( children==null ) return;
        for( child in children ) {
            child.updateClassStyle();
        }
    }
}
