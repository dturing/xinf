package org.xinf.value;

import org.xinf.event.Event;

class Expression extends Value {
    private var input:Array<Value>;
    private var dirty:Bool;
    
    public function new() {
        super(null);
        input = new Array<Value>();
        dirty = true;
    }
    
    public function append( v:Value ) :Void {
        dirty = true;
        input.push(v);
        v.addEventListener( Event.CHANGED, childChanged );
    }
    
    private function childChanged( e:Event ) :Void {
        dirty = true;
        trace("Expression changed: "+this );
        changed();
    }

    public function evaluate() :Float {
        throw("not implemented");
        return null;
    }

    public function get_value() :Float {
        if( dirty ) {
            _value = evaluate();
            dirty = false;
        }
        return _value;
    }
    
    public function toString() :String {
        var c = Reflect.getClass(this).__name__;
        var name = c[c.length-1];
        return("("+name+input+" = "+get_value()+")");
    }
}

class Identity extends Expression {
    public function new( a:Value ) {
        super();
        append(a);
    }

    public function set_value( v:Float ) :Float {
        throw("Identity values can not be set.");
        return _value;
    }

    public function evaluate() :Float {
        return( input[0].value );
    }
    
    public function set( a:Value ) :Void {
        input[0] = a;
        changed();
    }
}

class Add extends Expression {
    public function new( a:Value, b:Value ) {
        super();
        append(a);
        append(b);
    }
    
    public function evaluate() :Float {
        var r:Float = .0;
        for( variable in input ) {
            r += variable.value;
        }
        return r;
    }
}

class Subtract extends Expression {
    public function new( a:Value, b:Value ) {
        super();
        append(a);
        append(b);
    }
    
    public function evaluate() :Float {
        var r:Float = input[0].value;
        for( i in 1...input.length ) {
            r -= input[i].value;
        }
        return r;
    }
}



