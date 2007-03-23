package xinf.style;

class StyleClassElement extends StyleElement {
    
    private var styleClasses :Hash<Bool>;
    
    public function new() :Void {
        super();
        styleClasses = new Hash<Bool>();
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
        styleClasses.set( name, true );
        updateClassStyle();
    }
    
    public function removeStyleClass( name:String ) :Void {
        styleClasses.remove( name );
        updateClassStyle();
    }
    
    public function hasStyleClass( name:String ) :Bool {
        return styleClasses.get(name);
    }

    public function getStyleClasses() :Iterator<String> {
        return styleClasses.keys();
    }
    
}
