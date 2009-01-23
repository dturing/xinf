/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;
import xinf.xml.Node;
import xinf.ul.list.RoundRobin;
import xinf.ul.model.TreeModel;
import xinf.ul.model.ListModel;
import xinf.ul.model.ISettable;
import xinf.erno.Renderer;

typedef TreeItemData<T> = {
	depth:Int,
	node:TreeNode<T>
}

class TreeIterator<T> {
	var _next:TreeNode<T>;
	var quitDepth:Int;
	public var depth(default,null):Int;
	
	public function new( node:TreeNode<T>, d:Int ) {
		this._next = node;
		
		if( d==-1 ) {
			// skip root
			quitDepth = depth = -1;
			if( node==null ) return;
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
	var root:TreeNode<T>;
	var items:Array<TreeItemData<T>>;

	public function new( root:TreeNode<T> ) {
		items = new Array<TreeItemData<T>>();
		var it = new TreeIterator(root,-1);
		for( item in it ) {
			items.push( item );
		}
	}
	
	public function getLength() :Int {
		return items.length;
	}

	public function getItemAt( index:Int ) :TreeItemData<T> {
		return items[index];
	}

	public function toggle( index:Int, item:TreeItemData<T> ) :Int {
		var r=0;
		if( item.node.open ) {
			item.node.open=false;
			
			var i=0;
			var it = new TreeIterator( item.node.firstChild, item.depth+1 );
			for( item in it ) {
				i++;
			}
			//i++;
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

interface TreeItem<T> implements ISettable<TreeItemData<T>> {
	function set( ?d:TreeItemData<T> ) :Void;
	function setStyle( style:Dynamic ) :Void;
	function attachTo( parent:Node ) :Void;

	function moveTo( x:Float, y:Float ) :Void;
	function resize( x:Float, y:Float ) :Void;
	
	function setCursor( isCursor:Bool ) :Bool;
}

class StringTreeItem<T> implements TreeItem<T> {
	var value:TreeItemData<T>;
	
	var text:Text;
	var handle:Group;
	var handleP:Polygon;
	
	var cursor:Bool;
	var size:TPoint;
	
	public function new( ?value:TreeItemData<T> ) :Void {
		text = new Text();
		
		handleP = new Polygon();
		var h = .5;
		handleP.points = [ {x:-h,y:-h}, {x:h,y:0.}, {x:-h,y:h} ];
		handle = new Group();
		handle.appendChild(handleP);
		
		this.value = value;
		cursor=false;
		
//		handleP.addStyleClass("TreeItem");
	}

	public function setCursor( isCursor:Bool ) :Bool {
		if( isCursor!=cursor ) {
			cursor = isCursor;
		}
		return cursor;
	}
	
	public function set( ?v:TreeItemData<T> ) :Void {
		this.value = v;
		
		if( v==null ) {
			text.text = "";
			text.x = 0;
			handle.visibility = Visibility.Hidden;
		} else {
			text.text = Std.string(v.node);
			text.x = 10*value.depth;
			var translate = new Translate( value.depth, 0 );
			if( v.node.firstChild==null ) {
				handle.visibility = Visibility.Hidden;
			} else {
				handle.visibility = Visibility.Visible;
				if( v.node.open )
					handleP.transform = new TransformList([
						new Rotate(Math.PI/2), translate ]);
				else
					handleP.transform = translate;
			}
		}
	}
	
	public function setStyle( style:Dynamic ) :Void {
		text.setTraitsFromObject(style);
		text.styleChanged();
		handle.setTraitsFromObject(style);
		handle.styleChanged();
	}
	
	public function attachTo( parent:Node ) :Void {
		parent.appendChild(text);
		parent.appendChild(handle);
	}

	public function moveTo( x:Float, y:Float ) :Void {
		var h = size.y/2;
		handle.transform = new TransformList([
				new Scale( h, h ),
				new Translate( x+h, y+h )
				]);
		text.transform = new Translate( x+h+h, y+text.fontSize+((size.y-text.fontSize)/3) );
	}
	
	public function resize( x:Float, y:Float ) :Void {
		size = { x:x, y:y };
	}
}

class TreeView<T> extends ListView<TreeItemData<T>> {
	var tree:TreeModel<T>;
	var listModel:TreeAsListModel<T>;
	
	public function new( tree:TreeModel<T>, ?createItem:Void->TreeItem<T>, ?traits:Dynamic ) :Void {
		if( createItem==null ) createItem = function() { return new StringTreeItem<T>(); };
		listModel = new TreeAsListModel<T>(tree);
		super( listModel, createItem, traits );

		this.tree = tree;
		
		addEventListener( PICKED, itemPicked );
	}
	
	function itemPicked( e:PickEvent<TreeItemData<T>> ) :Void {
		var r = listModel.toggle( e.index, e.item );
		if( r>0 ) assureVisible( e.index+r );
		assureVisible( e.index );
		rr.redoAll();
		updateScrollbar();
		setCursor(cursorPosition);
	}
}
