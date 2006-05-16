package org.xinf.style;

import org.xinf.style.UnitValue;
import org.xinf.value.Value;
import org.xinf.value.Expression;

class Style {

    private var values :Hash<Dynamic>;

//    public property color(default,null):Link<Color>;
    
    public property color(get_color,set_color):Color;
    public property background(get_background,set_background):Color;
    public property border(get_border,set_border):Border;
    public property padding(get_padding,set_padding):Pad;
    public property margin(get_margin,set_margin):Pad;

    public property x(get_x,set_x):Dynamic;
    public property y(get_y,set_y):Dynamic;
    public property width(get_width,set_width):Dynamic;
    public property height(get_height,set_height):Dynamic;
    
    public property verticalAlign(get_vertical_align,set_vertical_align):Dynamic;
    public property textAlign(get_text_align,set_text_align):Dynamic;

    public function new() :Void {
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
    }
        
    public function get_color() :Color {
        return cast(_lookup( "color" ),Color);
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
        var n = _set( "x", UnitValue, v );
        return( n );
    }
    private function _set( name:String, kl:Dynamic, v:Dynamic ) :Dynamic {
        var value = values.get(name); // dont use _lookup here! we want to create a new one if we dont have the property ourselves
        var r:Dynamic = kl.fromDynamic(v);
        if( !value ) {
            value = new Identity<Float>(r);
            values.set(name,value);
        } else
            value.set(r);
            
//        value.changed();
        return r;
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
        var n = _set( "width", UnitValue, v );
        return( n );
        /*
        var c = UnitValue.fromDynamic(v);
        values.set( "width", c );
        return c;
        */
    }
    public function get_height() :UnitValue {
        return _lookup( "height" );
    }
    public function set_height( v:Dynamic ) :UnitValue {
        var c = UnitValue.fromDynamic(v);
        values.set( "height", c );
        return c;
    }

    public function get_text_align() :Alignment {
        return _lookup( "text-align" );
    }
    public function set_text_align( v:Dynamic ) :Alignment {
        var c = Alignment.fromDynamic(v);
        values.set( "text-align", c );
        return c;
    }
    public function get_vertical_align() :Alignment {
        return _lookup( "vertical-align" );
    }
    public function set_vertical_align( v:Dynamic ) :Alignment {
        var c = Alignment.fromDynamic(v);
        values.set( "vertical-align", c );
        return c;
    }
    
    
    public function _lookup( attr:String ) :Dynamic {
        return( values.get(attr) );
    }
        
    public function fromString( str:String ) :Void {
        for( _attribute in str.split(";") ) {
            var a = StringTools.trim(_attribute).split(":");
            if( a.length == 2 ) {
                var name = StringTools.trim(a[0]);
                var value = StringTools.trim(a[1]);
                var setter = Reflect.field( this, "set_"+StringTools.replace(name,"-","_") );
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
        var r:String="";
        if( values==null ) return "NULL Style";
        for( f in values.keys() ) {
            var field = values.get(f);
            r += "" + f + ": "+field+"; ";
        }
        return r;
    }
    
    public static function newFromString( str:String ) :Style {
        var v = new Style();
        v.fromString(str);
        return v;
    }

    public function clone() :Dynamic {
        var s:Style = newFromString( this.toString() ); // FIXME
        return s;
    }
    
    public function setInnerSize( w:Float, h:Float ) : Void {
        var b:Border = border;
        var p:Pad = padding;
        width = w + b.horizontal() + p.horizontal();
        height = h + b.vertical() + p.vertical();
    }
    public function getOuterSize() :{ w:Float, h:Float } {
        var b:Border = border;
        var p:Pad = padding;
        return( { w:width-(b.horizontal()+p.horizontal()),
                  h:height-(b.vertical()+p.vertical()) } );
    }

    public static var DEFAULT:Style = newFromString("background: #eee; color: #000; border: 1px solid #000; padding: 3px; margin: 5px; x:0px; y:0px; width:20px; height:20px; vertical-align:left; text-align:left;");
    
}
