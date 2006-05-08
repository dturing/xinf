package xinfony.style;

import xinfony.style.UnitValue;

class Style {

    private var values :Hash<Dynamic>;

    public property color(get_color,set_color):Color;
    public property background(get_background,set_background):Color;
    public property border(get_border,set_border):Border;
    public property padding(get_padding,set_padding):Pad;
    public property margin(get_margin,set_margin):Pad;

    public property x(get_x,set_x):Dynamic;
    public property y(get_y,set_y):Dynamic;
    public property width(get_width,set_width):Dynamic;
    public property height(get_height,set_height):Dynamic;
    
    public function new( str:String ) {
        values = new Hash<Dynamic>();
/*        
        set_color( Color.rgb(0,0,0) );
        set_background( Color.rgb(0xff,0xff,0xff) );
        set_border( new Border( new UnitValue(1.,Unit.px), "solid", Color.rgb(0,0,0) ) );
        set_padding( new Pad( new UnitValue(0.,Unit.px), new UnitValue(0.,px), new UnitValue(0.,px), new UnitValue(0.,px) ) );
        set_margin( new Pad( new UnitValue(0.,Unit.px), new UnitValue(0.,px), new UnitValue(0.,px), new UnitValue(0.,px) ) );
        set_x( new UnitValue(0.,px) );
        set_y( new UnitValue(0.,px) );
        set_width( new UnitValue(0.,px) );
        set_height( new UnitValue(0.,px) );
*/        
        setFromString( StringTools.trim(str) );
    }

    public function clone() :Dynamic {
        var s:Style = new Style( this.toString() );
        return s;
    }
    
    public function get_color() :Color {
        return _lookup( "color" );
    }
    public function set_color( v:Dynamic ) :Color {
        var c = Color.fromDynamic(v);
        values.set( "color", c );
        return c;
    }
    public function get_background() :Color {
        return _lookup( "background" );
    }
    public function set_background( v:Dynamic ) :Color {
        var c = Color.fromDynamic(v);
        values.set( "background", c );
        return c;
    }
    public function get_border() :Border {
        return _lookup( "border" );
    }
    public function set_border( v:Dynamic ) :Border {
        var c = Border.fromDynamic(v);
        values.set( "border", c );
        return c;
    }
    public function get_padding() :Pad {
        return _lookup( "padding" );
    }
    public function set_padding( v:Dynamic ) :Pad {
        var c = Pad.fromDynamic(v);
        values.set( "padding", c );
        return c;
    }
    public function get_margin() :Pad {
        return _lookup( "margin" );
    }
    public function set_margin( v:Dynamic ) :Pad {
        var c = Pad.fromDynamic(v);
        values.set( "margin", c );
        return c;
    }

    public function get_x() :UnitValue {
        return _lookup( "x" );
    }
    public function set_x( v:Dynamic ) :UnitValue {
        var c = UnitValue.fromDynamic(v);
        values.set( "x", c );
        return c;
    }
    public function get_y() :UnitValue {
        return _lookup( "y" );
    }
    public function set_y( v:Dynamic ) :UnitValue {
        var c = UnitValue.fromDynamic(v);
        values.set( "y", c );
        return c;
    }
    public function get_width() :UnitValue {
        return _lookup( "width" );
    }
    public function set_width( v:Dynamic ) :UnitValue {
        var c = UnitValue.fromDynamic(v);
        values.set( "width", c );
        return c;
    }
    public function get_height() :UnitValue {
        return _lookup( "height" );
    }
    public function set_height( v:Dynamic ) :UnitValue {
        var c = UnitValue.fromDynamic(v);
        values.set( "height", c );
        return c;
    }
    
    
    public function _lookup( attr:String ) : Dynamic {
        // TODO: lookup in style chain.
        var r = values.get(attr);
        return( r );
    }
    
    
    public function setFromString( str:String ) :Void {
        for( _attribute in str.split(";") ) {
            var a = StringTools.trim(_attribute).split(":");
            if( a.length == 2 ) {
                var name = StringTools.trim(a[0]);
                var value = StringTools.trim(a[1]);
                var setter = Reflect.field( this, "set_"+name );
                if( !setter ) {
                    trace("Unknown style attribute: "+name+" (ignored)" );
                } else {
              //      trace("Set style attr "+name+": "+value );
                    Reflect.callMethod( this, setter, [ value ] );
                }
            }
        }
    }
    
    public function toString() :String {
        var r:String="\n";
        for( f in values.keys() ) {
            var field = values.get(f);
            r += "\t" + f + ": "+field+";\n";
        }
        return r;
    }

    public static var DEFAULT = new Style("background: #eee; color: #000; border: 1px solid #000; padding: 2px; margin: 2px; x:0px; y:0px; width:20px; height:20px;");
    public static var INVERSE = new Style("background: #000; color: #fff; border: 1px solid #fff;");
    public static var HILITE = new Style("background: #cce; color: #039; border: 1px solid #039;");
}
