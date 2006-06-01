package org.xinf.ony;

import org.xinf.event.Event;

class Root extends Element {
    private var _r:
        #if neko
            org.xinf.inity.Root
        #else js
            js.HtmlDom
        #else flash
            flash.MovieClip
        #end
        ;

    #if js
	    private static var arr = new Array<Root>();
    	private var timerId : Int;
    #end

    private function new() {
        super("root");
    }
    
    private function createPrimitive() :Dynamic {
        _r = 
            #if neko
                new org.xinf.inity.Root(320,240)
            #else js
                js.Lib.document.getElementById("xinfony")
            #else flash
                flash.Lib._root
            #end
            ;
        return _r;
    }
    
    public static function getRoot() : Root {
        if( root == null ) {
            root = new Root();
        }
        return root;
    }
    
    public function run() : Void {
        #if neko
            _r.run();
        #else js
		    var id = arr.length;
	    	arr[id] = this;
    		timerId = untyped window.setInterval("org.xinf.ony.Root.arr["+id+"].step();",40);
        #else flash
            _p.onEnterFrame = step;
        #end
    }
    
    #if js
        public function step() :Void {
            org.xinf.event.EventDispatcher.global.postEvent( Event.ENTER_FRAME, { } );
            org.xinf.event.Event.processQueue();
        }
    #else flash
        public function step() :Void {
            org.xinf.event.EventDispatcher.global.postEvent( Event.ENTER_FRAME, { } );
            org.xinf.event.Event.processQueue();
        }
    #end
    
    public static var root:Root;
}
