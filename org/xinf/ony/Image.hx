package org.xinf.ony;

class Image extends Element {

    private var uri:String;

    public function new( name:String, parent:Element, src:String ) :Void {
        uri = src;
        super( name, parent );
    }
    
    private function createPrimitive() :Dynamic {
        #if neko
            return new org.xinf.inity.Image( uri );
        #else js
            var i:js.HtmlDom = js.Lib.document.createElement("img");
            untyped i.src = uri;
            return i;
        #else flash
            if( parent == null ) throw( "Flash runtime needs a parent on creation" );
            return parent._p.attachMovie(uri,name,parent._p.getNextHighestDepth());
        #end
    }

    #if flash
        private function redraw() :Void {
            _p._width = bounds.width;
            _p._height = bounds.height;
        }
    #end
}
