package xinfony;

import xinfony.style.Style;
import xinfony.style.StyleChain;
import xinfony.style.Pad;
import xinfony.style.Border;


class Styled extends Element {
    public property style(get_style,set_style):Style;    
    private var _style:StyleChain;

    public function new( _name:String ) {
        super(_name);
        _style = StyleChain.DEFAULT.clone();
        styleChanged(); // FIXME can we avoid this?
    }

    public function set_style( style:Style ) :Style {
        _style.popStyle();
        _style.pushStyle( style );
        styleChanged();
        return _style;
    }
    public function get_style() :Style {
        return _style;
    }
    
    public function styleChanged() :Void {
        #if flash
            _e._x = _style.x.px();
            _e._y = _style.y.px();
        #else js
            var padding:Pad = _style.padding;
            var b:Float = _style.border.thickness.px();
            _e.style.left = Math.floor( style.x.px() );
            _e.style.top  = Math.floor( style.y.px() );
            _e.style.width  = Math.floor( _style.width.px() - (padding.left.px()+padding.right.px()+(b*2)) );
            _e.style.height = Math.floor( _style.height.px() - (padding.top.px()+padding.bottom.px()+(b*2)) );
            _e.style.color = _style.color.toString();
            _e.style.background = _style.background.toString();
            _e.style.border = _style.border.toString();
            _e.style.padding = _style.padding.toString();
            _e.style.margin = _style.margin.toString();
        #else neko
            _e.style = _style;
            _e.changed();
        #end
    }
}


