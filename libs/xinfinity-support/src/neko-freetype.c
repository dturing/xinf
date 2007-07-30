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

#include <ft2build.h>
#include FT_FREETYPE_H

#include <neko.h>

#ifdef val_check
#undef val_check
#endif
#define val_check(v,t) if( !val_is_##t(v) ) failure("argument " #v " is not a " #t );
#ifdef val_check_kind
#undef val_check_kind
#endif
#define val_check_kind(v,k) if( !val_is_kind(v,k) ) failure("argument " #v " is not of kind " #k );


static FT_Library ft_library;

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

DEFINE_KIND(k_ft_face);

void _font_finalize( value v ) {
    fprintf(stderr,"FINALIZE font %p\n", val_data(v) );
    free( val_data(v) );
}

void ft_init() {
	if( FT_Init_FreeType( &ft_library ) ) {
		failure("Could not initialize FreeType");
	}
}
DEFINE_ENTRY_POINT(ft_init)

value ftLoadFont( value _data, value _width, value _height ) {
	val_check(_data,string);
	val_check(_width,number);
	val_check(_height,number);
	
	int width = val_number(_width);
	int height = val_number(_height);
	
    value font = alloc_object(NULL);
    FT_Face *face = (FT_Face*)malloc( sizeof(FT_Face) );
    
    if( !face || FT_New_Memory_Face( ft_library, (const FT_Byte*)val_string(_data), val_strlen(_data), 0, face ) ) {
        val_throw( alloc_string("FreeType cannot read font"));
    }
    
    FT_Set_Char_Size( *face, width, height, 72, 72 );
    
    int n_glyphs = (*face)->num_glyphs;
    
    // set some global metrics/info
    alloc_field( font, val_id("family_name"), alloc_string((*face)->family_name) );
    alloc_field( font, val_id("style_name"), alloc_string((*face)->style_name) );
    
    alloc_field( font, val_id("ascender"), alloc_int((*face)->ascender) );
    alloc_field( font, val_id("descender"), alloc_int((*face)->descender) );
    alloc_field( font, val_id("units_per_EM"), alloc_int((*face)->units_per_EM) );
    alloc_field( font, val_id("height"), alloc_int((*face)->height) );
    alloc_field( font, val_id("max_advance_width"), alloc_int((*face)->max_advance_width) );
    alloc_field( font, val_id("max_advance_height"), alloc_int((*face)->max_advance_height) );
    alloc_field( font, val_id("underline_position"), alloc_int((*face)->underline_position) );
    alloc_field( font, val_id("underline_thickness"), alloc_int((*face)->underline_thickness) );

    value __f = alloc_abstract( k_ft_face, face );
    val_gc( __f, _font_finalize );
    alloc_field( font, val_id("__f"), __f );
    
    //fprintf(stderr,"Load Font %p\n", face );

    return font;
}
DEFINE_PRIM(ftLoadFont,3);

void importGlyphPoints( FT_Vector *points, int n, value callbacks, field lineTo, field curveTo, bool cubic ) {
    value arg[4];
    int i;
	if( n==0 ) {
        val_ocall2( callbacks, lineTo, 
                    alloc_int( points[0].x ), alloc_int( points[0].y ) );
	} else if( n==1 ) {
        arg[0] = alloc_int( points[0].x );
        arg[1] = alloc_int( points[0].y );
        arg[2] = alloc_int( points[1].x );
        arg[3] = alloc_int( points[1].y );
        val_ocallN( callbacks, curveTo, arg, 4 );
	} else if( n>=2	) {
		if( cubic ) {
			// printf(stderr,"ERROR: cubic beziers in fonts are not yet implemented.\n");
		} else {
			int x1, y1, x2, y2, midx, midy;
			for( i=0; i<n-1; i++ ) { 
				x1 = points[i].x;
				y1 = points[i].y;
				x2 = points[i+1].x;
				y2 = points[i+1].y;
				midx = x1 + ((x2-x1)/2);
				midy = y1 + ((y2-y1)/2);
                
                arg[0] = alloc_int( x1 );
                arg[1] = alloc_int( y1 );
                arg[2] = alloc_int( midx );
                arg[3] = alloc_int( midy );
                val_ocallN( callbacks, curveTo, arg, 4 );
			}
            arg[0] = alloc_int( x2 );
            arg[1] = alloc_int( y2 );
            arg[2] = alloc_int( points[n].x );
            arg[3] = alloc_int( points[n].y );
            val_ocallN( callbacks, curveTo, arg, 4 );
		}
	} else {
	}
}

