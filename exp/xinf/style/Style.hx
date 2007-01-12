package xinf.style;

import xinf.erno.Color;

typedef Sides<T> = {
    var l:T;
    var t:T;
    var r:T;
    var b:T;
}

class Style {
    
    public var padding :Sides<Float>;
    public var border :Sides<Float>;
    public var background :Color;
    public var color :Color;
    
    private var params:Hash<Dynamic>;
    
    public function new() :Void {
        params = new Hash<Dynamic>();
    }
    
    public function get( param:String, ?def:Dynamic ) :Dynamic {
        var r = params.get(param);
        if( r==null ) r = def;
        return r;
    }
    
    public function set( param:String, value:Dynamic ) :Void {
        params.set(param,value);
        if( value==null ) return;
        try {
            Reflect.setField(this,param,value);
        } catch( e:Dynamic ) {
            // do nothing, flash9 complains with a reference error for styles not defined.
            // FIXME: f9dynamic or sth?
            //trace("Could not set style param '"+param+"': "+e);
        }
    }
    
    public function setFromObject( style:Dynamic ) :Void {
        for( param in Reflect.fields(style) ) {
            set( param, Reflect.field(style,param) );
        }
    }

    public function setFrom( style:Style ) :Void {
        for( param in style.params.keys() ) {
            var v = style.params.get(param);
            if( v!=null ) {
                set( param, v );
            }
        }
    }

    public static function createFromObject( style:Dynamic ) :Style {
        var s = new Style();
        s.setFromObject(style);
        return s;
    }
    
    public function toString() :String {
        var s = "Style {\n";
            for( param in params.keys() ) {
                s+=param+": "+params.get(param)+"\n";
            }
        s +="}";
        return s;
    }
    
}
