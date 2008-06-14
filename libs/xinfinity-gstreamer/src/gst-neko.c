#include <neko/neko.h>
#include <gst/gst.h>
#include <memory.h>
#include <string.h>

DEFINE_KIND(k_GObject);
DEFINE_KIND(k_GClosure);
DEFINE_KIND(k_GstBuffer);

#define error(msg,...) \
    raise_exception( msg, __FILE__, __LINE__, __VA_ARGS__ );

void raise_exception( const char *msg, const char *file, int line, ... ) {
    buffer b = alloc_buffer("");
    buffer_append(b,msg);
    _neko_failure( buffer_to_string(b), file, line );
}


/* --------------------------------------------------
    Object Helper
   -------------------------------------------------- */

GObject *val_gobject( value obj ) {
    if( !val_is_abstract(obj) || !val_is_kind( obj, k_GObject ) ) {
        error("not a GObject",obj);
        return NULL;
    }
    GObject *o = (GObject*)val_data(obj);
    if( !o ) {
        error("GObject is null",obj);
        return NULL;
    }
    return o;
}

value alloc_gobject( GObject * o ) {
    return alloc_abstract( k_GObject, o );
}

/* --------------------------------------------------
	GstBuffer Helper
   -------------------------------------------------- */

void neko_gst_buffer_gc( value b ) {
	GstBuffer *buf = (GstBuffer*)val_data(b);
	if( buf!=NULL ) {
		//printf("unref %p\n", buf );
		gst_buffer_unref(buf);
		val_data(b)=NULL;
	}
}

value alloc_gstbuffer( GstBuffer *buf ) {
// usually, we should ref it... but nekobus msg leaves the buffer ref'd or else it is already gone when we receive the bus msg.
	//printf("alloc %p\n", buf );
	value b = alloc_abstract( k_GstBuffer, buf );
	val_gc( b, neko_gst_buffer_gc );
	return b;
}


GstBuffer *val_gstbuffer( value obj ) {
    if( !val_is_abstract(obj) || !val_is_kind( obj, k_GstBuffer ) ) {
        error("not a GstBuffer",obj);
        return NULL;
    }
    GstBuffer *o = (GstBuffer*)val_data(obj);
    if( !o ) {
        error("GstBuffer is NULL",obj);
        return NULL;
    }
    return o;
}

/* --------------------------------------------------
	neko value->GValue and back
   -------------------------------------------------- */
void neko_to_gvalue( value v, GValue *gv ) {
    value s;
	if( val_is_null(v) ) {
        g_value_init( gv, G_TYPE_INT );
        g_value_set_int( gv, 0 );
	} else if( val_is_int(v) ) {
        g_value_init( gv, G_TYPE_INT );
        g_value_set_int( gv, val_number(v) );
	} else if( val_is_float(v) ) {
        g_value_init( gv, G_TYPE_FLOAT );
        g_value_set_float( gv, val_number(v) );
	} else if( val_is_bool(v) ) {
        g_value_init( gv, G_TYPE_BOOLEAN );
        g_value_set_boolean( gv, val_bool(v) );
	} else if( val_is_string(v) ) {
        g_value_init( gv, G_TYPE_STRING );
		printf("neko to gvalue, string %s\n", val_string(v) );
        g_value_set_string( gv, val_string(v) );
	} else if( val_is_object(v) ) {
        /* see if its a haxe String */
        s = val_field(v,val_id("__s"));
        if( s == val_null || !val_is_string(s) ) {
            error("cannot convert neko object to GValue",v);
            return;
        }
        g_value_init( gv, G_TYPE_STRING );
        g_value_set_string( gv, val_string(s) );
/*
	} else if( val_is_array(v) ) {
		printf("array : size %d",val_array_size(v));
	} else if( val_is_function(v) ) {
		printf("function : %d args",val_fun_nargs(v));
	} else if( val_is_object(v) ) {
		printf("object");
	} else if( val_is_abstract(v) ) {
		printf("abstract of kind %X",val_kind(v));
*/
	} else {
        error("cannot convert neko value to GValue", v );
    }
	return;
}

