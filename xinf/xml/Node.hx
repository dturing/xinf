package xinf.xml;

import xinf.traits.TraitsEventDispatcher;
import xinf.traits.TraitDefinition;
import xinf.traits.StringTrait;

class Node extends TraitsEventDispatcher, implements Serializable {

	static var TRAITS = {
		id:new StringTrait(),
		name:new StringTrait(),
	}

    /** textual (XML) id **/
    public var id(get_id,set_id):String;
    function get_id() :String { return getTrait("id",String); } // FIXME: maybe directly return id? as no inheritance? same for name
    function set_id( v:String ) :String { return setTrait("id",v); }

    /** textual name (name attribute) **/
    public var name(get_name,set_name):String;
    function get_name() :String { return getTrait("name",String); }
    function set_name( v:String ) :String { return setTrait("name",v); }

    public function new( ?traits:Dynamic ) :Void {
        super( traits );
	}
	
    public function fromXml( xml:Xml ) :Void {
		setTraitsFromXml( xml );
	}

	/** called when the document is completely loaded **/
	public function onLoad() :Void {
	}
}
