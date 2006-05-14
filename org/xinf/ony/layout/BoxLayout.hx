package org.xinf.ony.layout;

import org.xinf.event.Event;
import org.xinf.ony.Element;

enum Orientation {
    HORIZONTAL;
    VERTICAL;
}

class BoxLayout extends Layout {
    private var orientation:Orientation;

    public function new( _name:String, o:Orientation ) :Void {
        super(_name);
        orientation = o;
        addEventListener( Event.SIZE_CHANGED, do_relayout );
    }
    
    public function do_relayout( e:Event ) :Void {
        if( e.target == this ) return;
        relayout(); // maybe not, always "schedule" event? FIXME
    }
    
    public function relayout() :Void {
        switch( orientation ) {
            case HORIZONTAL:
                _horizontalLayout();
            case VERTICAL:
                _verticalLayout();
            default:
                throw("BoxLayout "+orientation+" not implemented");
        }
    }
    
    private function _horizontalLayout() {
        var max:Float = 0;

        // iterate once to find maximum height for alignment.
        for( child in children ) {
            var h = child.style.height.px();
            if( h > max ) max = h;
        }
        
        // iterate again to set position
        var x:Float = 0;
        for( child in children ) {
            child.style.y = (max - child.style.height.px())/2;
            child.style.x = x;
            x += child.style.width.px();
            child.styleChanged();
        }
        
        style.width = x;
        style.height = max;
        sizeChanged();
    }
    
    private function _verticalLayout() {
        var max:Float = 0;

        // iterate once to find maximum width for alignment.
        for( child in children ) {
            var w = child.style.width.px();
            if( w > max ) max = w;
        }
        
        // iterate again to set position
        var y:Float = 0;
        for( child in children ) {
            child.style.x = (max - child.style.width.px())/2;
            child.style.y = y;
            y += child.style.height.px();
            child.styleChanged();
        }
        
        style.width = max;
        style.height = y;
        parent.sizeChanged();
    }
    
    public function addChild( child:Element ) :Void {
        super.addChild(child);
        relayout();
    }
    
    public function removeChild( child:Element ) :Void {
        super.addChild(child);
        relayout();
    }
}