value ftRenderGlyph( value font, value _index, value _size, value _hint ) {
    if( !val_is_object(font) ) {
        ft_failure_v("not a freetype font face: ", font );
    }
    value __f = val_field( font, val_id("__f") );
    if( __f == NULL || !val_is_abstract( __f ) || !val_is_kind( __f, k_ft_face ) ) {
        ft_failure_v("not a freetype font face: ", font );
    }
    FT_Face *face = val_data( __f );

    val_check( _size, number );
    int size = val_number(_size);
    FT_Set_Char_Size( *face, size, size, 72, 72 );
    
    val_check( _hint, bool );
    int hint = val_bool(_hint);
    
    val_check(_index,number);
    /*
    int index = FT_Get_Char_Index( *face, (FT_UInt) val_number(_index) );
    fprintf( stderr, "char %i is glyph %i\n", (int)val_number(_index), (int)index );
    int err = FT_Load_Glyph( *face, index, FT_LOAD_RENDER | FT_LOAD_NO_HINTING );
        fprintf( stderr, "Load Glyph idx %i->%i/%i, sz %i, face %p: err 0x%x\n",
                (int)val_number(_index), index, 
                (int)((*face)->num_glyphs), size>>6, face, err );
    */
    int err = FT_Load_Char( *face, (FT_ULong)val_number(_index), FT_LOAD_RENDER | (hint?0:FT_LOAD_NO_HINTING) );
    if( err ) { 
        
        fprintf( stderr, "Load_Char failed: %x char index %i\n", err, FT_Get_Char_Index( *face, (FT_UInt) val_number(_index) ) );
        val_throw(alloc_string("Could not load requested Glyph"));
   //     return( val_null );
    }
    FT_GlyphSlot glyph = (*face)->glyph;
    /*
    err = FT_Render_Glyph( glyph, FT_RENDER_MODE_NORMAL );
    if( err || glyph->format != ft_glyph_format_bitmap ) {
        val_throw(alloc_string("Could not render requested Glyph"));
    }
    */
    FT_Bitmap bitmap = glyph->bitmap;

    value ret = alloc_object(NULL);
    alloc_field( ret, val_id("width"), alloc_int(bitmap.width) );
    alloc_field( ret, val_id("height"), alloc_int(bitmap.rows) );
    char *data = (char*)malloc( bitmap.width*bitmap.rows );
    memcpy( data, bitmap.buffer, bitmap.width*bitmap.rows );
    alloc_field( ret, val_id("bitmap"), alloc_string((char *)data) );
    alloc_field( ret, val_id("x"), alloc_int( glyph->metrics.horiBearingX ) );
    alloc_field( ret, val_id("y"), alloc_int( glyph->metrics.horiBearingY ) );
    alloc_field( ret, val_id("advance"), alloc_float( glyph->advance.x ));
    
    return ret;
}
DEFINE_PRIM(ftRenderGlyph,4);

value ftIterateGlyphs( value font, value callbacks ) {
    if( !val_is_object(callbacks) ) {
        ft_failure_v("not a callback function object: ", callbacks );
    }
// printf("A\n");
    field endGlyph = val_id("endGlyph");
    field startContour = val_id("startContour");
    field endContour = val_id("endContour");
    field lineTo = val_id("lineTo");
    field curveTo = val_id("curveTo");
// printf("B\n");
    
    if( !val_is_object(font) ) {
        ft_failure_v("not a freetype font face: ", font );
    }
    value __f = val_field( font, val_id("__f") );
    if( __f == NULL || !val_is_abstract( __f ) || !val_is_kind( __f, k_ft_face ) ) {
        ft_failure_v("not a freetype font face: ", font );
    }
    FT_Face *face = val_data( __f );
// printf("C\n");

	FT_UInt glyph_index;
	FT_ULong character;
	FT_Outline *outline;

    field f_character = val_id("character");
    field f_advance = val_id("advance");
    
    character = FT_Get_First_Char( *face, &glyph_index );

// printf("D\n");
    while( character != 0 ) {
        if( FT_Load_Glyph( *face, glyph_index, FT_LOAD_NO_BITMAP ) ) {
            // ignore (TODO report?)
        } else if( (*face)->glyph->format != FT_GLYPH_FORMAT_OUTLINE ) {
            // ignore (TODO)
        } else {
            outline = &((*face)->glyph->outline);
		    int start = 0, end, contour, p;
		    char control, cubic;
		    int n,i;
// printf("  1\n");
		    for( contour = 0; contour < outline->n_contours; contour++ ) {
			    end = outline->contours[contour];
			    n=0;

    
			    for( p = start; p<=end; p++ ) {
				    control = !(outline->tags[p] & 0x01);
				    cubic = outline->tags[p] & 0x02;

				    if( p==start ) {
                        val_ocall2( callbacks, startContour, 
                                    alloc_int( outline->points[p-n].x ),
                                    alloc_int( outline->points[p-n].y ) );
				    }

				    if( !control && n > 0 ) {
					    importGlyphPoints( &(outline->points[(p-n)+1]), n-1, callbacks, lineTo, curveTo, cubic );
					    n=1;
				    } else {
					    n++;
				    }
			    }

			    if( n ) {
				    // special case: repeat first point
				    FT_Vector points[n+1];
				    int s=(end-n)+2;
				    for( i=0; i<n-1; i++ ) {
					    points[i].x = outline->points[s+i].x;
					    points[i].y = outline->points[s+i].y;
				    }
				    points[n-1].x = outline->points[start].x;
				    points[n-1].y = outline->points[start].y;

				    importGlyphPoints( points, n-1, callbacks, lineTo, curveTo, false );
			    }

			    start = end+1;
                val_ocall0( callbacks, endContour );
		    }

// printf("  2\n");
            val_ocall2( callbacks, endGlyph, alloc_int( character ), alloc_int( (*face)->glyph->advance.x ) );
// printf("  3\n");
        }
// printf("  E\n");
        character = FT_Get_Next_Char( *face, character, &glyph_index );
// printf("  F\n");
    }
    
// printf("  Goo\n");
    return val_true;
}
DEFINE_PRIM(ftIterateGlyphs,2);
