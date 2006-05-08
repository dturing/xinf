package xinfony;

import xinfony.style.Color;
import xinfony.style.Style;

class Box extends Element {

    public function new( name:String ) {
        super(name);
        
        #if flash
            untyped _e.style = Style.DEFAULT;
        #end
        
        draw();
    }

    #if neko
    private function createPrimitive() : xinfinity.graphics.Object {
        return new xinfinity.graphics.Box();
    }
    #end
    
    public function styleChanged() :Void {
        super.styleChanged();
        draw();
    }

    private function draw() {
        #if flash
           // trace("draw box "+style.width+","+style.height + " "+style.x+","+style.y );
            var w:Int = Math.floor( style.width.px() );
            var h:Int = Math.floor( style.height.px() );
            
            untyped {
            _e.beginFill( style.background.toInt(),  100 );
            var th = style.border.thickness.px();
            if( th > 0 ) {
                _e.lineStyle( th, style.border.color.toInt(), style.border.color.a*100, true, "", "", "", 0 );
            }
            _e.moveTo( 0, 0 );
            _e.lineTo( w, 0 );
            _e.lineTo( w, h );
            _e.lineTo( 0, h );
            _e.lineTo( 0, 0 );
            _e.endFill();
            }
        #else neko
            _e.changed();
        #end
    }
}
