package xinf.ony.base;
import xinf.ony.base.Implementation;

import xinf.style.StyleSheet;
import xinf.style.StyleParser;
import xinf.traits.StringTrait;

class Style extends ElementImpl {

	static var TRAITS = {
		type:new StringTrait(),
		text:new StringTrait(),
	}

    public var type(get_type,set_type):String;
    function get_type() :String { return getTrait("type",String); }
    function set_type( v:String ) :String { redraw(); return setTrait("type",v); }

    public var text(get_text,set_text):String;
    function get_text() :String { return getTrait("text",String); }
    function set_text( v:String ) :String { redraw(); return setTrait("text",v); }

	var rules(default,null):Array<StyleRule>;
	
	override public function fromXml( xml:Xml ) :Void {
		super.fromXml(xml);
		
		if( type=="text/css" ) {
			var t = "";
			for( node in xml ) {
				if( node.nodeType == Xml.PCData 
				 || node.nodeType == Xml.CData ) {
				 t += node.nodeValue;
				}
			}
			
			if( t.length>0 ) {
				if( document==null || document.styleSheet==null ) {
					throw("cannot parse style, no document.styleSheet");
				}
				
				var r = StyleParser.parseRules( t, this );
				trace("Parsed "+r.length+" rules" );
				document.styleSheet.addMany( r );
				
				text = t;
			}
		}
	}
}
