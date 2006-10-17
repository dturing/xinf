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

package demo.inity;

import xinf.event.FrameEvent;
import xinf.erno.Runtime;
import xinf.erno.Color;
import xinf.erno.Renderer;
import xinf.erno.DrawingInstruction;

import xinf.ony.Object;
import xinf.ony.Root;
import xinf.ony.Image;

import xinf.ul.ListBox;
import xinf.ul.ListModel;
import xinf.ul.PickEvent;
import xinf.ul.Slider;
import xinf.ul.VBox;
import xinf.ul.ValueEvent;

import xinf.inity.font.FontList;

class FontTest extends Object {
	public var font(get_font,set_font):String;
	private var _font:String;
	private function get_font():String {
		return _font;
	}
	private function set_font(f:String) :String {
		_font = f;
		scheduleRedraw();
		return _font;
	}
	
	public var rotation(get_rotation,set_rotation):Float;
	private var _rotation:Float;
	private function get_rotation():Float {
		return _rotation;
	}
	private function set_rotation(r:Float):Float {
		_rotation=r;
		scheduleRedraw();
		return _rotation;
	}

	public var fontSize(get_fontSize,set_fontSize):Float;
	private var _fontSize:Float;
	private function get_fontSize():Float {
		return _fontSize;
	}
	private function set_fontSize(s:Float) :Float {
		_fontSize = s;
		scheduleRedraw();
		return _fontSize;
	}

	public function new( ?font:String ) :Void {
		super();
		if( font==null ) font="_sans";
		this._font=font;
		_rotation=0;
		fontSize = 20;
	}
	
	public function drawContents( g:Renderer ) :Void {
		g.draw( Rotate( _rotation ) );
		g.draw( Translate(position.x,position.y) );
		g.draw( SetFill(Color.BLACK) );
		g.draw( SetFont( font, Roman, Normal, fontSize ) );
		g.draw( Text( "the quick brown bär\njumps over the lazy dog" ) );
	}
}

class FontView {
	static var view:FontView;

	var styleList:ListBox<String>;
	var fontList:ListBox<String>;
	var sizer:Slider;
	var rot:Slider;
	var fontlist:FontList;
	var sample:FontTest;

	private static var root:Object;
	public static function main() :Void {
		Runtime.init();
		
		root = new Root();
		xinf.ul.GrayStyle.addToDefault();
		
		view = new FontView();

		Runtime.run();
	}

	public function new() :Void {
		fontlist = new FontList();

		var box = new VBox();
		box.moveTo( 10, 10 );
		box.resize( 150, 400 );
		root.attach( box );

		var fontModel = new SimpleListModel();
		for( font in fontlist.list.keys() ) {
			fontModel.addItem(font);
		}
		fontModel.sort();
		
		fontList = new ListBox( fontModel );
		fontList.resize( 150, 150 );
		box.attach( fontList );

		var styleModel = new SimpleListModel();

		styleList = new ListBox( styleModel );
		styleList.resize( 150, 60 );
		box.attach( styleList );

		sizer = new Slider( 1000, 6, 1 );
//		sizer.moveTo( 220, 120 );
		sizer.resize( 100, 20 );
		sizer.value = 20;
		box.attach( sizer );

		rot = new Slider( 360, 0, .1 );
//		rot.moveTo( 220, 150 );
		rot.resize( 100, 20 );
		rot.value = 0;
		box.attach( rot );

		sample = new FontTest();
		sample.moveTo( 190, 30 );
		root.attach( sample );

		var self=this;

		fontList.addEventListener( PickEvent.ITEM_PICKED, function( e:PickEvent<String> ) {
			self.chooseFont( e.item );
		});

		styleList.addEventListener( PickEvent.ITEM_PICKED, function( e:PickEvent<String> ) {
			self.setFont();
		});
		
		sizer.addEventListener( ValueEvent.CHANGED, function(e:ValueEvent) :Void {
			self.setFont();
		});

		rot.addEventListener( ValueEvent.CHANGED, function(e:ValueEvent) :Void {
			self.sample.rotation = e.value;
		});	
	}
	
	
	public function chooseFont( f:String ) :Void {
		var styleModel = new SimpleListModel();
		for( style in fontlist.list.get( f ).keys() ) {
			styleModel.addItem(style);
			styleList.setModel(styleModel);
		}
	}
	
	public function setFont() :Void {
		sample.fontSize = sizer.value;
		sample.font = fontList.getCurrentItem(); //+" "+styleList.getCurrentItem();
	}
}
