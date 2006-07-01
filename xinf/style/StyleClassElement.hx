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
	}

	private function updateStyles() :Void {
		style = StyleSheet.defaultSheet.match( styleClasses );
		trace(""+this.name+" updateStyles: "+styleClasses.join(" ") );
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
