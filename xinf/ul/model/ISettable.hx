/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

import Xinf;

interface ISettable<T> {

    function set( ?value:T ) :Void;
	function setStyle( style:Dynamic ) :Void;
    function attachTo( parent:Group ) :Void;

    function moveTo( x:Float, y:Float ) :Void;
    function resize( x:Float, y:Float ) :Void;
    
    function setCursor( isCursor:Bool ) :Bool;

}
