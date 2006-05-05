package xinfony;

import xinfony.style.Style;
import xinfony.style.Tango;
import xinf.event.Event;

#if neko
import xinfinity.graphics.Root;
#end

class Foo extends Text {
    public static var styles:Dynamic = {
        def: new Style( Tango.black, Tango.gray[2], 1, Tango.gray[4] ),
        mouseOver: new Style( Tango.white, Tango.lightblue, 1, Tango.blue ),
        mouseUp: new Style( Tango.white, Tango.lightblue, 1, Tango.blue ),
        mouseDown: new Style( Tango.white, Tango.red, 1, Tango.red )
    };

    public function new( name:String ) {
        super( name );
//        setSize( 100, 100 );
        text = "Hello, World!";
        applyStyle( styles.def );
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
    }
    
    public function handleEvent( e:Event ) : Bool {
        var style:Style = Reflect.field( styles, e.type );
        if( style == null ) style = styles.def;
        applyStyle( style );
        text = name+"\n"+e.type;
        return true;
    }
}


class Test {
    static function main() {
        trace("Hello");
    
        var box = new Foo("box1");
        box.move(100,100);
        
        box = new Foo("box2");
        box.move(202,100);
        
        #if neko
            Root.root.run();
        #end
    }
}
