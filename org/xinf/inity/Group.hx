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

package xinf.inity;

class Group extends Object {
    private var children:Array<Object>;
    
    public function new() :Void {
        super();
        children = new Array<Object>();
    }

    public function addChild( child:Object ) :Void {
        children.push(child);
        child.parent = this;
    }

    public function removeChild( child:Object ) :Void {
        children.remove(child);
        child.parent = null;
    }
    
    public function getChildAt( index:Int ) :Object {
        return children[index];
    }

    public function getHitChild( chain:Array<Int>, x:Float, y:Float ) :Object {
        var index = chain.shift();
        var object:Object = children[index];
        if( chain.length > 0 ) {
            var group:Group = cast(object,Group);
            return( group.getHitChild( chain, x-bounds.x, y-bounds.y ) );
        }
        return object;
    }
    
    // rendering
    public function _cache() :Void {
        for( child in children ) {
            child._cache();
        }
        super._cache();
    }
    private function _render() :Void {
        for( child in children ) {
            child.render();
        }
//        super._render();
    }
    private function _renderSimple() :Void {
        for( i in 0...children.length ) {
            GL.PushName(i);
            children[i].renderSimple();
            GL.PopName();
        }
    }
}
