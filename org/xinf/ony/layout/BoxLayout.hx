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
            var h = child.style.height.px() + child.style.margin.vertical();
            if( h > max ) max = h;
        }
        
        // iterate again to set position
        var x:Float = style.padding.left.px() + style.border.thickness.px();
        var ofs:Float = style.padding.top.px() + style.border.thickness.px();
        var margin:Float = 0;
        for( child in children ) {
            x += Math.max( margin, child.style.margin.left.px() );
            child.style.y = child.style.margin.top.px() + ofs + ((max - (child.style.height.px()+child.style.margin.vertical())) * child.style.verticalAlign.factor );
            child.style.x = x;
            x += child.style.width.px();
            margin = child.style.margin.right.px();
            child.styleChanged();
        }
        
        x+=margin;
        style.setInnerSize(x-(style.padding.left.px() + style.border.thickness.px()),max);
        styleChanged();
    }
    
    private function _verticalLayout() {
        var max:Float = 0;

        // iterate once to find maximum width for alignment.
        for( child in children ) {
            var w = child.style.width.px() + child.style.margin.horizontal();
            if( w > max ) max = w;
        }
        
        // iterate again to set position
        var y:Float = style.padding.top.px() + style.border.thickness.px();
        var ofs:Float = style.padding.left.px() + style.border.thickness.px();
        var margin:Float = 0;
        for( child in children ) {
            y += Math.max( margin, child.style.margin.top.px() );
            child.style.x = child.style.margin.left.px() + ofs + ((max - (child.style.width.px()+child.style.margin.horizontal())) * child.style.textAlign.factor );
            child.style.y = y;
            y += child.style.height.px();
            margin = child.style.margin.bottom.px();
            child.styleChanged();
        }
        
        y+=margin;
        style.setInnerSize(max,y-(style.padding.top.px() + style.border.thickness.px()));
        styleChanged();
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
