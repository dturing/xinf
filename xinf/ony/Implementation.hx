/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.ony;

#if xinfony_null
typedef ElementImpl = xinf.ony.Element
typedef GroupImpl = xinf.ony.Group
#else true
typedef ElementImpl = xinf.ony.erno.Element
typedef GroupImpl = xinf.ony.erno.Group
#end