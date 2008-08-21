/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.magic;

import xinf.ul.Interface;
import xinf.ul.Component;
import xinf.ul.ValueEvent;
import xinf.ul.widget.Label;
import xinf.ul.widget.LineEdit;
import xinf.ul.widget.Slider;
import xinf.ul.widget.CheckBox;
import xinf.ul.layout.GridLayout;

class Magic extends Interface {

	var widgets:Hash<Component>;
	var types:Hash<MagicType>;
	
	public function new( items:Iterable<{ name:String, type:MagicType }> ) {
		super();
		
		widgets = new Hash<Component>();
		types = new Hash<MagicType>();
		
		for( item in items ) {
			createWidget( item.name, item.type );
		}
		
		layout = new GridLayout( 2, 3,3, true );
		
		relayout();
	}
	
	function createWidget( name:String, type:MagicType ) {
		var widget:Component;
		switch( type ) {
			case Textual( initial ):
				widget = new Label( initial );
			case Numeric( from, to, initial ):
				widget = new Slider( from, to, (to-from)/200, initial );
			case Switch( initial ):
				widget = new CheckBox("");
			default:
				widget = new Label();
		};
		widgets.set( name, widget );
		types.set( name, type );

		var label = new Label(name);
		label.addStyleClass("magicLabel");
		appendChild( label );
		appendChild( widget );
	}
	
	public function toFloat<T>( value:T ) :Float {
		switch( Type.typeof(value) ) {
			case TFloat:
				return cast(value);
			case TBool:
				return cast(value)?1.:0.;
			default:
				return Std.parseFloat( Std.string(value) );
		}
		return 0.;
	}

	public function set<T>( name:String, value:T ) {
		var type = types.get(name);
		if( type==null ) throw(""+name+" not found in Magic interface" );
		var widget = widgets.get(name);
		
		switch( type ) {
			case Textual(initial):
				cast(widget,Label).text = Std.string(value);
			case Numeric( from, to, initial ):
				cast(widget,Slider).value = toFloat(value);
			case Switch(initial):
				cast(widget,CheckBox).selected = cast(value);
			default:
				cast(widget,Label).text = Std.string(value);
		}
	}
	
	public function listen<T>( name:String, listener:T->Void ) {
		var type = types.get(name);
		if( type==null ) throw(""+name+" not found in Magic interface" );
		var widget = widgets.get(name);
		
		switch( type ) {
			case Textual(initial):
			
			case Numeric(from,to,initial):
				widget.addEventListener( ValueEvent.VALUE, function( v ) { listener(cast(v.value)); } );
				
			case Switch(initial):
				widget.addEventListener( CheckBox.CHANGED, function( v ) { listener(cast(v)); } );
				
			default:
				// do nothing
		}
	}
}