package xinfony;

import xinfony.style.Style;
import xinfony.style.StyleChain;
import xinfony.style.StyleSheet;
import xinfony.style.Pad;
import xinfony.style.Border;


class Styled extends Element {
    public static var globalStyle:StyleSheet = new StyleSheet();

    public var style:StyleChain;
    
    public var styleClasses:Hash<Bool>; // FIXME: should be private

    public function new( _name:String ) {
        super(_name);
        
        style = new StyleChain(this);
        styleClasses = new Hash<Bool>();
        
        // own classname as style class
        var n:Array<String> = Reflect.getClass(this).__name__;
        addStyleClass( "#"+_name );
        addStyleClass( n[n.length-1] );

        // xinfinity elements depend on style.                
        #if neko
            _e.style = style;
        #end
    }

    public function addStyleClass( c:String ) :Void {
        styleClasses.set(c,true);
        styleChanged();
    }

    public function hasStyleClass( c:String ) :Bool {
        return( styleClasses.get(c) == true );
    }
    
    public function removeStyleClass( c:String ) :Void {
        styleClasses.remove(c);
        styleChanged();
    }

    public function getStyleClasses() :Iterator<String> {
        return( styleClasses.keys() );
    }
    
    public function styleChanged() :Void {
        // match against stylesheet
        style.setChain( globalStyle.match( this ) );
    
        // apply style to primitives
        #if flash
            _e._x = style.x.px();
            _e._y = style.y.px();
        #else js
            var padding:Pad = style.padding;
            var b:Float = style.border.thickness.px();
            _e.style.left = Math.floor( style.x.px() );
            _e.style.top  = Math.floor( style.y.px() );
            _e.style.width  = Math.floor( style.width.px() - (padding.left.px()+padding.right.px()+(b*2)) );
            _e.style.height = Math.floor( style.height.px() - (padding.top.px()+padding.bottom.px()+(b*2)) );
            _e.style.color = style.color.toString();
            _e.style.background = style.background.toString();
            _e.style.border = style.border.toString();
            _e.style.padding = style.padding.toString();
            _e.style.margin = style.margin.toString();
        #else neko
            _e.style = style;
            _e.changed();
        #end
    }
}


