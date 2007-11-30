
package xinf.style;

typedef StyleRule<S:Style> = {
    var selector:Selector;
    var style:S;
}


class StyleSheet<S:Style> {

	private var rules :Array<StyleRule<S>>;
    private var wrap :Style->S;
	
    public function new( wrap:Style->S, ?d:Iterable<StyleRule<S>> ) :Void {
        rules = new Array<StyleRule<S>>();
		this.wrap = wrap;
		if( d!=null ) {
			for( r in d ) add( r );
		}
    }
	
    public function add( rule:StyleRule<S> ) {
		rules.push( rule );
    }
	
    public function match( e:Stylable ) :S {
		var a = new Array<S>();
		
		for( rule in rules ) {
			if( e.matchSelector( rule.selector ) ) {
				a.push( rule.style );
			}
		}
        return wrap( new StyleCascade( untyped a ) ); // FIXME
    }
	
}
