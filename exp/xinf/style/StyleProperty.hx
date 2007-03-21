package xinf.style;

interface StyleProperty {
    function parse( s:String ) :Void;
}

class TypedStyleProperty<T> implements StyleProperty {
    var value:T;

    public function new() :Void {
    }
    
    public function parse( s:String ) :Void {
        throw("unimplemented");
    }
    
    public function get() :T {
        return value;
    }
    
    public function set( v:T ) :T {
        value = v;
        return value;
    }
}

class StringProperty extends TypedStyleProperty<String> {
    public function parse( s:String ) :Void {
        value = StringTools.trim(s);
    }
}

class FloatProperty extends TypedStyleProperty<Float> {
    public function parse( s:String ) :Void {
        value = Std.parse(s);
    }
}
