#include <neko.h>
#include <gst/gst.h>
#include <cptr.h> 
 
CPTR_LOCAL_HELPERS

#define error(msg,...) \
    raise_exception( msg, __FILE__, __LINE__, __VA_ARGS__ );

DEFINE_KIND(k_GObject);
DEFINE_KIND(k_GClosure);
DEFINE_KIND(k_GstBuffer);

void raise_exception( const char *msg, const char *file, int line, ... ) {
    buffer b = alloc_buffer("");
    buffer_append(b,msg);
    _neko_failure( buffer_to_string(b), file, line );
}


/* --------------------------------------------------
    Helper
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


/* get string from value (even if it is a HaXe String) */
const char *haxe_string( value s ) {
    if( val_is_string(s) ) {
        return val_string(s);
    } else if( val_is_object(s) ) {
        value v = val_field(s,val_id("__s"));
        return haxe_string(v);
    } else {
        error("not a string",s);
        return NULL;
    }
}

/* GstBuffer */

void neko_gst_buffer_gc( value b ) {
	GstBuffer *buf = (GstBuffer*)val_data(b);
	if( buf!=NULL ) {
//		gst_buffer_unref(buf);
	}
}

value alloc_gstbuffer( GstBuffer *buf ) {
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

value gst_buffer_data( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	return cptr_wrap_foreign( GST_BUFFER_DATA(buf), GST_BUFFER_SIZE(buf) );
}
DEFINE_PRIM(gst_buffer_data,1);

value gst_buffer_size( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	return alloc_int( GST_BUFFER_SIZE(buf) );
}
DEFINE_PRIM(gst_buffer_size,1);

value gst_buffer_free( value b ) {
	GstBuffer *buf = val_gstbuffer(b);
	if( !buf ) return val_null;
	gst_buffer_unref(buf);
	// assure the abstract is unusable
	val_kind(b)=NULL;
	// and will not be garbage-collected
	val_gc( b, NULL );
	return val_null;
}
DEFINE_PRIM(gst_buffer_free,1);

/* convert GValue to neko value */
value gvalue_to_neko( const GValue *gv ) {
    switch( G_VALUE_TYPE(gv) ) {
        case G_TYPE_STRING:
            return alloc_string( g_value_get_string(gv) );
        case G_TYPE_BOOLEAN:
            return alloc_bool( g_value_get_boolean(gv) );
        case G_TYPE_INT:
            return alloc_int( g_value_get_int(gv) );
        case G_TYPE_FLOAT:
            return alloc_float( g_value_get_float(gv) );
		case G_TYPE_POINTER:
			return cptr_wrap_foreign( g_value_get_pointer(gv), 0 );
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

/* convert neko value to GValue*/
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



/* --------------------------------------------------
    GObject
   -------------------------------------------------- */

/* object_get */
value object_get( value obj, value prop ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    const char *name = haxe_string(prop);
    GParamSpec *spec = g_object_class_find_property( G_OBJECT_GET_CLASS(o), name );
    if( !spec ) {
        error("property not found", prop, obj );
        return val_null;
    }

    GValue gv;
    memset( &gv, 0, sizeof( gv ) );
    g_value_init( &gv, G_PARAM_SPEC_VALUE_TYPE(spec) );
    g_object_get_property( o, haxe_string( prop ), &gv );
        
    value result = gvalue_to_neko( &gv );

    return result;
}
DEFINE_PRIM(object_get,2);


/* object_set */
value object_set( value obj, value prop, value val ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    GValue gv;
    memset( &gv, 0, sizeof( gv ) );
    neko_to_gvalue( val, &gv );
    
    
    g_object_set_property( o, haxe_string( prop ), &gv );
    
    return;
}
DEFINE_PRIM(object_set,3);

/* --------------------------------------------------
    GClosure/Neko marshaller
   -------------------------------------------------- */

typedef struct _NekoClosure  {
  GClosure closure;
  /* extra data goes here */
} NekoClosure;
    
typedef struct _NekoCallback {
	value callback;
	GClosure *closure;
} NekoCallback;

void neko_marshal( GClosure *closure, GValue *g_result, guint nr_vals, const GValue *g_vals, gpointer invocation_hint, gpointer marshal_data ) {
    int i;
g_message("HANDOFF");
	NekoCallback *callback = (NekoCallback*)closure->data;
    value f = callback->callback;
    value *n_vals = (value*)malloc( sizeof(value*)*nr_vals );
    value n_result = val_null;
    
    for( i=0; i<nr_vals; i++ ) {
        n_vals[i] = gvalue_to_neko( &g_vals[i] );
    }

	neko_vm_current();
g_message("HANDOFF 2: %p", f);
    n_result = val_callEx( val_null, f, n_vals, nr_vals, NULL );
g_message("HANDOFF 3");
    
    free(n_vals);

    if( g_result != NULL ) {
        neko_to_gvalue( n_result, g_result );
    }
}

static void neko_closure_finalize( gpointer notify_data, GClosure *closure ) {
  NekoClosure *neko_closure = (NekoClosure*)closure;

  /* free extra data here */
}

NekoCallback *neko_closure_new( value func ) {
	NekoCallback *callback;

	callback = (NekoCallback*)alloc( sizeof(NekoCallback) );
	callback->closure = g_closure_new_simple( sizeof(NekoClosure), callback );
	callback->callback = func;
	
	/* initialize extra data here */

	//  g_closure_add_finalize_notifier( closure, notify_data, neko_closure_finalize );
	g_closure_set_marshal( callback->closure, (GClosureMarshal)neko_marshal );
	return callback;
}

/* object_set */
value object_connect( value obj, value v_signal_name, value func ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    const char *signal_name = haxe_string( v_signal_name );
    NekoCallback *callback = neko_closure_new( func );
    gulong id = g_signal_connect_closure( o, signal_name, (GClosure*)callback->closure, FALSE );
    
    return alloc_abstract( k_GClosure, callback );
}
DEFINE_PRIM(object_connect,3);

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

value gst_structure_to_neko( GstStructure *struc ) {
	value obj = alloc_object(NULL);
	alloc_field( obj, val_id( "name" ), alloc_string( gst_structure_get_name(struc) ) );
	gst_structure_foreach( struc, gst_structure_to_neko_value_iterate, obj );
	return obj;
}

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
		return( gst_structure_to_neko( msg->structure ) );
	}
	
    return val_null;
}
DEFINE_PRIM(poll_bus,2);



/* --------------------------------------------------
    GStreamer
   -------------------------------------------------- */

/* parse_launch */
value parse_launch( value def ) {
    GError *err;
    const char *d = haxe_string( def );
	GstElement *e = gst_parse_launch(d,&err);
	if( !e ) return val_null;
    gst_element_set_state( e, GST_STATE_PLAYING );
		g_message("Launch pipeline: %p\n", e );
    return alloc_gobject( G_OBJECT(e) );
}
DEFINE_PRIM(parse_launch,1);

/* find_child */
value find_child( value obj, value n ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    if( !GST_IS_BIN( o ) ) {
        error("not a bin", obj );
        return val_null;
    }
    
    GstBin *bin = GST_BIN(o);
    GstElement *e = gst_bin_get_by_name( bin, haxe_string(n) );
    
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

value seek( value obj, value t ) {
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

	if( gst_element_seek( GST_ELEMENT(o), 1.0, GST_FORMAT_TIME,
			GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_KEY_UNIT, 
			GST_SEEK_TYPE_SET, time, GST_SEEK_TYPE_NONE, GST_CLOCK_TIME_NONE ) ) {
		return val_true;
	}
	
	return val_false;
}
DEFINE_PRIM(seek,2);

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

/* init */
DEFINE_ENTRY_POINT(neko_gst_init);
vkind k_cptr;
void neko_gst_init() {
	k_cptr = kind_import("cptr");
	if( !k_cptr ) {
		DEFINE_KIND(_k_cptr);
		kind_export(_k_cptr,"cptr");
		k_cptr = kind_import("cptr");
	}

    g_thread_init(NULL);
	gst_init( NULL, NULL );
}


/* trigger neko GC */
value trigger_gc() {
	neko_gc_major();
	return val_true;
}
DEFINE_PRIM(trigger_gc,0);
