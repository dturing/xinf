/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;

import xinf.ul.model.ListModel;
import xinf.ul.model.ISettable;

typedef Column = {
	name:String,
	title:String,
	width:Float
}

class Table<T> extends ListView<T> {

	public var def(default,null):Array<Column>;

	public function new( model:ListModel<T>, def:Array<Column> ) :Void {
		var self=this;
		var createItem = function() :ISettable<T> {
			return new xinf.ul.list.TableRow<T>( self );
		}
		super( model, createItem );
		
		this.def = def;
		
		var header = new TableHeader(this);
		header.transform = new Translate(0,-16); // FIXME
		group.appendChild( header );
		
	}

	override public function set_position( p:TPoint ) :TPoint {
		super.set_position(p);
		group.transform = new Translate(p.x,p.y+16);
		return( p );
	}

	override public function set_size( s:TPoint ) :TPoint {
		super.set_size( { x:s.x, y:s.y-16 } );
		return s;
	}
}
