/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul.list;

import Xinf;

class TableHeader<T> extends Group {

	var table:Table<T>;
	var texts:Array<Text>;
	
	public function new( table:Table<T>, ?traits:Dynamic ) :Void {
		super(traits);
		this.table = table;
		texts = new Array<Text>();
		var x=0.;
		for( i in 0...table.def.length ) {
			texts[i] = new Text();
			texts[i].text = table.def[i].title;
			appendChild(texts[i]);
		}
		update();
	}
	
	public function update() {
		var x=0.;
		for( i in 0...table.def.length ) {
			texts[i].y = fontSize; // FIXME
			texts[i].x = x;
			x+=table.def[i].width;
		}
	}

}
