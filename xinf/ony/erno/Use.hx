/* 
   xinf is not flash.
   Copyright (c) 2006, Daniel Fischer.
 
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
                                                                            
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        
   Lesser General Public License or the LICENSE file for more details.
*/

package xinf.ony.erno;

import xinf.erno.Renderer;

class Use extends Group, implements xinf.ony.Use {

    public var href(default,set_href):String;
    public var peer(default,set_peer):xinf.ony.Element;

    private function set_href(v:String) {
		// for now, we dont support external references
		var id = v.split("#")[1];
		peer = document.getElementById( id );
		if( peer==null ) throw("'Use' peer #"+id+" not found");
		href = "#"+id;
		
		scheduleRedraw();
        return href;
    }
	
	private function set_peer(v:xinf.ony.Element) :xinf.ony.Element {
		peer = v;
		// FIXME: set id?
		return v;
	}

    override public function fromXml( xml:Xml ) :Void {
        super.fromXml(xml);
		href = xml.get("xlink:href");
    }

    override public function drawContents( g:Renderer ) :Void {
		if( peer != null ) {
			var p = cast(peer,xinf.ony.erno.Object);
			if( p==null ) throw("'Use' peer "+href+" is not an erno.Element?");
			p.drawContents(g);
		}
	}
}
