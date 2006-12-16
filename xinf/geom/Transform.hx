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

package xinf.geom;

import xinf.geom.Types;

// might be extended with more lightweight Translation/TransScale
	// might be good to do a IdentityTransform that just returns on apply,
	//  and get rid of the if(transform==null) checks below.

typedef Transform = Matrix
/*{
	apply:TPoint->TPoint,
	applyInverse:TPoint->TPoint,
	tx:Int,	ty:Int // for speedy access if translation is the only interesting thing.
}
*/
