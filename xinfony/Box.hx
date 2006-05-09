package xinfony;

import xinfony.style.Color;
import xinfony.style.Style;

class Box extends Styled {

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
           
            var b = style.border.thickness.px();
            var padding = style.padding;
            var w:Int = Math.floor( style.width.px() +b+b+padding.left.px()+padding.right.px() );
            var h:Int = Math.floor( style.height.px() +b+b+padding.top.px()+padding.bottom.px() );
            
            untyped {
            _e.clear();
            _e.beginFill( style.background.toInt(),  100 );
            if( b > 0 ) {
                _e.lineStyle( b, style.border.color.toInt(), style.border.color.a*100, true, "", "", "", 0 );
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
