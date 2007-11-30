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

package xinf.ul.model;

interface TreeNode<T> {
    var parent:TreeNode<T>;
    var firstChild:TreeNode<T>;
    var lastChild:TreeNode<T>;
    var next:TreeNode<T>;
    var previous:TreeNode<T>;
    
    var open(getOpen,setOpen):Bool;
    function getValue() :T;
}

typedef TreeModel<T> = TreeNode<T>

class SimpleTreeNode<T> implements TreeNode<T> {

    public var open(getOpen,setOpen):Bool;
    var value:T;
    
    public var parent:TreeNode<T>;
    public var firstChild:TreeNode<T>;
    public var lastChild:TreeNode<T>;
    public var previous:TreeNode<T>;
    public var next:TreeNode<T>;
    
    public function new( value:T ) :Void {
        this.value = value;
        open = true;
    }
    
    public function getValue() :T {
        return value;
    }

    public function getOpen() :Bool {
        return open;
    }
    public function setOpen( o:Bool ) :Bool {
        open=o;
        return open;
    }

    public function addChild( child:TreeNode<T> ) :Void {
        if( firstChild==null ) 
            firstChild=lastChild=child;
        else {
            lastChild.next = child;
            child.previous = lastChild;
            lastChild = child;
        }
        child.parent = this;
    }
    
    public function addSimple( value:T ) :Void {
        addChild( new SimpleNode( value ) );
    }
    
    public function toString() :String {
        return ""+value;
    }
    
    /*
    public static function createDynamic( e:Dynamic ) :SimpleTreeNode<T> {
        // TODO
    }
    */
}

