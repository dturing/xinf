import Xinf;
import xinf.ul.layout.SpringUtilities;
import xinf.ul.layout.BorderLayout;
import xinf.ul.widget.Widget;
import xinf.ul.Component;

class Example {
	
	public function new() :Void {
		var lm = xinf.ul.model.SimpleListModel.create([
			"one",
			"two",
			"three",
			"four",
			"five",
			"six",
			"seven"
		]);
		
		var c = new xinf.ul.Container();
		c.layout = xinf.ul.layout.FlowLayout.Vertical5;
		c.position = { x:100., y:100. };
		c.size = { x:120., y:250. };
		Root.attach(c.getElement());
		
		var l = new xinf.ul.widget.Label( "Hello Xinful" );
		c.attach(l);

		var ed = new xinf.ul.widget.LineEdit();
		ed.text = "Edit me!";
		c.attach( ed );
		
		var dumpButtonInfo = function(m:Dynamic) {
			trace("Button press: "+m );
		};
		c.attach( xinf.ul.widget.Button.createSimple("Hello", dumpButtonInfo, "Hi!" ) );
		c.attach( xinf.ul.widget.Button.createSimple("World", dumpButtonInfo, "World!" ) );

		var l = new xinf.ul.list.ListView(lm);
		c.attach(l);
		
		var d = new xinf.ul.widget.Dropdown(lm);
		c.attach(d);

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
            c.attach(l);
            
        }
		
        c.layout = layout;
        c.relayout();
        Root.attach(c.getElement());
        */
	}
	
	public static function main() :Void {
		var d = new Example();
		Root.main();
	}
}
