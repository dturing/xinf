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

package org.xinf.inity;

import org.xinf.event.EventDispatcher;
import org.xinf.event.Event;

// TODO: if this remains the only reference to org.xinf.ony, 
// style stuff should probably be moved to org.xinf.style
// (this note is out of date but here is still sth to do)
import org.xinf.ony.Bounds;

class Object {
    private var _displayList:Int;
    private var _displayListSimple:Int;
    private var _changed:Bool;
    
    public var transform:org.xinf.geom.Matrix;
    public var owner:EventDispatcher;
    public var bounds:Bounds;
    public var parent:org.xinf.inity.Group;

    public var bgColor:org.xinf.ony.Color;
    public var fgColor:org.xinf.ony.Color;    
    
    /* ------------------------------------------------------
       Object API
       ------------------------------------------------------ */
    
    public function new() :Void {
        transform = new org.xinf.geom.Matrix();
        _displayList = _displayListSimple = null;
        bounds = new Bounds();
        changed();
    }
    
    public function changed() :Void {
        if( !_changed ) {
            _changed = true;
            changedObjects.push(this);
        }
    }
    private static var changedObjects:Array<Object> = new Array<Object>();
    public static function cacheChanged() :Bool  {
        var o:Object;
        if( changedObjects.length == 0 ) return false;
        while( (o=changedObjects.shift()) != null ) {
            o._cache();
        }
        return true;
    }

    public function postEvent( type:String, data:Dynamic ) :Void {
        if( owner == null ) throw("Object "+this+" has no owner.");
        owner.postEvent(type,data);
    }

    /* ------------------------------------------------------
       Rendering
       ------------------------------------------------------ */
    
    // cache the object as a displaylist, regard transform.
    public function _cache() :Void {
        if( _changed ) {
            if( bounds.x != null && bounds.y != null ) { // FIXME. maybe do this somewhere else?
                transform.tx = bounds.x;
                transform.ty = bounds.y;
            }
        
            if( _displayList == null ) {
                _displayList = GL.GenLists(1);
            }
            GL.NewList( _displayList, GL.COMPILE );
            GL.PushMatrix();
                GL.MultMatrixf( transform._v );
                _render();
            GL.PopMatrix();
            GL.EndList();
            
            // cache simplified (maybe not do this if they are the same? FIXME)
            if( _displayListSimple == null ) {
                _displayListSimple = GL.GenLists(1);
            }
            GL.NewList( _displayListSimple, GL.COMPILE );
            GL.PushMatrix();
                GL.MultMatrixf( transform._v );
                _renderSimple();
            GL.PopMatrix();
            GL.EndList();
            
            _changed = false;
        }
    }
    
    // children overwrite this to render their actual contents
    private function _render() :Void {
    }
    
    // children can overwrite this to render a simplified version used for hittest
    private function _renderSimple() :Void {
        // default
        _render();
    }
    
    // external interface (called from where?)
    public function render() :Void {
        GL.CallList( _displayList );
    }
    public function renderSimple() :Void {
        GL.CallList( _displayListSimple );
    }
    
    
    public function toString() :String {
        return( "<"+ Reflect.getClass(this).__name__.join(".") + " #" + _displayList + ">" );
    }
}
