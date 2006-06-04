package org.xinf.inity;

class Image extends Bitmap {
    public function new( uri:String ) {
        var d:BitmapData = BitmapData.newFromFile( uri );
        super( d );
    }
}
