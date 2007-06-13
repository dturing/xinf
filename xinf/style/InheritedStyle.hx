
package xinf.style;

class InheritedStyle extends MatchStyle {
    override public function getProperty<T>( name:String, cl:Class<T> ) :T {
        var v:Dynamic = super.getProperty(name,cl);
        if( v!=null ) return v;
        
        if( element.parent!=null ) return element.parent.style.getProperty(name,cl);
        return null;
    }
}