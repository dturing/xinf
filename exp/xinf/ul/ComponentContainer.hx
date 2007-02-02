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

class ComponentContainer extends Component {
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
        var l = child.addEventListener( GeometryEvent.PREF_SIZE_CHANGED, onComponentResize );
        child.__parentSizeListener = l;
        scheduleRedraw();
    }

    public function detach( child:Component ) :Void {
        children.remove( child );
        child.parent = null;
        child.removeEventListener( GeometryEvent.PREF_SIZE_CHANGED, child.__parentSizeListener );
        scheduleRedraw();
    }

    function onComponentResize( e:GeometryEvent ) :Void {
        relayoutNeeded=true;
        scheduleTransform();
    }
    
    function relayout() :Void {
        if( relayoutNeeded ) {
            var oldSize = size;
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
        if( layout!=null && relayoutNeeded ) relayout();
        super.reTransform( g );
    }

    override public function draw( g:Renderer ) :Void {
        g.startObject( _id );
            drawContents(g);
            
            // draw children
            for( child in children ) {
                g.showObject( child._id );
            }
            
        g.endObject();
        reTransform(g);
    }
}
