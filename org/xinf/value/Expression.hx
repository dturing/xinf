package org.xinf.value;

import org.xinf.event.Event;

// destination:T = f(source:S);
class Expression<T,S> extends Value<T> {
    private var input:Array<Value<S>>;
    private var dirty:Bool;
    
    public function new() {
        super();
        input = new Array<Value<S>>();
        dirty = true;
    }
    
    public function append( v:Value<S> ) :Void {
        dirty = true;
        input.push(v);
        v.addEventListener( "changed", onChildChanged );
    }
    
    private function onChildChanged( e:Event ) :Void {
        dirty = true;
        super.onChildChanged(e);
    }

    public function evaluate() :T {
        throw("not implemented");
        return null;
    }

    public function get_value() :T {
        if( dirty ) {
            _value = evaluate();
            dirty = false;
        }
        return _value;
    }
    
    public function toString() :String {
        var c = Reflect.getClass(this).__name__;
        var name = c[c.length-1];
        return("("+name+input+"="+get_value()+")");
    }
}

class Add extends Expression<Float,Float> {
    public function new( a:Value<Float>, b:Value<Float> ) {
        super();
        append(a);
        append(b);
    }
    
    public function evaluate() :Float {
        var r:Float = 0;
        for( variable in input ) {
            r += variable.value;
        }
        return r;
    }
}

class Sum extends Expression<Float,Float> {
    public function new( a:Array<Value<Float>> ) {
        super();
        for( v in a ) {
            append(v);
        }
    }
    
    public function evaluate() :Float {
        var r:Float = 0;
        for( variable in input ) {
            r += variable.value;
        }
        return r;
    }
}

class Subtract extends Expression<Float,Float> {
    public function new( a:Value<Float>, b:Value<Float> ) {
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



