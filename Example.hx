import Xinf;

import xinf.ul.widget.Button;
import xinf.ul.widget.Label;
import xinf.ul.widget.Dropdown;
import xinf.ul.widget.Slider;

import xinf.ul.layout.FlowLayout;
import xinf.ul.model.SimpleListModel;
import xinf.ul.list.ListView;
import xinf.ul.model.SelectableListModel;
import xinf.ul.list.SelectionListView;
import xinf.ul.model.Selectable;

class Example {

	public static function main() {
		Document.instantiate( Std.resource("test.svg"), loaded );
	}
	
	public static function loaded( doc:Document ) :Void {
			Root.attach( doc );

			var root:Group = doc.getTypedElementById("test",Group);
			var i = new xinf.ul.Interface(root);
			
			i.layout = FlowLayout.Vertical5;
			i.size = {x:300.,y:300.};
			
			var b = Button.createSimple("Hello", function(v) {
				trace(v); }, "Clicked Hello" );
			i.attach(b);
			
			var d = Button.createSimple("Watch this really long Bar table", function(v) {
				trace(v); }, "Clicked Bar" );
			i.attach(d);
			
			var l = new Label("Hello Label");
			i.attach(l);

            var model = SimpleListModel.create(
                [ "foo", "bar", "baz", "fnord", "qux", "quux", "qasi" ] );

			var dropdown = new Dropdown( model );
			i.attach( dropdown );
			
			var slider = new Slider( 100, 50, 10 );
			i.attach( slider );

            var listbox = new ListView<String>( model );
            listbox.setPrefSize( {x:100.,y:100.} );
            i.attach( listbox );


			var smodel = new SelectableListModel<String>();
			for( i in 0...100 ) {
				smodel.addItem("Item #"+i);
			}
			
            var slistbox = new SelectionListView<Selectable<String>>( smodel, 4 );
            slistbox.setPrefSize( {x:100.,y:100.} );
            i.attach( slistbox );

			i.relayout();

		Root.main();
	}
	
}
