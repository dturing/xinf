/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.geom;

import xinf.geom.Types;

interface Transform {
    function getTranslation() :TPoint;
    function getScale() :TPoint;
    function getMatrix() :TMatrix;
    
    function apply( p:TPoint ) :TPoint;
    function applyInverse( p:TPoint ) :TPoint;
	
	function interpolateWith( p:Transform, f:Float ) :Transform;
}
