package xinfony;

import xinfony.style.Style;
import xinfony.style.Tango;
import xinf.event.Event;
import xinf.event.EventDispatcher;

#if neko
import xinfinity.graphics.Root;
import xinfinity.demo.Glyph;
#end

class Foo extends xinfony.Box {

    public static var styles:Dynamic = {
        def: Style.DEFAULT,
        mouseOver: Style.HILITE,
        mouseUp: Style.HILITE,
        mouseDown: new Style("background: #039; color: #fff; border: 0px solid #000; padding: 5px; margin: 2px;")
    };

    public function new( name:String ) {
        super( name );
       // text = "Why,\nTell me Why,\nDoes the quick brown fox\njump over the lazy dog?";
        set_style( styles.def );
        
        for( event in [ Event.MOUSE_DOWN, Event.MOUSE_UP,
                        Event.MOUSE_OVER, Event.MOUSE_OUT ] ) {
            addEventListener( event, handleEvent );
        }
        
        EventDispatcher.addGlobalEventListener( Event.ENTER_FRAME, onEnterFrame );
    }
    
    public function handleEvent( e:Event ) : Bool {
        trace("Event on "+this+": "+e.type );
     //   text = name+"\n"+e.type;
        
        var style:Style = Reflect.field( styles, e.type );
        if( style == null ) style = styles.def;
        set_style( style );
        
        return true;
    }
    
    public function onEnterFrame( e:Event ) : Bool {
     //   x = (x+2)%204;
        return true;
    }
}

class Test {
    static function main() {
        trace("Hello");

        var box = new Foo("box1");
        box.style.x = box.style.y = 100;
        box.style.width = box.style.height = 100;
        
        box = new Foo("box2");
        box.style.x = 201; box.style.y = 100;
//        box.style.width = box.style.height = 10;
        
        /*
        var style = new xinfony.style.Style("
                background: white;
                border: 2em solid white;
                margin: 2px;
                padding: 2px 10px 2px 10px;
                ");
        trace("Style:"+style );
        */
        
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
