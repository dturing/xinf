package org.xinf.ony;

import org.xinf.style.Style;
import org.xinf.style.StyleChain;
import org.xinf.style.StyleSheet;
import org.xinf.style.Pad;
import org.xinf.style.Border;


class StyledElement extends Element {
    public static var globalStyle:StyleSheet = new StyleSheet();

    public var style:StyleChain;
    
    private var styleClasses:Hash<Bool>;

    public function new( _name:String ) {
        super(_name);
        
        style = new StyleChain(this);
        styleClasses = new Hash<Bool>();
        
        // own classname as style class
        var n:Array<String> = Reflect.getClass(this).__name__;
        addStyleClass( "#"+_name );
        addStyleClass( n[n.length-1] );

        // org.xinf.inity elements depend on style.                
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
        #else neko
            _e.style = style;
            _e.changed();
        #end
    }
}


