
package xinf.style;

class InheritedStyle extends MatchStyle {
    override public function getInheritedProperty<T>( name:String, cl:Dynamic ) :T {
        var v:Dynamic = super.getInheritedProperty(name,cl);
        if( v!=null ) return v;
        
        // FIXME: register for style change? but where to unregister?
		if( element!=null ) {
			var p = element.getParentStyle();
			if( p!=null ) return p.getInheritedProperty(name,cl);
		}
		
        return null; //getDefault(name);
    }
}