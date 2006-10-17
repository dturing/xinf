package xinf.style;

class StyleClassElement extends xinf.ony.Object {
	public var style :Style;
	private var styleClasses :Array<String>;
	
	public function new() :Void {
		super();
		styleClasses = new Array<String>();
		style = StyleSheet.newDefaultStyle();
		
		// add our own class to the list of style classes
		var clNames:Array<String> = untyped Type.getClass(this).__name__;
		addStyleClass( clNames[ clNames.length-1 ] );
	}

	public function updateStyles() :Void {
		style = StyleSheet.defaultSheet.match( this );
		scheduleRedraw();
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
