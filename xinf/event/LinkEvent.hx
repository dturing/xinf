/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.event;

/**
    
**/
class LinkEvent extends Event<LinkEvent> {
    
    static public var ACTUATE = new EventKind<LinkEvent>("actuate",true);

    public var href:String;
    
    public function new( _type:EventKind<LinkEvent>, href:String ) {
        super(_type);
		this.href = href;
    }

}
