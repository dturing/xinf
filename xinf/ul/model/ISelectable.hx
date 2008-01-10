/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

interface ISelectable {
	
	public var selected(default,setSelected) :Bool;
	public function setSelected( sel:Bool ) :Bool;
	
}