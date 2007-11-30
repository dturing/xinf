package xinf.style;

import Xinf;

interface Stylable {
    function styleChanged() :Void;
	function getParentStyle() :Style;
	function matchSelector( s:Selector ) :Bool;
}
