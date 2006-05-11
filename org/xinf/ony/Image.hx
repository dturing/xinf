package org.xinf.ony;

class Image extends Pane {

    public function new( name:String ) {
        throw("not implemented");
        super(name);
    }

    static function __init__() : Void {
        #if neko
            untyped org.xinf.ony.Image = org.xinf.ony.x.XImage;
        #end
    }
}
