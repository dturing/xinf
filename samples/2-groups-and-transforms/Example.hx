/*  Copyright (c) the Xinf contributors.
	see http://xinf.org/copyright for license. */

import Xinf;

/**
	Example 2: Groups and Transforms.
	
	This example demonstrates using Groups to 
	construct a display hierarchy 
	and using some simple transformations.
*/

class Example {
	
	public static function main() :Void {
		
		/* Create a Group (~= container), 
		   fill it with two Rectangles,
		   and attach it to Root. */
		   
		var group = new Group();
		group.appendChild( new Rectangle({ width:100, height:100, fill:"blue" }) );
		group.appendChild( new Rectangle({ x:25, y:25, width:50, height:50, fill:"yellow" }) );
		Root.appendChild( group );


		/*
		   The "transform" property, which exists on all svg shapes (not just Group),
		   can be set to any class implementing xinf.geom.Transform-- 
		   possible values:
			group.transform = new Translate( 100, 100 );
			group.transform = new Matrix( { tx:1., ty:2., a:3., b:4., c:5., d:6. } );
			group.transform = new Rotate( 45 );
			group.transform = new Scale( 1.5, 0.5 );
			group.transform = new Identity();
			group.transform = new TransformList([
										new Rotate(45),
										new Translate(100,10),
										new Scale(2,2)
									]);
			
			- deprecated, but still works: -
			group.transform = new Concatenate( new Rotate(45), new Scale(2,2) );
		*/


		// Move the whole group to 100,100. 
		group.transform = new Translate( 100, 100 );


		/* Pass control to the xinf main loop */
		Root.main();
		
	}
}
