package org.xinf.style;

import org.xinf.value.Value;
import Reflect;

class SimpleProperty<T> extends Value<T> {
    public static function initGetterSetter( property_class:Class, class_proto:Class, _prop_name:String ) :Void {
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
                    f = Properties.create(prop_name);
                    othis.set(prop_name,f);
                }
                return f.set(v);
            });
    }
}

class FloatProperty extends SimpleProperty<Float> {
    public static function create() :ValueBase {
        return( new FloatProperty() );
    }
    public static function setFromString( name:String, s:String, ctx:PropertySet, cl:Class ) :Void {
        var v = new FloatProperty();
        v.set( Std.parseFloat(s) );
        ctx.set(name,v);
    }
}
class ColorProperty extends SimpleProperty<Color> {
    public static function create() :ValueBase {
        return( new ColorProperty() );
    }
    public static function setFromString( name:String, s:String, ctx:PropertySet, cl:Class ) :Void {
        var v = new ColorProperty();
        v.set( Color.fromString(s) );
        ctx.set(name,v);
    }
}

class AggregateProperty {
    public static function initGetterSetter( property_class:Class, class_proto:Class, _prop_name:String ) :Void {
        var prop_name = _prop_name;
        var get = untyped property_class._get;
        var set = untyped property_class._set;
        Reflect.setField(class_proto.prototype, "get_"+prop_name, function() {
                var othis:PropertySet = untyped this;
                return get( prop_name, othis );
            });
        Reflect.setField(class_proto.prototype, "set_"+prop_name, function(v:String) {
                var othis:PropertySet = untyped this;
                set( prop_name, v, othis );
                return v;
            });
    }
    
    public static function setFromString( name:String, s:String, ctx:PropertySet, cl:Class ) :Void {
        var setter:Dynamic = untyped cl._set;
        if( setter == null ) throw( cl.__name__.join(".")+" has no _set function");
        setter(name,s,ctx);
    }
}

class RectangleAggregateProperty extends AggregateProperty {
    public static function _get( name:String, ctx:PropertySet ) :String {
        var buf:String = "";
        buf += ctx.get(name+"Top").get()+" ";
        buf += ctx.get(name+"Right").get()+" ";
        buf += ctx.get(name+"Bottom").get()+" ";
        buf += ctx.get(name+"Left").get()+"";
        return buf;
    }
    public static function _set( name:String, s:String, ctx:PropertySet ) :Void {
        var a = s.split(" "); // FIXME: tokenize!
        var trbl:Array<String> = new Array<String>();
        if( a.length == 4 ) {
            trbl = a;
        } else if( a.length == 1 ) {
            for( i in 0...4 ) trbl[i] = a[0];
        // TODO: length 2 and 3 are also valid CSS.
        } else {
            throw("cannot parse RectangleAggregateProperty '"+name+"' from '"+s+"'." );
        }
        
        Properties.setFromString(name+"Top",trbl[0],ctx);
        Properties.setFromString(name+"Right",trbl[1],ctx);
        Properties.setFromString(name+"Bottom",trbl[2],ctx);
        Properties.setFromString(name+"Left",trbl[3],ctx);
    }
}

class PropertyDefinition {
    public var class_proto:Class;
    
    public function new( cl:Dynamic ) :Void {
        class_proto = cl;
    }
    
    private function findClassStaticFunction( name ) :Dynamic {
        var cl:Class = class_proto;
        var f:Dynamic;
        while( cl != null ) {
            f = Reflect.field( cl, name );
            if( f != null ) return f;
            cl = cl.__super__;
        }
        if( cl == null ) throw("Property class '"+class_proto.__name__.join(".")+"' has no function '"+name+"'");
        return cl;
    }
    
    public function setFromString( name:String, s:String, ctx:PropertySet ) :Void {
        var f = findClassStaticFunction("setFromString");
        f(name,s,ctx,class_proto);
    }
    
    public function create() :ValueBase {
        var f = findClassStaticFunction("create");
        return f();
    }

