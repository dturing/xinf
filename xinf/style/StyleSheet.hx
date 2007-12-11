
package xinf.style;

typedef StyleRule = {
    var selector:Selector;
    var style:Dynamic;
}


class StyleSheet {

	private var rules :Array<StyleRule>;
	
    public function new( ?d:Iterable<StyleRule> ) :Void {
        rules = new Array<StyleRule>();
		if( d!=null ) {
			for( r in d ) add( r );
		}
    }
	
    public function add( rule:StyleRule ) {
		rules.push( rule );
    }
/*	
    public function match( e:Stylable ) :Dynamic {
		var a = new Array<Dynamic>();
		
		for( rule in rules ) {
			if( e.matchSelector( rule.selector ) ) {
				a.push( rule.style );
			}
		}
        return a[0]; // FIXME
    }
	*/
}
