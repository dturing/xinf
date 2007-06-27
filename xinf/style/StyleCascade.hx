
package xinf.style;

class StyleCascade extends Style {
    public var styles:Iterable<Style>;

    public function new( s:Iterable<Style> ) {
        super();
        styles=s;
    }

    override public function getProperty<T>( name:String, cl:Dynamic ) :T {
        for( style in styles ) {
            v = style.getProperty(name,cl);
            if( v!=null ) return v;
        }
        
        return null;
    }
}