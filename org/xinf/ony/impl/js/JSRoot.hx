package org.xinf.ony.impl.js;

import org.xinf.ony.impl.IRootPrimitive;

class JSRoot extends JSPrimitive, implements IRootPrimitive {
	private static var arr = new Array<JSRoot>();
	private var timerId : Int;
    
    public function new() :Void {
        super();
    }
    
    public function step() :Void {
        org.xinf.event.Event.processQueue();
    }
    
    public function run() :Void {
		var id = arr.length;
		arr[id] = this;
		timerId = untyped window.setInterval("org.xinf.ony.impl.js.JSRoot.arr["+id+"].step();",40);
    }
}
