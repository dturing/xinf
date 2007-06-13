
package xinf.style;

import xinf.ony.Element;

class MatchStyle extends Style {
    var element:Element;
    var matchedStyle:Style;
    
    public function new( e:Element ) {
        super();
        element=e;
    // TODO    e.document.styleSheet.addEventListener( StyleEvent.STYLESHEET_CHANGED, rematch );
        rematch();
    }
    
    public function rematch() {
  //      matchedStyle = element.document.styleSheet.matchStyle(element);
    }

    override public function getProperty<T>( name:String, cl:Class<T> ) :T {
        var v:Dynamic = super.getProperty(name,cl);
        if( Std.is( v, cl ) ) return v;
        if( matchedStyle!=null ) return matchedStyle.getProperty( name, cl );
        return null;
    }
}

