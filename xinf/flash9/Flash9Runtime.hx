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

package xinf.flash9;

import xinf.erno.SimpleRuntime;
import xinf.erno.Renderer;
import xinf.event.FrameEvent;

class Flash9Runtime extends SimpleRuntime {
    
    public static var defaultRoot:NativeContainer;
    
    private var _eventSource:Flash9EventSource;

    public function new() :Void {
        super();
        _eventSource = new Flash9EventSource(this);
        
        #if htmltrace
            // setup trace to javascript FIXME this is b0rked. i get securityerrors since flash9, which need stupid web-auth.
            try {
                var ttrace = function( v:Dynamic, ?pos:haxe.PosInfos ) {
                    flash.external.ExternalInterface.call("haxeTrace",v,pos);
                }
                haxe.Log.trace = ttrace;
                //fixLinuxTrace();
                
                trace("trace seems fine");
            } catch( e:Dynamic ) {
                fixLinuxTrace();
                trace("Exception trying to setup HTML trace: "+e );
            }
        #else true
            fixLinuxTrace();
        #end
    }
    
    function fixLinuxTrace() {
        var mc = flash.Lib.current;
        var tf = new flash.text.TextField();
        tf.selectable = false;
        tf.width = mc.stage.stageWidth;
        tf.autoSize = flash.text.TextFieldAutoSize.LEFT;

        var format:flash.text.TextFormat = tf.getTextFormat();
        format.font = "_sans";
        tf.defaultTextFormat = format;
        mc.addChild(tf); // TODO stay on top
        
        var ttrace = function( v:Dynamic, ?pos:haxe.PosInfos ) {
            mc.removeChild(tf);
            mc.addChild(tf);
            
            tf.text += v+"\n";
        }
        haxe.Log.trace = ttrace;
    }
    
    override public function getDefaultRoot() :NativeContainer {
        if( defaultRoot==null ) {
            defaultRoot = new XinfSprite();
            flash.Lib.current.stage.addChild(defaultRoot);
        }
        return defaultRoot;
    }
    
    override public function run() :Void {
        _eventSource.rootResized();
    }
    
}