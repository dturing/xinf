/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;
import xinf.xml.Node;
import xinf.ul.model.ISettable;

class TableRow<T> implements ISettable<T> {

	var table:Table<T>;

	var value:T;
	var texts:Array<Text>;
	var g:Group;
	
	var cursor:Bool;
	var size:TPoint;


	public function setCursor( isCursor:Bool ) :Bool {
		if( isCursor!=cursor ) {
			cursor = isCursor;
		}
		return cursor;
	}
	
	public function new( table:Table<T>, ?value:T ) :Void {
		
		g = new Group();
		texts = new Array<Text>();
		for( i in 0...table.def.length ) {
			texts[i] = new Text();
			g.appendChild(texts[i]);
		}
		
		this.value = value;
		this.table=table;
		cursor=false;
		
		setStyle({});
	}
	
	public function set( ?value:T ) :Void {
		this.value = value;
		if( value==null ) {
			for( t in texts ) t.text="";
		} else {
			for( i in 0...texts.length ) {
				texts[i].text = Std.string(
					Reflect.field( value,
					table.def[i].name ));
			}
		}
	}
	
	public function setStyle( style:Dynamic ) :Void {
		var x=0.;
		for( i in 0...texts.length ) {
			var text = texts[i];
			text.setTraitsFromObject(style);
			text.styleChanged();
			text.y = text.fontSize;
			text.x = x;
			x+=table.def[i].width;
		}
	}
	
	public function attachTo( parent:Node ) :Void {
		parent.appendChild(g);
	}

	public function moveTo( x:Float, y:Float ) :Void {
		g.transform = new Translate(x,y);
	}
	
	public function resize( x:Float, y:Float ) :Void {
		size = { x:x, y:y };
	}
}
