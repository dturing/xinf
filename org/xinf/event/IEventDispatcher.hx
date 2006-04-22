package org.xinf.event;

interface IEventDispatcher {
    function addEventListener( type:String, listener : Event->Void, 
                               useCapture:Bool, priority:Int, 
                               weakRef:Bool ) : Void;
                               
    function dispatchEvent( event:Event ) : Bool;
    
    function hasEventListener( type:String ) : Bool;
    
    function removeEventListener( type:String, listener : Event->Void, 
                                  useCapture:Bool ) : Void;
                                  
    function willTrigger( type:String ) : Bool;
}
