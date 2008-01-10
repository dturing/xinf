/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.widget;

import Xinf;
import xinf.ul.Component;
import xinf.ul.Container;
import xinf.ul.Drag;

/**
    Improvised Vertical Scrollbar element.
**/

class VScrollbar extends Container {
    
    private var thumb:Component;
    private var thumbHeight:Float;
    
    public function new() :Void {
        super();
        
        group.addEventListener( MouseEvent.MOUSE_DOWN, clickBar );
        
        thumb = new Container();
       // thumb.addStyleClass("Thumb");
        thumb.group.addEventListener( MouseEvent.MOUSE_DOWN, clickThumb );
        thumb.size = { x:18., y:18. };
		thumb.position = { x:0., y:0. };
        appendChild(thumb);
        
        thumbHeight = thumb.size.y;
        
        size = {x:18.,y:0.};
    }

    public function clickBar( e:MouseEvent ) {
        var y = group.globalToLocal( { x:1.*e.x, y:1.*e.y }).y;

		var delta:Int;
        if( y > thumb.position.y+thumb.size.y ) delta = 1;
        else if( y < thumb.position.y ) delta = -1;
        else return;
		
		e.preventBubble=true;
		
        postEvent( new ScrollEvent( ScrollEvent.SCROLL_LEAP, delta ) );
    }
        
    public function clickThumb( e:MouseEvent ) {
        new Drag<Float>( e, move, null, thumb.position.y );
		e.preventBubble=true;
    }
    
    public function move( x:Float, y:Float, marker:Float ) {
        var y:Float = marker+y;
        if( y < 0 ) {
            y = 0;
        } else if( y > size.y-thumbHeight ) {
            y = size.y-thumbHeight;
        }
        thumb.position = { x:0., y:Math.floor(y)*1. };
        
        var value:Float = y/(size.y-thumbHeight);
        postEvent( new ScrollEvent( ScrollEvent.SCROLL_TO, value ) );
    }
    
    public function setScrollPosition( position:Float ) :Void {
        position = Math.max( 0, Math.min( 1, position ) );
        thumb.position = { x:thumb.position.x, y:1.*Math.floor(position * (size.y-thumbHeight)) };
    }
    
}
