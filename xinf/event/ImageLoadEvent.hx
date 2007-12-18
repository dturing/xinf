/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;
import xinf.erno.ImageData;
import xinf.event.EventKind;
import xinf.event.Event;
import xinf.event.EventDispatcher;

/**
    
**/
class ImageLoadEvent extends Event<ImageLoadEvent> {
    
    static public var PART_LOADED = new EventKind<ImageLoadEvent>("imagePartLoaded");
    static public var LOADED = new EventKind<ImageLoadEvent>("imageLoaded");
    static public var FRAME_AVAILABLE = new EventKind<ImageLoadEvent>("imageFrameAvailable");

    public var image:ImageData;
    public var data:Dynamic;
    
    public function new( _type:EventKind<ImageLoadEvent>, image:ImageData, ?data:Dynamic ) {
        super(_type);
        this.image = image;
        this.data = data;
    }
    
}
