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

import xinf.ul.RoundRobin;
import xinf.ul.TreeModel;

typedef TreeItemData<T> = {
    depth:Int,
    node:Node<T>
}

class TreeIterator<T> {
    var _next:Node<T>;
    var quitDepth:Int;
    public var depth(default,null):Int;
    
    public function new( node:Node<T>, ?d:Int ) {
        this._next = node;
        
        if( d==null ) {
            // skip root
            quitDepth = depth = -1;
            node.open=true;
            next();
        } else {
            quitDepth = depth = d;
        }
    }

    public function hasNext() :Bool {
        return _next!=null;
    }
    
    public function next() :TreeItemData<T> {
        var r = {
            depth:depth,
            node:_next
            };
        
        // figure next
        var node = _next;
        if( node.open && node.firstChild!=null ) {
            depth++;
            _next = node.firstChild;
        } else {
            while( node.next==null ) {
                node = node.parent;
                depth--;
                if( node==null || depth<quitDepth ) {
                    _next=null;
                    return r;
                }
            }
            _next = node.next;
        }
        return r;
    }
}

class TreeAsListModel<T> implements ListModel<TreeItemData<T>> {
    var root:Node<T>;
    var items:Array<TreeItemData<T>>;

    public function new( root:Node<T> ) {
        items = new Array<TreeItemData<T>>();
        var it = new TreeIterator(root);
        for( item in it ) {
            items.push( item );
        }
    }
    
    override public function getLength() :Int {
        return items.length;
    }

    override public function getItemAt( index:Int ) :TreeItemData<T> {
        return items[index];
    }

    public function toggle( index:Int, item:TreeItemData<T> ) :Int {
        var r=0;
        if( item.node.open ) {
            item.node.open=false;
            
            var i=0;
            var it = new TreeIterator( item.node.firstChild );
            for( item in it ) {
                i++;
            }
            i++;
            var drop = items.splice( index+1, i );
            r=-i;
            
        } else if( item.node.firstChild!=null ) {
            item.node.open=true;
            
            var nu = items.slice(0,index+1);
            var it = new TreeIterator( item.node.firstChild, item.depth+1 );
            for( item in it ) {
                nu.push( item );
                r++;
            }
            
            items = nu.concat( items.slice(index+1) );
        }
        return r;
    }
}


class TreeItem<T> extends Label, implements Settable<TreeItemData<T>> {
    var value:T;
    
    public function new( ?value:T ) :Void {
        super( ""+value );
        this.value = value;
    }
    
    public function set( ?d:TreeItemData<T> ) :Void {
        if( d==null ) {
            value=null;
            text="";
            return;
        }
        value = d.node.getValue();
        text = value+" |"+d.depth;
        moveTo( 10*d.depth, position.y );
    }
    
    public function attachTo( parent:xinf.ony.Object ) :Void {
        parent.attach(this);
    }
}

class TreeView<T> extends ListBox<TreeItemData<T>> {
    var tree:TreeModel<T>;
    var listModel:TreeAsListModel<T>;
    
    public function new( tree:TreeModel<T>, ?createItem:Void->TreeItem<T> ) :Void {
        if( createItem==null ) createItem = function() { return new TreeItem<T>(); };
        listModel = new TreeAsListModel<T>(tree);
        super( listModel, createItem );

        this.tree = tree;
        
        addEventListener( PickEvent.ITEM_PICKED, itemPicked );
    }
    
    function itemPicked( e:PickEvent<TreeItemData<T>> ) :Void {
        listModel.toggle( e.index, e.item );
        rr.assureVisible( e.index );
        rr.redoAll();
        updateScrollbar();
    }
}
