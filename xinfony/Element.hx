package xinfony;

import xinfony.event.EventDispatcher;

class Element extends EventDispatcher {
    public var name:String;
    
    private var _e
        #if flash
            :MovieClip
        #else js
            :HtmlDom
        #end
        ;
        
    public function new( _name:String ) {
        name = _name;
        
        // create the runtime-specific proxy element
        #if flash
            _e = null;
        #else js
            _e = js.Lib.window.document.createElement("div");
            _e.style.position="absolute";
        #end
    }
    
    public function attach( parent:Element ) {
        #if flash
            _e = parent._e.createEmptyMovieClip(name,parent._e.getNextHighestDepth());
        #else js
            parent._e.appendChild( _e );
        #end
    }
    
    /*
    #if flash
        public var _clip:flash.MovieClip;
    #else js
        public var _div:js.HtmlDom;
    #end
    
    public function new( _name:String ) {
        name = _name;
        #if flash
            _clip = Player.root().createEmptyMovieClip(name,flash.Lib.current.getNextHighestDepth());
            var v = this;
            untyped _clip._e = this;
            untyped _clip.onPress = function() { dispatchFlashEvent("mousedown",this); }
            untyped _clip.onRelease = function() { dispatchFlashEvent("mouseup",this); }
            untyped _clip.onRollOver = function() { dispatchFlashEvent("mouseover",this); }
            untyped _clip.onRollOut = function() { dispatchFlashEvent("mouseout",this); }
        #else js
            _div = js.Lib.window.document.createElement("div");
            _div.style.position="absolute";
            var v = this;
            untyped _div._e = this;
            untyped _div.onmousedown = dispatchJSEvent;
            untyped _div.onmouseup = dispatchJSEvent;
            untyped _div.onmouseover = dispatchJSEvent;
            untyped _div.onmouseout = dispatchJSEvent;
            Player.root().appendChild( _div );
        #end
    }
    
    public function move( x:Int, y:Int ) {
        #if flash
            _clip._x = x;
            _clip._y = y;
        #else js
            _div.style.left = x;
            _div.style.top = y;
        #end
    }
    
    public function dispatchEvent( type:String ) {
    }
    
    #if flash
    public static function dispatchFlashEvent( e:String, self:flash.MovieClip ) {
        var target:Element = untyped self._e;
        target.dispatchEvent( e );
    }
    #else js
    public static function dispatchJSEvent( e:js.Event ) {
        var target:Element = untyped e.target._e;
        target.dispatchEvent( e.type );
    }
    #end
    
    */
}
