
package xinf.style;

class StyleCascade extends Style {
    public var styles:Array<Style>;

    public function new( s:Iterable<Style> ) {
        super();
        styles=Lambda.array(s);
		styles.reverse();
    }

    override public function getProperty<T>( name:String, cl:Dynamic ) :T {
        for( style in styles ) {
            var v = style.getProperty(name,cl);
            if( v!=null ) return v;
        }
        
        return getDefault(name);
    }
	
	override public function toString() :String {
		var r = " [";
		for( style in styles ) {
			r += style.toString()+"\n";
		}
		r+="]";
		return r;
	}
}