value gvalue_to_neko( const GValue *gv ) {
	const gchar *str;
    switch( G_VALUE_TYPE(gv) ) {
        case G_TYPE_STRING:
			str = g_value_get_string(gv);
            return copy_string( str, strlen(str) );
        case G_TYPE_BOOLEAN:
            return alloc_bool( g_value_get_boolean(gv) );
        case G_TYPE_INT:
            return alloc_int( g_value_get_int(gv) );
        case G_TYPE_FLOAT:
            return alloc_float( g_value_get_float(gv) );
        default:
            if( g_type_is_a( G_VALUE_TYPE(gv), GST_TYPE_BUFFER ) ) {
				return alloc_gstbuffer( (GstBuffer*)g_value_peek_pointer(gv) );
            } else if( g_type_is_a( G_VALUE_TYPE(gv), G_TYPE_OBJECT ) ) {
                return alloc_gobject( g_value_get_object(gv) );
            } else {
                //error("cannot convert GValue to neko value.",val_null);
               // printf("WARNING: cannot convert GValue (type %s) to neko.\n", g_type_name( G_VALUE_TYPE(gv) ) );
                return val_null;
            }
    }
}

/* --------------------------------------------------
    GstStructure helpers
   -------------------------------------------------- */
gboolean gst_structure_to_neko_value_iterate( GQuark field_id, const GValue *val, gpointer user_data ) {
	value obj = (value)user_data;
	value v = gvalue_to_neko( val );
	if( v != val_null ) 
		alloc_field( obj, val_id( g_quark_to_string(field_id) ), v);
	return true;
}

value gst_structure_to_neko( value obj, GstStructure *struc ) {
	const gchar *name = gst_structure_get_name(struc);
	alloc_field( obj, val_id( "name" ), copy_string( name, strlen(name) ) );
	gst_structure_foreach( struc, gst_structure_to_neko_value_iterate, obj );
	return obj;
}

/* --------------------------------------------------
	GstBuffer
   -------------------------------------------------- */

value gst_buffer_data( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	value ret = copy_string( GST_BUFFER_DATA(buf), GST_BUFFER_SIZE(buf) );
	return ret;
}
DEFINE_PRIM(gst_buffer_data,1);

value gst_buffer_size( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	return alloc_int( GST_BUFFER_SIZE(buf) );
}
DEFINE_PRIM(gst_buffer_size,1);

value gst_buffer_caps( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	GstCaps *caps = GST_BUFFER_CAPS(buf);
	if( !caps ) return val_null;

	// TODO: capture all caps, not just #0
	
	GstStructure *s = gst_caps_get_structure(caps,0);
	if( !s ) return val_null;
		
	value obj = alloc_object(NULL);
	const gchar *name = gst_structure_get_name(s);
	alloc_field( obj, val_id( "_name" ), copy_string( name, strlen(name) ));
	gst_structure_to_neko( obj, s );
	
// XXX
//		printf("buffer_caps: %s\n", gst_caps_to_string(caps) );
	return obj;
}
DEFINE_PRIM(gst_buffer_caps,1);

value gst_buffer_free( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	//gst_buffer_unref(buf);
	// assure the abstract is unusable
	val_kind(b)=NULL;
	// and will not be garbage-collected
	val_gc( b, NULL );
	return val_null;
}
DEFINE_PRIM(gst_buffer_free,1);


/* --------------------------------------------------
    GObject
   -------------------------------------------------- */

/* object_get */
value object_get( value obj, value prop ) {
	val_check( prop, string );
	
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    const char *name = val_string(prop);
    GParamSpec *spec = g_object_class_find_property( G_OBJECT_GET_CLASS(o), name );
    if( !spec ) {
        error("property not found", prop, obj );
        return val_null;
    }

    GValue gv;
    memset( &gv, 0, sizeof( gv ) );
    g_value_init( &gv, G_PARAM_SPEC_VALUE_TYPE(spec) );
    g_object_get_property( o, val_string( prop ), &gv );
        
    value result = gvalue_to_neko( &gv );

    return result;
}
DEFINE_PRIM(object_get,2);


/* object_set */
value object_set( value obj, value prop, value val ) {
	val_check( prop, string );
	
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    GValue gv;
    memset( &gv, 0, sizeof( gv ) );
    neko_to_gvalue( val, &gv );
    
    
    g_object_set_property( o, val_string( prop ), &gv );
    
    return;
}
DEFINE_PRIM(object_set,3);


/* --------------------------------------------------
    GstBus
   -------------------------------------------------- */

