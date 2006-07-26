package xinf.style;

import xinf.style.Style;
import xinf.ony.Element;

import xinf.ony.MouseEvent;

/**
	FIXME: really do the :hover here? or in some InteractiveElement?
**/

class StyleClassElement extends StyledElement {
	private var styleClasses :Array<String>;
	
	public function new( name:String, parent:Element ) :Void {
		super(name,parent);
		styleClasses = new Array<String>();
		
		// add our own class to the list of style classes
		var clNames = Reflect.getClass(this).__name__;
		addStyleClass( clNames[ clNames.length-1 ] );

		// :hover pseudo-class
		addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
		addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
	}

	private function onMouseOver( e:MouseEvent ) {
		addStyleClass(":hover");
	}
	private function onMouseOut( e:MouseEvent ) {
		removeStyleClass(":hover");
	}
		
	public function updateStyles() :Void {
		style = StyleSheet.defaultSheet.match( this );
		applyStyle();
	}

	public function addStyleClass( name:String ) :Void {
		styleClasses.push( name );
		updateStyles();
	}
	
	public function removeStyleClass( name:String ) :Void {
		styleClasses.remove( name );
		updateStyles();
	}
	
	public function hasStyleClass( name:String ) :Bool {
		for( c in styleClasses ) {
			if( c == name ) return true;
		}
		return false;
	}

	public function getStyleClasses() :Array<String> {
		return styleClasses;
	}
}
