package xinf.style;

class StyleClassElement extends StyleElement {
    
    private var styleClasses :Array<String>;
    
    public function new() :Void {
        super();
        styleClasses = new Array<String>();
        style = StyleSheet.newDefaultStyle();
        
        // add our own class to the list of style classes
        var clNames:Array<String>;
        #if flash9
            clNames = Type.getClassName(Type.getClass(this)).split("::");
        #else true
            clNames = Type.getClassName(Type.getClass(this)).split(".");
        #end
        addStyleClass( clNames[ clNames.length-1 ] );
    }

    public function updateClassStyle() :Void {
        var s = StyleSheet.defaultSheet.match( this );
        assignStyle(s);
    }
    
    public function addStyleClass( name:String ) :Void {
        styleClasses.push( name );
        updateClassStyle();
    }
    
    public function removeStyleClass( name:String ) :Void {
        styleClasses.remove( name );
        updateClassStyle();
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
