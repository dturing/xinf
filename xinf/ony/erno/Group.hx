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

package xinf.ony.erno;

import xinf.erno.Renderer;
import xinf.erno.Runtime;
import xinf.geom.Matrix;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;

/**
    A Container is an Object that can contain other objects.
    You can constrain the type of mChildren it accepts to any subclass of Object.
    <p>
        You can add and remove mChildren with [attach()] and [detach()]
    </p>
**/

typedef Child=xinf.ony.Element

class Group extends Object, implements xinf.ony.Group {
    
    private var mChildren(default,null):Array<Child>;    

    public function children() :Iterator<xinf.ony.Element> {
        return mChildren.iterator();
    }

    /** Container constructor<br/>
        A simple Container will not display anything by itself,
        but can be used as a container object to group other Objects.
    **/
    public function new() :Void {
        super();
        mChildren = new Array<Child>();
    }
    
    /** attach (add) a child Object<br/>
        Add 'child' to this object's list of mChildren, inserts
        the child into the display hierarchy, similar to addChild in Flash 
        or appendChild in JavaScript/DOM.
        The new child will be added at the end of the list, so it will appear
        in front of all current mChildren.
    **/
    public function attach( child:Child, ?after:Child ) :Void {
        if( after!=null ) {
            // find 'after'
            var pos=-1;
            var i=0;
            for( child in mChildren ) {
                if( child==after ) pos=i;
                i++;
            }
            if( pos==-1 )
                mChildren.push( child );
            else 
                mChildren.insert( pos+1, child );
        } else {
            mChildren.push( child );
        }
        
        child.attachedTo( this );
   
        scheduleRedraw();
    }

    /** detach (remove) a child Object<br/>
        Removes 'child' from this object's list of mChildren. **/
    public function detach( child:Child ) :Void {
        mChildren.remove( child );
        child.detachedFrom( this );
        scheduleRedraw();
    }

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
        if( document==null ) throw("Document not set.");
        for( node in xml.elements() ) {
            var child = document.unmarshal( node );
            if( child!=null ) {
                attach( child );
            }
        }
    }
    
    /** draw the Object to the given [Renderer]<br/>
        You should usually neither call nor override this function,
        instead, schedule a redraw with [scheduleRedraw()] and 
        override [drawContents()] to draw stuff.
        **/
    override public function draw( g:Renderer ) :Void {
        g.startObject( xid );
            drawContents(g);
            
            // draw mChildren
            for( child in mChildren ) {
                g.showObject( child.xid );
            }
            
        g.endObject();
        reTransform(g);
    }
}
