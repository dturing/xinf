package org.xinf.ony.impl.x;

class XImage extends XPrimitive  {
    private var _b:org.xinf.inity.Bitmap;
    
    public function new() :Void {
        _b = new org.xinf.inity.Bitmap( org.xinf.inity.BitmapData.newFromFile("test.png"));
        super( _b );
        _e.changed();
    }
}
