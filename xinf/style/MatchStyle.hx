
package xinf.style;

class MatchStyle extends Style {
    var element:Stylable;
    var matchedStyle:Style;
    
    public function new( e:xinf.style.Stylable ) {
        super();
        element=e;
    // TODO    e.document.styleSheet.addEventListener( StyleEvent.STYLESHEET_CHANGED, rematch );
        rematch();
    }
    
    public function rematch() {
  //      matchedStyle = element.document.styleSheet.matchStyle(element);
    }

    override public function getProperty<T>( name:String, cl:Dynamic ) :T {
        var v:Dynamic = super.getProperty(name,cl);
        if( Std.is( v, cl ) ) return v;
        if( matchedStyle!=null ) return matchedStyle.getProperty( name, cl );
        return null;
    }

    override public function setProperty<T>( name:String, value:T ) :T {
        super.setProperty(name,value);
        if( element!=null ) element.styleChanged();
        return value;
    }
}

