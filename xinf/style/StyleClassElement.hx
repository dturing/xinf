package xinf.style;

import xinf.style.Style;
import xinf.ony.Element;

class StyleClassElement extends StyledElement {
	private var styleClasses :Array<String>;
	
	public function new( name:String, parent:Element ) :Void {
		super(name,parent);
		styleClasses = new Array<String>();
		
		// add our own class to the list of style classes
		var clNames = Reflect.getClass(this).__name__;
		addStyleClass( clNames[ clNames.length-1 ] );

		// :hover pseudo-class
		addEventListener( xinf.event.Event.MOUSE_OVER, onMouseOver );
		addEventListener( xinf.event.Event.MOUSE_OUT, onMouseOut );
	}

	private function onMouseOver( e:xinf.event.Event ) {
		addStyleClass(":hover");
	}
	private function onMouseOut( e:xinf.event.Event ) {
		removeStyleClass(":hover");
	}
		
	private function updateStyles() :Void {
		style = StyleSheet.defaultSheet.match( styleClasses );
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
}