    public function initGetterSetter( into_class:Class, prop_name:String ) :Void {
        var f = findClassStaticFunction("initGetterSetter");
        f(class_proto,into_class,prop_name);
    }
}

    
class Properties {
    public static var definitions:Hash<PropertyDefinition>;
    public static function __init__():Void {
        var defs = new Hash<PropertyDefinition>();

        defs.set( "width", new PropertyDefinition( 
                FloatProperty
            ) );
        defs.set( "height", new PropertyDefinition( 
                FloatProperty
            ) );

        defs.set( "alpha", new PropertyDefinition( 
                FloatProperty
            ) );
        defs.set( "backgroundColor", new PropertyDefinition( 
                ColorProperty
            ) );
        defs.set( "color", new PropertyDefinition( 
                ColorProperty
            ) );
            
        defs.set( "paddingLeft", new PropertyDefinition( 
                FloatProperty
            ) );
        defs.set( "paddingRight", new PropertyDefinition( 
                FloatProperty
            ) );
        defs.set( "paddingTop", new PropertyDefinition( 
                FloatProperty
            ) );
        defs.set( "paddingBottom", new PropertyDefinition( 
                FloatProperty
            ) );

        defs.set( "padding", new PropertyDefinition( 
                RectangleAggregateProperty
            ) );
        
        definitions = defs;
    }
    
    public static function create( name:String ) : ValueBase {
        var def:PropertyDefinition = definitions.get(name);
        if( def==null ) throw("no PropertyDefinition for '"+name+"'");
        
        var p:ValueBase = def.create();
        return p;
    }
    
    public static function convertPropertyName( name:String ) :String {
        var a:Array<String> = name.split("-");
        var r:String = a[0];
        for( i in 1...a.length ) {
            r+=a[i].substr(0,1).toUpperCase();
            r+=a[i].substr(1,a[i].length);
        }
        return r;
    }
    
    public static function setFromString( name:String, s:String, ctx:PropertySet ) :Void {
        var def:PropertyDefinition = definitions.get(name);
        if( def==null ) throw("no PropertyDefinition for '"+name+"' (createFromString: "+s+")");
        def.setFromString( name, s, ctx );
    }
}

class PropertySet {
    private var properties :Hash<ValueBase>;

    public function new() :Void {
        properties = new Hash<ValueBase>();
    }
    
    public function get( name:String ) :ValueBase {
        return( properties.get(name) );
    }
    public function set( name:String, value:ValueBase ) :Void {
        properties.set(name,value);
    }
    public function keys() :Iterator<String> {
        return( properties.keys() );
    }
    
    public function fromString( str:String ) :Void {
        for( _attribute in str.split(";") ) {
            var a = StringTools.trim(_attribute).split(":");
            if( a.length == 2 ) {
                var name = Properties.convertPropertyName(StringTools.trim(a[0]));
                var value = StringTools.trim(a[1]);
                
                Properties.setFromString( name, value, this );
            }
        }
    }
    public static function newFromString( str:String ) :PropertySet {
        var v:PropertySet = new PropertySet();
        v.fromString(str);
        return v;
    }
    
    public function getLink( name:String ) :Dynamic {
        var p:ValueBase = get(name);
        if( p == null ) {
            p = Properties.create( name );
            if( p == null ) throw("Property '"+name+"' cannot be linked.");
            set(name,p.identity());
        }
        return p;
    }
}


class Style extends PropertySet {
    // common style properties are mapped as haxe properties
    public property height(dynamic,dynamic):Float;
    public property width(dynamic,dynamic):Float;

    public property alpha(dynamic,dynamic):Float;
    public property color(dynamic,dynamic):Color;    
    public property backgroundColor(dynamic,dynamic):Color;    

    public property paddingLeft(dynamic,dynamic):Float;
    public property paddingTop(dynamic,dynamic):Float;
    public property paddingRight(dynamic,dynamic):Float;
    public property paddingBottom(dynamic,dynamic):Float;

    // aggregate properties also
    public property padding(dynamic,dynamic):String;
//    public property background(dynamic,dynamic):String;
    
    
    public static function __init__() :Void {
        trace("init Style");
        
        initProperties( Style, Properties.definitions.keys() );
    }
    public static function initProperties( cl:Dynamic, props:Iterator<String> ) :Void {
        var class_proto:Class = cl;
        for( prop_name in props ) {
            var def:PropertyDefinition = Properties.definitions.get(prop_name);
            if( def == null ) throw("no PropertyDefinition for '"+prop_name+"'");
            
            def.initGetterSetter( class_proto, prop_name );
        }        
    }
}
