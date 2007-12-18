/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.layout;

class Spring {
    public static var UNSET:Null<Float> = null;
    public static var MAX:Float = 1073741824;
    
    public function getMin() :Float  { return UNSET; }
    public function getPref() :Float { return UNSET; }
    public function getMax() :Float  { return UNSET; }
    public function getValue() :Float  { return UNSET; }
    public function setValue(v:Float) :Float  { return UNSET; }

    private function new() :Void {
    }
    
    public static function constant( min:Float, ?pref:Null<Float>, ?max:Null<Float> ) :Spring {
        if( pref==null ) pref=min;
        if( max==null ) max=pref;
        return new ConstantSpring( min, pref, max );
    }

    public static function max( a:Spring, b:Spring ) :Spring {
        return new MaxSpring(a,b);
    }
    
    public static function minus( s:Spring ) :Spring {
        return new MinusSpring(s);
    }
    private static function _minus( v:Float ) :Float {
        return -v;
    }
    
    public static function sum( a:Spring, b:Spring ) :Spring {
        return new SumSpring(a,b);
    }
    private static function _sum( a:Float, b:Float ) :Float {
        return a+b;
    }

    public function toString() :String {
        return("UndescribedSpring");
    }
}

class SimpleSpring extends Spring {
    var _value:Float;
    public function new() :Void {
        super();
        _value=Spring.UNSET;
    }
    override public function getValue() :Float {
        if( _value == Spring.UNSET ) _value = getPref();
        return _value;
    }
    override public function setValue( v:Float ) :Float {
        //v = Math.min(v,getMax());
        //v = Math.max(v,getMin());
        _value = v;
        return v;
    }
}

class ConstantSpring extends SimpleSpring {
    var _min:Float;
    var _pref:Float;
    var _max:Float;
    public function new( min:Float, pref:Float, max:Float ) :Void { 
        super();
        _min=min;
        _pref=pref;
        _max=max;
    }
    override public function getMin() :Float {
        return _min;
    }
    override public function getPref() :Float {
        return _pref;
    }
    override public function getMax() :Float {
        return _max;
    }
    override public function toString() :String {
        var s=if( _value==Spring.UNSET ) "" else ":"+_value;
        if( _min==_pref && _min==_max ) 
            return("const"+_pref+s);
        return("Const("+_min+","+_pref+","+_max+s+")");
    }
}

class UnarySpring extends SimpleSpring {
    var f:Float->Float;
    var s:Spring;
    
    public function new( s:Spring, f:Float->Float ) {
        super();
        this.f=f;
        this.s=s;
    }
    override public function getMin() :Float {
        return f(s.getMin());
    }
    override public function getPref() :Float {
        return f(s.getPref());
    }
    override public function getMax() :Float {
        return f(s.getMax());
    }
    override public function toString() :String {
        var fs="Unary";
        if( f==Spring._minus ) fs="-";
        return(fs+"("+s+")");
    }
}

class MinusSpring extends UnarySpring {
    public function new( s:Spring ) {
        super( s, MinusSpring.f );
    }
    public static function f( v:Float ) :Float {
        return -v;
    }
    override public function toString() :String {
        return("-"+s);
    }
}

class BinarySpring extends SimpleSpring {
    var f:Float->Float->Float;
    var a:Spring;
    var b:Spring;
    
    public function new( a:Spring, b:Spring, f:Float->Float->Float ) {
        super();
        this.f=f;
        this.a=a;
        this.b=b;
    }
    override public function getMin() :Float {
        return f(a.getMin(),b.getMin());
    }
    override public function getPref() :Float {
        return f(a.getPref(),b.getPref());
    }
    override public function getMax() :Float {
        return f(a.getMax(),b.getMax());
    }
    override public function toString() :String {
        return("Binary("+a+","+b+")");
    }
}

class SumSpring extends BinarySpring {
    public function new( a:Spring, b:Spring ) {
        super( a, b, SumSpring.f );
    }
    public static function f( a:Float, b:Float ) :Float {
        return a+b;
    }
    override public function toString() :String {
        return("sum( "+a+", "+b+" )");
    }
}

class MaxSpring extends BinarySpring {
    public function new( a:Spring, b:Spring ) {
        super( a, b, MaxSpring.f );
    }
    public static function f( a:Float, b:Float ) {
        return Math.max(a,b);
    }
    override public function toString() :String {
        return("max( "+a+", "+b+" )");
    }
}
