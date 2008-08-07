/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;
import xinf.ul.layout.SpringUtilities;
import xinf.ul.layout.BorderLayout;
import xinf.ul.widget.Widget;
import xinf.ul.Component;

class XinfTest {
	
	public function new() :Void {
		xinf.ul.Component.init();
	
		var lm = xinf.ul.model.SimpleListModel.create([
			"one",
			"two",
			"three",
			"four",
			"five",
			"six",
			"seven",
			"eight",
			"nine",
			"ten",
			"eleven",
			"twelve",
			"thirteen"
		].iterator());

		var tm = xinf.ul.model.SimpleListModel.create([
			{ a:"foo", b:"bar", c:"baz" },
			{ a:"qux", b:"quux", c:"quuux" },
			{ a:"snirf", b:"snarf", c:"snorf" },
		].iterator());

		for( i in 0...1000 ) {
			tm.addItem( 
				{ a:""+i, b:"foo", c:"bar" } );
		}

		var tdef = [
			{ name:"a", title:"A", width:50. },
			{ name:"b", title:"B", width:50. },
			{ name:"c", title:"C", width:100. },
		];

		var c = new xinf.ul.Interface();
		c.layout = xinf.ul.layout.FlowLayout.Vertical5;
		c.captureRoot();

		var t = new xinf.ul.list.Table(tm,tdef);
		c.appendChild(t);

/*
		var l = new xinf.ul.widget.Label( "Hello, World!" );
		c.appendChild(l);

		var s = new xinf.ul.widget.Slider( 0, 100, 1 );
		c.appendChild(s);

		var ed = new xinf.ul.widget.LineEdit();
		ed.text = "Edit me!";
		c.appendChild( ed );

		c.appendChild( xinf.ul.widget.Button.createSimple("Push it!", function(){ trace("Button pressed"); } ) );

		c.appendChild( xinf.ul.widget.CheckBox.createSimple("Check it out, yo!", function(b) {
			trace("Checkbox: "+b ); } ) );

		var l = new xinf.ul.list.ListView(lm);
		c.appendChild(l);
		
		var d = new xinf.ul.widget.Dropdown(lm);
		c.appendChild(d);
*/
		c.relayout();
	}
	
	public static function main() :Void {
		Root.setBackgroundColor(.3,.3,.3,0);
		var d = new XinfTest();
		Root.main();
	}
}
