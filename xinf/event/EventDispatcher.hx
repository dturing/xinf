/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

interface EventDispatcher {
    
    function addEventListener<T>( type :EventKind<T>, h :T->Void ) :T->Void;
    function removeEventListener<T>( type :EventKind<T>, h :T->Void ) :Bool;
    function dispatchEvent<T>( e : Event<T> ) :Void;
    function postEvent<T>( e : Event<T>, ?pos:haxe.PosInfos ) :Void;
    
}

