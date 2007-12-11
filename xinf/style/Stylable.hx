package xinf.style;

import Xinf;

interface Stylable {
	var style:Dynamic;
    function styleChanged() :Void;
	function getStyleParent() :Stylable;
	function matchSelector( s:Selector ) :Bool;
}
