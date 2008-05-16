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
			"seven"
		].iterator());
		
		var c = new xinf.ul.Interface();
		c.layout = xinf.ul.layout.FlowLayout.Vertical5;
		c.captureRoot();
		
		var l = new xinf.ul.widget.Label( "Hello Xinful" );
		c.appendChild(l);

		var s = new xinf.ul.widget.Slider( 0, 100, 1 );
		c.appendChild(s);

		var ed = new xinf.ul.widget.LineEdit();
		ed.text = "Edit me!";
		c.appendChild( ed );
		
		var dumpButtonInfo = function(m:Dynamic) {
			trace("Button press: "+m );
		};
		c.appendChild( xinf.ul.widget.Button.createSimple("Hello", dumpButtonInfo, "Hi!" ) );
		c.appendChild( xinf.ul.widget.Button.createSimple("World", dumpButtonInfo, "World!" ) );

		var l = new xinf.ul.list.ListView(lm);
		c.appendChild(l);
		
		var d = new xinf.ul.widget.Dropdown(lm);
		c.appendChild(d);

		c.relayout();
		/*
		*/
		/*
		var layout = new xinf.ul.layout.BorderLayout();
		//var layout = new xinf.ul.layout.SpringLayout();
		
		var c = new xinf.ul.widget.Pane();
		c.set_size({x:300.,y:300.});
		var arr = ["one","two","three","four","five"];//,"six","seven","eight","nine"];
		var borders = [West,North,East,South,Center];
		var count = 0;
		for( t in arr ) {
            var l :Component = if (count%2==0) {
            	if (count==4) cast(new xinf.ul.widget.CheckBox(t),Component);
            	else cast(new xinf.ul.widget.Label(t),Component);
            } else {
            	cast(new xinf.ul.widget.Button(t),Component);
            }
            l.set_size(l.prefSize);
            layout.setConstraint(l,borders[count++]);
            c.appendChild(l);
            
        }
		
        c.layout = layout;
        c.relayout();
        Root.appendChild(c.getElement());
        */
	}
	
	public static function main() :Void {
		var d = new XinfTest();
		Root.main();
	}
}
