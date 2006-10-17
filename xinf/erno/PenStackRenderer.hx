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

package xinf.erno;

import xinf.erno.DrawingInstruction;

class Pen {
	public var fillColor:Color;
	public var strokeColor:Color;
	public var strokeWidth:Float;
	
	public var fontFace:String;
	public var fontSlant:FontSlant;
	public var fontWeight:FontWeight;
	public var fontSize:Float;
	
	public function new() :Void {
	}
	
	public function clone() :Pen {
		var p = new Pen();
		p.fillColor = fillColor;
		p.strokeColor = strokeColor;
		p.strokeWidth = strokeWidth;
		p.fontFace = fontFace;
		p.fontSlant = fontSlant;
		p.fontWeight = fontWeight;
		p.fontSize = fontSize;
		return p;
	}
}

class PenStackRenderer extends Renderer {
	private var pen:Pen;
	private var pens:Array<Pen>;

	public function new() :Void {
		pens = new Array<Pen>();
		pen = new Pen();
		pen.fontFace = "Kassiopeia09T_09_sp60_cyr30";
		pen.fontSize = 16.0;
		pen.fontWeight = Normal;
		pen.fontSlant = Roman;
	}
	
	public function pushPen() :Void {
		pens.push(pen);
		pen = pen.clone();
	}
	
	public function popPen() :Void {
		pen = pens.pop();
		if( pen==null ) throw("Pen Stack underflow");
	}
	
	public function draw( i:DrawingInstruction ) :Void {
		switch( i ) {
			case SetFill(c):
				pen.fillColor=c;
			case SetStroke(c,w):
				pen.strokeColor=c;
				pen.strokeWidth=w;
			case SetFont(face,slant,weight,size):
				pen.fontFace = face;
				pen.fontSlant = slant;
				pen.fontWeight = weight;
				pen.fontSize = size;

			default:
				super.draw(i);
		}
	}
}
