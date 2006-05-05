package xinfony;
class Foo extends Text {
    public static var styles:Dynamic = {
        def: new Style( Tango.black, Tango.gray[2], 1, Tango.gray[4] ),
        mouseover: new Style( Tango.white, Tango.lightblue, 1, Tango.blue ),
        mouseup: new Style( Tango.white, Tango.lightblue, 1, Tango.blue ),
        mousedown: new Style( Tango.white, Tango.red, 1, Tango.red )
    };

    public function new( name:String ) {
        super( name );
//        setSize( 100, 100 );
//        setBackground( Colors.interactiveBG );
        text = "Hello, World!";
        applyStyle( styles.def );
    }
    
    public function dispatchEvent( type:String ) {
        var style:Style = Reflect.field( styles, type );
        if( style == null ) style = styles.def;
        applyStyle( style );
        text = name+"\n"+type;
    }
}


class Test {
    static function main() {
        trace("Hello");
    
        var box = new Foo("box1");
        box.move(100,100);
        
        box = new Foo("box2");
        box.move(202,100);
    }
}
