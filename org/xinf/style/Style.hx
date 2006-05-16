package org.xinf.style;

import org.xinf.value.Value;
import Reflect;

class FloatValue extends Value<Float> {
    public static function create() :ValueBase {
        return( new FloatValue() );
    }
    public static function parseString(s:String) :ValueBase {
        var v = new FloatValue();
        v.set( Std.parseFloat(s) );
        return v;
    }
}
class ColorValue extends Value<Color> {
    public static function create() :ValueBase {
        return( new ColorValue() );
    }
    public static function parseString(s:String) :ValueBase {
        var v = new ColorValue();
        v.set( Color.fromString(s) );
        return v;
    }
}

class PropertyDefinition {
    public var class_proto:Class;
    public var parseString:String->ValueBase;
    
    public function new( cl:Dynamic, parse:String->ValueBase ) :Void {
        class_proto = cl;
        parseString = parse;
    }
    
    public function create(name:String, ctx:PropertySet) :ValueBase { // name is not strictly needed, just for debuggng
        trace("creating property of Class "+name );
        var p:ValueBase;
        try {
            p = untyped class_proto.create();
        } catch(e:Dynamic) {
            throw("Property class for '"+name+"' has no function create():ValueBase");
        }
        return p;
    }
}

    
class Properties {
    public static var definitions:Hash<PropertyDefinition>;
    public static function __init__():Void {
        var defs = new Hash<PropertyDefinition>();

        defs.set( "alpha", new PropertyDefinition( 
                FloatValue, FloatValue.parseString
            ) );
        defs.set( "backgroundColor", new PropertyDefinition( 
                ColorValue, ColorValue.parseString
            ) );
        defs.set( "color", new PropertyDefinition( 
                ColorValue, ColorValue.parseString
            ) );
            
        defs.set( "paddingLeft", new PropertyDefinition( 
                FloatValue, FloatValue.parseString
            ) );
        defs.set( "paddingRight", new PropertyDefinition( 
                FloatValue, FloatValue.parseString
            ) );
        defs.set( "paddingTop", new PropertyDefinition( 
                FloatValue, FloatValue.parseString
            ) );
        defs.set( "paddingBottom", new PropertyDefinition( 
                FloatValue, FloatValue.parseString
            ) );
        
        definitions = defs;
    }
    
    public static function create( name:String, ctx:PropertySet ) : ValueBase {
        var def:PropertyDefinition = definitions.get(name);
        if( def==null ) throw("no PropertyDefinition for '"+name+"'");
        
        var p:ValueBase = def.create(name,ctx);
        return p;
    }

    public static function createFromString( name:String, s:String, ctx:PropertySet ) : ValueBase {
        var def:PropertyDefinition = definitions.get(name);
        if( def==null ) throw("no PropertyDefinition for '"+name+"' (createFromString: "+s+")");
        
        var p:ValueBase = def.parseString(s);
        return p;
    }
}

class PropertySet extends Hash<ValueBase> {
    public function fromString( str:String ) :Void {
        for( _attribute in str.split(";") ) {
            var a = StringTools.trim(_attribute).split(":");
            if( a.length == 2 ) {
                var name = StringTools.trim(a[0]);
                var value = StringTools.trim(a[1]);
                
                var p:ValueBase = Properties.createFromString( name, value, this );
            //    trace("PARSE StyleAttribute "+name+": "+value+" -- "+p );
                this.set( name, p );
            }
        }
    }
    public static function newFromString( str:String ) :PropertySet {
        var v = new PropertySet();
        v.fromString(str);
        return v;
    }
    
    public function getLink( name:String ) :ValueBase {
        var p:ValueBase = get(name);
        if( p == null ) {
            p = Properties.create( name, this ).identity();
            set(name,p);
        }
        return p;
    }
}


class Style extends PropertySet {
    // common style properties are mapped as haxe properties
    public property alpha(dynamic,dynamic):Float;
    public property color(dynamic,dynamic):Color;    
    public property backgroundColor(dynamic,dynamic):Color;    

    public property paddingLeft(dynamic,dynamic):Float;
    public property paddingTop(dynamic,dynamic):Float;
    public property paddingRight(dynamic,dynamic):Float;
    public property paddingBottom(dynamic,dynamic):Float;

    // aggregate properties also
//    public property background(dynamic,dynamic):String;
    
    
    public static function __init__() :Void {
        trace("init Style");
        
        initProperties( Style, [ "alpha", "backgroundColor", "color",
                "paddingLeft", "paddingTop", "paddingRight", "paddingBottom" ] );
    }
    public static function initProperties( cl:Dynamic, props:Array<String> ) :Void {
        var class_proto:Class = cl;
        for( prop_name in props ) {
            var def:PropertyDefinition = Properties.definitions.get(prop_name);
            if( def == null ) throw("no PropertyDefinition for '"+prop_name+"'");
            
            initGetterSetter(class_proto, prop_name, def );
        }        
    }
    public static function initGetterSetter( class_proto:Class, _prop_name:String, _def:PropertyDefinition ) {
        var prop_name = _prop_name;
        Reflect.setField(class_proto.prototype, "get_"+prop_name, function() {
                var othis:PropertySet = untyped this;
                var f:ValueBase = othis.get(prop_name);
                if( f != null ) return f.get();
                return null;
            });
        Reflect.setField(class_proto.prototype, "set_"+prop_name, function(v:Dynamic) {
                var othis:PropertySet = untyped this;
                var f:ValueBase = othis.get(prop_name);
                if( f == null ) {
                    f = Properties.create(prop_name,othis);
                    othis.set(prop_name,f);
                }
                return f.set(v);
            });
    }
}
