/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

/**
	Example 6: Images.
	
	Valid hrefs:	
		on all platforms
			http:// 
				(on flash, security restrictions apply)
			resource://<name of resource>
			
		on neko,
			file:// 
			relative urls are relative to the current working directory
			
			
*/

class Example {
	
	public static function main() :Void {
		
		var href = "http://xinf.org/misc/lena.jpg";
		
		var image = new Image({
				x:10, y:10,	href:href,
				width:100, height:100,
			});
		Root.appendChild( image );
		
		Root.main();
		
	}
}

