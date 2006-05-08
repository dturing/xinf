package xinfony;

import xinfony.style.Style;
import xinfony.style.Tango;
import xinf.event.Event;
import xinf.event.EventDispatcher;

#if neko
import xinfinity.graphics.Root;
import xinfinity.demo.Glyph;
#end

class Foo extends xinfony.Text {

    public static var styles:Dynamic = {
        def: Style.DEFAULT,
        mouseOver: Style.INVERSE,
        mouseUp: Style.INVERSE,
        mouseDown: new Style("background: #ff0; color: #0f0; border: 2px solid #0f0;")
    };

    public function new( name:String ) {
        super( name );
//        setSize( 100, 100 );
        text = "Why,\nTell me Why,\nDoes the quick brown fox\njump over the lazy dog?";
        applyStyle( styles.def );
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
        
        EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, onEnterFrame );
    }
    
    public function handleEvent( e:Event ) : Bool {
        var style:Style = Reflect.field( styles, e.type );
        if( style == null ) style = styles.def;
        applyStyle( style );

        trace("Event on "+this+": "+e.type );
        text = name+"\n"+e.type;
        return true;
    }
    
    public function onEnterFrame( e:Event ) : Bool {
//        x = (x+2)%204;
        return true;
    }
}

class Test {
    static function main() {
        trace("Hello");

        var box = new Foo("box1");
        box.x = 100; box.y = 100;
        
        box = new Foo("box2");
        box.x = 202; box.y = 100;
        
        
        var style = new xinfony.style.Style("
                background: white;
                border: 1em solid black;
                ");
        trace("Style:"+style );

        #if neko
        /* Glyph Test
            var t = new xinfinity.demo.Glyph();
            Root.root.addChild(t);
            t.x = 100; t.y = 250;
        
            EventDispatcher.addGlobalEventListener( Event.KEY_DOWN, function(e:Event):Bool {
                    trace( e.type+" - "+e.key+", "+Reflect.typeof(e.key) );
                    t.setGlyph( e.key.charCodeAt(0) );
                    return true;
                });
        */        
            Root.root.run();
        #end
    }
}
