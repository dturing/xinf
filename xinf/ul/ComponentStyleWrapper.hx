package xinf.ul;
import xinf.style.Style;

class ComponentStyleWrapper extends ComponentStyle {

	var wrapped:Style;

	public function new( style:Style ) {
		super();
		wrapped = style;
	}
	
    override public function getProperty<T>( name:String, cl:Dynamic ) :T {
		return wrapped.getProperty(name,cl);
	}

    override public function getInheritedProperty<T>( name:String, cl:Dynamic ) :T {
		var r:T = wrapped.getInheritedProperty(name,cl);
		if( r!=null ) return r;
		return getDefault(name);
	}
		
	override public function toString() :String {
		return("ComponentStyleWrapper("+wrapped+")");
	}
	
}
