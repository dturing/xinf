package xinf.ony.erno;

import xinf.erno.Renderer;

class Use extends xinf.ony.base.Use {

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
		href = xml.get("xlink:href");
    }

    override public function drawContents( g:Renderer ) :Void {
		if( peer != null ) {
			// FIXME: in inity, reuse xid!
			peer.drawContents(g);
		}
	}
}
