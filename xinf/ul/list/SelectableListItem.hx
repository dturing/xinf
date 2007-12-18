/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;
import xinf.ul.model.ISelectable;

/*
	the ugly #if flash9 untyped stuff here is due to the bug
	discussed in
	http://lists.motion-twin.com/pipermail/haxe/2007-July/010655.html
*/

#if flash9
class SelectableListItem<T> extends ListItem<T> {
#else true
class SelectableListItem<T:ISelectable> extends ListItem<T> {
#end
    override public function set( ?value:T ) :Void {
  //      super.set();
        this.value = value;
		if( value!=null ) {
			#if flash9
			untyped {
			#end
			if( value.selected ) this.text.style.fill = Color.RED;
		//	else this.text.style.fill = Color.BLACK;
			trace( value.selected );
			#if flash9
			}
			#end
		}
        this.text.text = if( value==null ) "" else ""+value;
    }
}
