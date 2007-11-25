package xinf.ony.base;
import xinf.ony.base.Implementation;

class Use extends ElementImpl {
    public var href(default,set_href):String;
    public var peer(default,set_peer):ElementImpl;

    private function set_href(v:String) {
		// for now, we dont support external references
		var id = v.split("#")[1];
		peer = document.getElementById( id );
		if( peer==null ) throw("'Use' peer #"+id+" not found");
		href = "#"+id;
		
		redraw();
        return href;
    }
	
	private function set_peer(v:ElementImpl) :ElementImpl {
		peer = v;
		// FIXME: set id?
		redraw();
		return v;
	}
}
