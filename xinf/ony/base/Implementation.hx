/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony.base;

#if xinfony_null
typedef ElementImpl = xinf.ony.base.Element
typedef GroupImpl = xinf.ony.base.Group
#else true
typedef ElementImpl = xinf.ony.erno.Element
typedef GroupImpl = xinf.ony.erno.Group
#end