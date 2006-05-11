package org.xinf.style;

import org.xinf.event.EventDispatcher;

class StyledObject extends EventDispatcher {
    public static var globalStyle:StyleSheet = new StyleSheet();

    public var style:StyleChain;
    
    private var styleClasses:Hash<Bool>;

    public function new( _name:String ) :Void {
        super();
        
        style = new StyleChain(this);
        styleClasses = new Hash<Bool>();

        // own classname as style class
        var n:Array<String> = Reflect.getClass(this).__name__;
        addStyleClass( "#"+_name );
        addStyleClass( n[n.length-1] );
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
    }
}