/* poll_bus */
value poll_bus( value obj, value timeout ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;

	int tout=-1;
    if( val_is_int(timeout) ) {
		tout = val_number(timeout);
    }
    
    if( !GST_IS_ELEMENT( o ) ) {
        error("not a GstElement", obj );
        return val_null;
    }
    
    GstBus *bus = gst_element_get_bus( GST_ELEMENT(o) );
	if( !bus ) {
		error("Element has no Bus?", obj);
		return val_null;
	}
	
	GstMessage *msg = gst_bus_poll( bus, GST_MESSAGE_EOS | GST_MESSAGE_ERROR | GST_MESSAGE_WARNING | GST_MESSAGE_INFO
										| GST_MESSAGE_TAG | GST_MESSAGE_BUFFERING | GST_MESSAGE_STEP_DONE 
										| GST_MESSAGE_SEGMENT_START | GST_MESSAGE_SEGMENT_DONE
										| GST_MESSAGE_STREAM_STATUS | GST_MESSAGE_APPLICATION | GST_MESSAGE_ELEMENT
					, tout );
	if( msg ) {
        value obj = alloc_object(NULL);
		const gchar *name = GST_MESSAGE_TYPE_NAME(msg);
        alloc_field( obj, val_id( "type" ), copy_string( name, strlen(name) ));
        if( msg->structure ) {
            gst_structure_to_neko( obj, msg->structure );
        }
		return( obj );
	}
	
    return val_null;
}
DEFINE_PRIM(poll_bus,2);



/* --------------------------------------------------
    GStreamer
   -------------------------------------------------- */

/* parse_launch */
value parse_launch( value def ) {
    GError *err=NULL;
	val_check( def, string );
    const char *d = val_string( def );
	GstElement *e = gst_parse_launch(d,&err);
	if( err ) {
		val_throw( alloc_string( "erroneous pipeline" ));// GST_STR_NULL(err->message) ) ); // doesnt work? FIXME
		g_error_free(err);
	}
	if( !e ) return val_null;
    gst_element_set_state( e, GST_STATE_PLAYING );
    return alloc_gobject( G_OBJECT(e) );
}
DEFINE_PRIM(parse_launch,1);

/* find_child */
value find_child( value obj, value n ) {
	val_check( n, string );
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    if( !GST_IS_BIN( o ) ) {
        error("not a bin", obj );
        return val_null;
    }
    
    GstBin *bin = GST_BIN(o);
    GstElement *e = gst_bin_get_by_name( bin, val_string(n) );
    
    if( !e ) return val_null;
    return alloc_gobject( G_OBJECT(e) );
}
DEFINE_PRIM(find_child,2);

/* queries/seek */
value query_position( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;

    if( !GST_IS_ELEMENT( o ) ) {
        error("not a GstElement", obj );
        return val_null;
    }
	
	guint64	v;
	GstFormat fmt = GST_FORMAT_TIME;
	
	if( gst_element_query_position( GST_ELEMENT(o), &fmt, &v ) ) {
		return alloc_float( ((double)v)/GST_SECOND );
	}
    return val_null;
}
DEFINE_PRIM(query_position,1);

value query_duration( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;

    if( !GST_IS_ELEMENT( o ) ) {
        error("not a GstElement", obj );
        return val_null;
    }
	
	guint64	v;
	GstFormat fmt = GST_FORMAT_TIME;
	
	if( gst_element_query_duration( GST_ELEMENT(o), &fmt, &v ) ) {
		return alloc_float( ((double)v)/GST_SECOND );
	}
    return val_null;
}
DEFINE_PRIM(query_duration,1);

value seek( value obj, value t, value rate ) {
	val_check(rate,number);
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    if( !GST_IS_ELEMENT( o ) ) {
        error("not a GstElement", obj );
        return val_null;
    }
	
	gint64 time=-1;
    if( val_is_float(t) ) {
		time= val_number(t) * GST_SECOND;
    }

	if( gst_element_seek( GST_ELEMENT(o), val_number(rate), GST_FORMAT_TIME,
			GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_KEY_UNIT, 
			GST_SEEK_TYPE_SET, time, GST_SEEK_TYPE_NONE, GST_CLOCK_TIME_NONE ) ) {
		return val_true;
	}
	
	return val_false;
}
DEFINE_PRIM(seek,3);

/* state */
value pipeline_pause( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    if( !GST_IS_ELEMENT( o ) ) {
        error("not a GstElement", obj );
        return val_null;
    }
	
	gst_element_set_state( GST_ELEMENT(o), GST_STATE_PAUSED );
	
	return val_true;
}
DEFINE_PRIM(pipeline_pause,1);

value pipeline_play( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    if( !GST_IS_ELEMENT( o ) ) {
        error("not a GstElement", obj );
        return val_null;
    }
	
	gst_element_set_state( GST_ELEMENT(o), GST_STATE_PLAYING );
	
	return val_true;
}
DEFINE_PRIM(pipeline_play,1);


/* --------------------------------------------------
   -------------------------------------------------- */

/* init */
DEFINE_ENTRY_POINT(neko_gst_init);
void neko_gst_init() {
    g_thread_init(NULL);
	gst_init( NULL, NULL );
}


/* trigger neko GC */
value trigger_gc() {
	neko_gc_major();
	return val_true;
}
DEFINE_PRIM(trigger_gc,0);
