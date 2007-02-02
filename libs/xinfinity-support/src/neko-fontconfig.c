/***********************************************************************

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
   
***********************************************************************/

#include <fontconfig/fontconfig.h>

#include <neko/neko.h>

#ifdef val_check
#undef val_check
#endif
#define val_check(v,t) if( !val_is_##t(v) ) failure("argument " #v " is not a " #t );
#ifdef val_check_kind
#undef val_check_kind
#endif
#define val_check_kind(v,k) if( !val_is_kind(v,k) ) failure("argument " #v " is not of kind " #k );

/*
void ft_failure_2s( const char *one, const char *two ) {
    buffer b = alloc_buffer(one);
    buffer_append(b,two);
    val_throw(buffer_to_string(b));
}

void ft_failure_v( const char *one, value v ) {
    buffer b = alloc_buffer(one);
    val_buffer(b,v);
    val_throw(buffer_to_string(b));
}

*/
void fc_init() {
	if( !FcInit() ) 
		failure("Could not initialize FreeType");
}

value fcFindFont( value _familyName, value _weight, value _slant, value _size ) {
	val_check(_familyName,string);
	val_check(_weight,number);
	val_check(_slant,number);
	val_check(_size,number);
    
    const char *familyName = val_string(_familyName);
    int weight = val_number(_weight);
    int slant = val_number(_slant);
    float size = val_number(_size);
    
	FcPattern *pattern;
    
	pattern = FcNameParse( (FcChar8*)familyName );

	FcDefaultSubstitute( pattern );
	FcConfigSubstitute( FcConfigGetCurrent(), pattern, FcMatchPattern );
	
	FcResult result;
	FcPattern *match = FcFontMatch( 0, pattern, &result );
	
	FcPatternDestroy( pattern );
	
	if( !match ) val_throw(alloc_string("Could not find font"));
	
	FcChar8 *temp;
	int id;
	pattern = FcPatternDuplicate(match);
	if( FcPatternGetString( pattern, FC_FILE, 0, &temp ) != FcResultMatch ||
	    FcPatternGetInteger( pattern, FC_INDEX, 0, &id ) != FcResultMatch ) {
		val_throw(alloc_string("Could not load font"));
	}
	value ret = alloc_string((const char *)temp);
	
	FcPatternDestroy( pattern );
	FcPatternDestroy( match );
	
	return ret;
}
DEFINE_PRIM(fcFindFont,4);

value fcListFonts( value v_add ) {
	int i;
	FcFontSet *fonts = FcConfigGetFonts( 0, FcSetSystem );
	if( fonts == NULL ) val_throw( alloc_string("Fontconfig couldn't find any fonts") );
	
	for( i=0; i<fonts->nfont; i++ ) {
		FcPattern *font = fonts->fonts[i];
		
		FcChar8 *familyName;
		FcChar8 *style;
		int weight, slant;
		bool outline;
		
		FcPatternGetBool( font, FC_OUTLINE, 0, &outline );
		if( outline ) {
			FcPatternGetString( font, FC_FAMILY, 0, &familyName );
			FcPatternGetString( font, FC_STYLE, 0, &style);
			FcPatternGetInteger( font, FC_WEIGHT, 0, &weight);
			FcPatternGetInteger( font, FC_SLANT, 0, &slant);
			
	//		name = FcNameUnparse( font );
	//		printf("\nFont: %s || %s\n", familyName, style );
	//		FcPatternPrint( font );
	
			value arg[4] = {
				alloc_string((const char *)familyName), alloc_string((const char *)style),
				alloc_int(weight), alloc_int(slant)
			};
			
			val_callN( v_add, arg, 4 );
		}
	}
}
DEFINE_PRIM( fcListFonts, 1 );
