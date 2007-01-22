
package xinf.value;

class Value {
    public static var UNSET:Float = null;
    
    public var value(getValue,setValue):Float;
    
    public function getValue() :Float {
        return null;
    }
    public function setValue( v:Float ) :Float {
        return null;
    }
    public function toString() :String {
        return( "GenericValue of class "+Type.getClassName(Type.getClass(this)) );
    }
    public function set( ?v:Value ) :Void {
        throw("cannot set() a Value, must be a Slot");
        return;
    }
    
    
    var clients:List<Value>;
    public function addClient( l:Value ) :Void {
        if( clients==null ) clients = new List<Value>();
        if( l==null ) throw("refusing to add null client");
        clients.add(l);
    }
    public function removeClient( l:Value ) :Bool {
        if( clients==null ) return false;
        return clients.remove(l);
    }
    public function updateClients( ?newValue:Float, ?oldValue:Float ) :Void {
        if( clients==null ) return;
//        trace("update clients of "+this+": "+clients );
        for( c in clients ) {
            c.operandChanged( this, newValue, oldValue );
        }
    }
    public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        // do nothing here. children, override!
    }
    
    
    public static function sum( a:Value, b:Value ) :Expression {
        return new Sum(a,b);
    }
    public static function max( ?a:Value, ?b:Value ) :Expression {
        return new Max(a,b);
    }
    public static function minus( a:Value ) :Value {
        return new Negative(a);
    }
    public static function scale( f:Float, a:Value ) :Value {
        return new Scale(f,a);
    }
    public static function constant( a:Float ) :Value {
        return new SimpleValue(a);
    }
}

class SimpleValue extends Value {
    var _v:Float;
    public function new( ?v:Float ) :Void {
        _v=v;
    }
    public function getValue() :Float {
        return _v;
    }
    public function setValue( v:Float ) :Float {
        if( v!=_v ) updateClients( v, _v );
        return _v=v;
    }
    public function set( ?v:Value ) :Void {
        throw("cannot set() a SimpleValue, must be a Slot");
        if(v!=null) setValue( v.value );
    }
    public function toString() :String {
        return( "("+_v+")" );
    }
}

class Slot extends Value {
    var _v:Value;
    public function new( ?v:Value ) :Void {
        _v=v;
        if( _v!=null ) _v.addClient( this );
    }
    public function getValue() :Float {
        if( _v==null ) throw("unset Slot: "+this);
        return _v.getValue();
    }
    public function setValue( v:Float ) :Float {
        if( _v==null ) throw("unset Slot: "+this);
        return _v.setValue(v);
    }
    public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        updateClients( newValue, oldValue );
    }
    public function set( ?v:Value ) :Void {
//        trace("set "+this+" to < "+v );
        if( v!=_v ) {
            if( _v!=null ) _v.removeClient( this );
            _v = v;
            if( _v!=null ) _v.addClient( this );
//            if( v!=null ) updateClients( v.value ); //if( _v!=null ) operandChanged( v );
        }
    }
    public function toString() :String {
        return( "<"+_v );
    }
}

class Link extends Value {
    var _v:Value;
    public function new( ?v:Value ) :Void {
        _v=v;
        if( _v!=null ) addClient( _v );
    }
    public function getValue() :Float {
        if( _v==null ) throw("unset Link: "+this);
        return _v.getValue();
    }
    public function setValue( v:Float ) :Float {
        if( _v==null ) throw("unset Link: "+this);
        return _v.setValue(v);
    }
    public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        updateClients( newValue, oldValue );
    }
    public function set( ?v:Value ) :Void {
        trace("set "+this+" to > "+v );
        if( v!=_v ) {
            if( _v!=null ) removeClient( _v );
            _v = v;
            if( _v!=null ) addClient( _v );
        }
    }
    public function toString() :String {
        return( ">"+_v );
    }
}

class Negative extends Slot {
    public function new( ?v:Value ) :Void {
        super(v);
    }
    public function getValue() :Float {
        return -super.getValue();
    }
    public function setValue( v:Float ) :Float {
        return -super.setValue( -v );
    }
}

class Scale extends Slot {
    var factor:Float;
    
    public function new( f:Float, ?v:Value ) :Void {
        factor=f;
        super(v);
    }
    public function getValue() :Float {
        return factor * super.getValue();
    }
    public function setValue( v:Float ) :Float {
        return factor * super.setValue( v/factor );
    }
}

class Terminal extends Slot {
    var f:Float->Void;
    public function new( f:Float->Void, ?v:Value ) {
        super(v);
        this.f=f;
    }
    public function setValue( v:Float ) :Float {
        f( v );
        return super.setValue(v);
    }
}

class Expression extends SimpleValue {
    var operands:List<Value>;
    
    public function new( ?o:Value, ?p:Value ) {
        super();
        operands = new List<Value>();
        if( o!=null ) {
            operands.add(o);
            o.addClient(this);
        }
        if( p!=null ) {
            operands.add(p);
            p.addClient(this);
        }
    }
    
    function recalc() :Float {
        return null;
    }
    override public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        _v = null;
        updateClients();
    }

    public function getValue() :Float {
        if( _v==null ) _v = recalc();
        return _v;
    }
    public function addOperand( o:Value ) {
        operands.add(o);
        o.addClient(this);
        _v = null; // causes recalc
        updateClients();
    }
    public function toString() :String {
        var name = Type.getClassName( Type.getClass(this) ).split(".").pop();
        var r = name+"( ";
            var o = operands.iterator();
            while( o.hasNext() ) {
                r += o.next().toString();
                if( o.hasNext() ) r+=", ";
            }
        r+=" ):"+value+"";
        return r;
    }
}

class Sum extends Expression {
    override function recalc() :Float {
        var sum=0.0;
        for( o in operands ) {
            sum += o.value;
        }
//    trace("---------recalc "+this+":"+sum );
    //    setValue(sum);
        return sum;
    }
    /*
    override public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        if( newValue!=null && oldValue!=null && _v!=null ) {
//            trace(""+this+" changed by "+(newValue-oldValue) );
            setValue( _v + (newValue-oldValue) );
        } else {
//            trace(""+this+" changed absolutely" );
            super.operandChanged(d,newValue,oldValue);
        }
    }
    */
}

class Max extends Expression {
    override function recalc() :Float {
        var max=0.0;
        for( o in operands ) {
            max = Math.max( o.value, max );
        }
        return max;
    }
    /*
    override public function operandChanged( d:Value, ?newValue:Float, ?oldValue:Float ) :Void {
        if( newValue!=null && _v!=null && newValue > _v ) {
//            trace(""+this+" changed to new max "+_v );
            setValue( newValue );
        } else {
//            trace(""+this+" changed absolutely" );
            super.operandChanged(d,newValue,oldValue);
        }
    }
    */
}
