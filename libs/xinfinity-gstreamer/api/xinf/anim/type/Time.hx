/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.anim.type;

enum Time {
	List( times:Iterable<Time> );
	Offset( offset:Float );
	SyncBase( id:String, end:Bool, offset:Float );
	Event( id:String, event:String, offset:Float );
	Repeat( id:String, iteration:Int, offset:Float );
	AccessKey( character:String, offset:Float );
	MediaMarker( id:String, marker:String );
	WallClock( t:Date );
	Indefinite;
}
