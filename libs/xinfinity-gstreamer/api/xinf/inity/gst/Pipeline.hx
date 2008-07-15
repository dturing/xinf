/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

package xinf.inity.gst;

import Xinf;
import xinf.event.EventKind;
import xinf.event.Event;
import xinf.event.SimpleEventDispatcher;
import xinf.inity.ColorSpace;
import gst.GstBusMessage;

class NekobusData extends Event<NekobusData> {

	static public var DATA = new EventKind<NekobusData>("nekobus::data");
	
	public var element:String;
	public var buffer:gst.Buffer;
	
	public function new( _type:EventKind<NekobusData>, element:String, buffer:gst.Buffer ) {
		super(_type);
		this.element = element;
		this.buffer = buffer;
	}
}

class GstBusValue extends Event<GstBusValue> {
	static public var VALUE = new EventKind<GstBusValue>("value");
	
	public var element:String;
	public var valueType:String;
	public var value:Float;
	
	public function new( _type:EventKind<GstBusValue>, element:String, type:String, value:Float ) {
		super(_type);
		this.element = element;
		this.valueType = type;
		this.value = value;
	}
}

class Pipeline extends SimpleEventDispatcher {
	public var pipeline(default,null):gst.Pipeline;
	
	public var duration(get_duration,null):Float;
	public var position(get_position,set_position):Float;
	
	public function get_duration() :Float {
		return pipeline.duration();
	}
	public function get_position() :Float {
		return pipeline.position();
	}
	public function set_position( to:Float ) :Float {
		return seekTo( to, 1.0 );
	}
	public function seekTo( to:Float, ?rate:Float ) :Float {
		if(rate==null) rate=1.0;
		pipeline.seek( to, rate );
		return pipeline.position();
	}

	public function findChild( name:String ) :gst.Object {
		return pipeline.findChild(name);
	}

	public function new( launch:String) :Void {
		super();
		pipeline = new gst.Pipeline( launch );

		Root.addEventListener( FrameEvent.ENTER_FRAME, step );
	}

	private function step(e:FrameEvent) :Void {
		pipeline.pollAllBusMessages( handleBusMessage );
	}

	private function handleBusMessage( msg:GstBusMessage ) :Void {
		if( msg.name=="nekobus::data" && untyped msg.element!=null && untyped msg.buffer!=null ) {
			postEvent( new NekobusData( NekobusData.DATA, 
				new String( untyped msg.element ),
				new gst.Buffer( untyped msg.buffer ) ) );
		} else if( msg.name=="value" ) {
			postEvent( new GstBusValue( GstBusValue.VALUE, 
				new String( untyped msg.element ),
				new String( untyped msg.type ),
				untyped msg.value ));
		}
	}
}
