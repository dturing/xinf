/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */
	
package xinf.ul;

import Xinf;
import xinf.erno.ImageData;
import xinf.event.ImageLoadEvent;
import xinf.ul.layout.Helper;

class ImageComponent extends Component {
	
	var image:Image;
	var imageData:ImageData;

	public function new( i:ImageData, ?traits:Dynamic ) :Void {
		super();
		image = new Image();
		if( i!=null ) image.bitmap = i;
		imageData = i;
		
		group.appendChild( image );
		
		i.addEventListener( ImageLoadEvent.FRAME_AVAILABLE, dataChanged );
		i.addEventListener( ImageLoadEvent.PART_LOADED, dataChanged );
		i.addEventListener( ImageLoadEvent.LOADED, dataChanged );
	}

	override public function set_size( s:TPoint ) :TPoint {
		image.width = s.x;
		image.height = s.y;
		return super.set_size(s);
	}

	private function dataChanged( e:ImageLoadEvent ) :Void {
		if( size.x==0 && size.y==0 ) {
			setPrefSize( Helper.addPadding( { x:imageData.width, y:imageData.height }, this ) );
		}
	}
	
}
