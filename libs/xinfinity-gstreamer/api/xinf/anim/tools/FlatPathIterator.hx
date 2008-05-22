/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.tools;

import xinf.geom.Types;

interface FlatPathIterator {
	function hasNext() :Bool;
	function next() :TPoint;
	function rotation() :Float;
	function reset() :Void;
	function jumpTo( t:Float ) :Void;
	function finalPoint() :TPoint;
	function finalRotation() :Float;
}
