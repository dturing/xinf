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
    public var position(get_position,seekTo):Float;
    
    public function get_duration() :Float {
        return pipeline.duration();
    }
    public function get_position() :Float {
        return pipeline.position();
    }
    public function seekTo( to:Float ) :Float {
        pipeline.seek( to );
        return pipeline.position();
    }

    public function findChild( name:String ) :gst.Object {
        return pipeline.findChild(name);
    }

    public function new( launch:String) :Void {
        super();
        trace("launch pipe "+launch );
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
