/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.model;

interface ListModel<T> {

    function getLength() :Int;
    function getItemAt( index:Int ) :T;

}

