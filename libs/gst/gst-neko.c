#include <neko.h>
#include <gst/gst.h>
//#include <cptr.h> 
 
#define error(msg,...) \
    raise_exception( msg, __FILE__, __LINE__, __VA_ARGS__ );

DEFINE_KIND(k_GObject);

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
        default:
            if( g_type_is_a( G_VALUE_TYPE(gv), G_TYPE_OBJECT ) ) {
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
    

void neko_marshal( GClosure *closure, GValue *g_result, guint nr_vals, const GValue *g_vals, gpointer invocation_hint, gpointer marshal_data ) {
    int i;
    value f = (value)closure->data;
    value *n_vals = (value*)malloc( sizeof(value*)*nr_vals );
    value n_result = val_null;
    
    for( i=0; i<nr_vals; i++ ) {
        n_vals[i] = gvalue_to_neko( &g_vals[i] );
    }

    n_result = val_callEx( val_null, f, n_vals, nr_vals, NULL );
    
    free(n_vals);

    if( g_result != NULL ) {
        neko_to_gvalue( n_result, g_result );
    }
}

static void neko_closure_finalize( gpointer notify_data, GClosure *closure ) {
  NekoClosure *neko_closure = (NekoClosure*)closure;

  /* free extra data here */
}

NekoClosure *neko_closure_new( gpointer data ) {
  GClosure *closure;
  NekoClosure *neko_closure;
  
  closure = g_closure_new_simple( sizeof(NekoClosure), data );
  neko_closure = (NekoClosure*)closure;

  /* initialize extra data here */

//  g_closure_add_finalize_notifier( closure, notify_data, neko_closure_finalize );
  g_closure_set_marshal( closure, (GClosureMarshal)neko_marshal );
  return neko_closure;
}

/* object_set */
value object_connect( value obj, value v_signal_name, value data ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    const char *signal_name = haxe_string( v_signal_name );
    NekoClosure *closure = neko_closure_new( (gpointer)data );
    gulong id = g_signal_connect_closure( o, signal_name, (GClosure*)closure, FALSE );
    
    return val_true;
}
DEFINE_PRIM(object_connect,3);


/* --------------------------------------------------
    GStreamer
   -------------------------------------------------- */

/* parse_launch */
value parse_launch( value def ) {
    GError *err;
    const char *d = haxe_string( def );
	GstElement *e = gst_parse_launch(d,&err);
    gst_element_set_state( e, GST_STATE_PLAYING );
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


GMutex *get_glmutex( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return NULL;

    GValue gv;
    memset( &gv, 0, sizeof( gv ) );
    g_value_init( &gv, G_TYPE_POINTER );
    g_object_get_property( o, "mutex", &gv );
	return( (GMutex*)g_value_get_pointer(&gv) );
}
GCond *get_glcond( value obj, const char *name ) {
    GObject *o = val_gobject( obj );
    if( !o ) return NULL;

    GValue gv;
    memset( &gv, 0, sizeof( gv ) );
    g_value_init( &gv, G_TYPE_POINTER );
    g_object_get_property( o, name, &gv );
	return( (GCond*)g_value_get_pointer(&gv) );
}
value lock_glmutex( value obj ) {
	GMutex *mutex = get_glmutex(obj);
	if( !mutex ) throw("Couldn't aquire GL mutex");
	g_mutex_lock( mutex );
	return val_true;
}
DEFINE_PRIM(lock_glmutex,1);

value unlock_glmutex( value obj ) {
	GMutex *mutex = get_glmutex(obj);
	if( !mutex ) throw("Couldn't aquire GL mutex");
	g_mutex_unlock( mutex );
	return val_true;
}
DEFINE_PRIM(unlock_glmutex,1);

value wait_texture_available( value obj ) {
	GCond *cond = get_glcond( obj, "texture_ready" );
	GMutex *mutex = get_glmutex(obj);
	if( !mutex || !cond ) throw("Couldn't aquire GL mutex/condition");
	g_cond_wait( cond, mutex );
	return val_true;
}
DEFINE_PRIM(wait_texture_available,1);

value set_texture_consumed( value obj ) {
	GCond *cond = get_glcond( obj, "texture_consumed" );
	GMutex *mutex = get_glmutex(obj);
	if( !mutex || !cond ) throw("Couldn't aquire GL mutex/condition");
	g_mutex_lock(mutex);
	g_cond_signal( cond );
	g_mutex_unlock(mutex);
	return val_true;
}
DEFINE_PRIM(set_texture_consumed,1);

/* locked conditions */
/*
DEFINE_KIND(k_Mutex);
value alloc_mutex( GMutex *mutex ) {
    return alloc_abstract(k_Mutex,mutex);
}
GMutex *val_mutex( value m ) {
    if( !val_is_abstract(m) || !val_is_kind(m,k_Mutex) ) {
        error("not a mutex",m);
        return NULL;
    }
    return (GMutex*)val_data(m);
}
*/
typedef struct _PingPong {
    GMutex *mutex;
    GCond *ping;
    GCond *pong;
    void *payload;
} PingPong;

PingPong *pingpong_new() {
    PingPong *pp = (PingPong*)g_malloc( sizeof( PingPong ) );
    pp->mutex = g_mutex_new();
    pp->ping  = g_cond_new();
    pp->pong  = g_cond_new();
    pp->payload = NULL;
    return pp;
}

void pingpong_free( PingPong *pp ) {
    if( pp->mutex ) g_free( pp->mutex );
    if( pp->ping  ) g_free( pp->ping );
    if( pp->pong  ) g_free( pp->pong );
    g_free( pp );
}

void pingpong_lock( PingPong *pp ) {
    g_mutex_lock( pp->mutex );
}

void pingpong_unlock( PingPong *pp ) {
    g_mutex_unlock( pp->mutex );
}

void pingpong_ping( PingPong *pp, void *payload ) {
    pp->payload = payload;
    g_cond_signal( pp->ping );
}
void pingpong_wait_ping( PingPong *pp, void **payload ) {
    g_cond_wait( pp->ping, pp->mutex );
    if( payload ) *payload = pp->payload;
}
void pingpong_pong( PingPong *pp ) {
    g_cond_signal( pp->pong );
}
void pingpong_wait_pong( PingPong *pp ) {
    g_cond_wait( pp->pong, pp->mutex );
}

DEFINE_KIND(k_PingPong);
value alloc_pingpong( PingPong *pp ) {
    return alloc_abstract(k_PingPong,pp);
}
PingPong *val_pingpong( value pp ) {
    if( !val_is_abstract(pp) || !val_is_kind(pp,k_PingPong) ) {
        error("not a ping-pong lock",pp);
        return NULL;
    }
    return (PingPong*)val_data(pp);
}


/* handoff */

void handle_handoff( GstElement *object, GstBuffer *arg0, gpointer user_data ) {
    PingPong *pp = (PingPong*)user_data;
    pingpong_lock(pp);
    pingpong_ping(pp, arg0);
//    g_message("PING");
    pingpong_wait_pong(pp);
    pingpong_unlock(pp);
}

value register_handoff_blocker( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;

// FIXME leak?
    PingPong *pp = pingpong_new();
    
    g_object_connect( o, "signal::handoff", handle_handoff, pp, NULL );
    
    return( alloc_pingpong(pp) );
}
DEFINE_PRIM(register_handoff_blocker,1);

value handoff_block( value v_pp ) {
    PingPong *pp = val_pingpong(v_pp);
    
    void *payload;
    
    pingpong_lock(pp);
    pingpong_pong(pp);
//    g_message("PONG");
    pingpong_wait_ping(pp, &payload);
    pingpong_unlock(pp);

// FIXME leak?
    return alloc_gobject( payload );
}
DEFINE_PRIM(handoff_block,1);


/* GstBuffer */
value buffer_timestamp( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    if( !GST_IS_BUFFER( o ) ) {
        error("not a buffer", obj );
        return val_null;
    }
    
    return alloc_float( (double)GST_BUFFER_TIMESTAMP( GST_BUFFER(o) )/GST_SECOND );
}
DEFINE_PRIM( buffer_timestamp, 1 );

/*
value analyze_buffer( value obj ) {
    GObject *o = val_gobject( obj );
    if( !o ) return val_null;
    
    if( !GST_IS_BUFFER( o ) ) {
        error("not a buffer", obj );
        return val_null;
    }
    GstBuffer *buf = GST_BUFFER(o);
    
    // FIXME: cache keys
    value ret = alloc_object(NULL);
    alloc_field( ret, val_id("timestamp"), alloc_float( 
            (double)GST_BUFFER_TIMESTAMP( buf )/GST_SECOND ) );
    alloc_field( ret, val_id("size"), alloc_int( GST_BUFFER_SIZE( buf ) ) );
    alloc_field( ret, val_id("data"), alloc_abstract( k_unsigned_int_p, GST_BUFFER_DATA( buf ) ) );
    
    GstCaps *caps = GST_BUFFER_CAPS(buf);
    GstStructure *s = gst_caps_get_structure(caps,0);

    alloc_field( ret, val_id("caps"), alloc_string( gst_structure_get_name(s) ) );
    
    int v;
    if( gst_structure_get_int( s, "width", &v ) )
        alloc_field( ret, val_id("width"), alloc_int( v ) );
    if( gst_structure_get_int( s, "height", &v ) )
        alloc_field( ret, val_id("height"), alloc_int( v ) );
    
    return ret;
}
DEFINE_PRIM( analyze_buffer,1 );
*/
/* init */

#include "gstgltexturesink.h"
value _gst_init() {
    g_thread_init(NULL);
	gst_init( NULL, NULL );
    return val_true;
}
DEFINE_PRIM(_gst_init,0);
