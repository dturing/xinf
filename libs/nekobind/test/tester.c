
#include "tester.h"

// TODO
static int tester_counter = 0;

tester *tester_construct() {
	tester *t = (tester*)malloc(sizeof(tester));
	memset( t, 0, sizeof(tester) );
	printf("tester_create %p\n", t );
	return t;
}
void tester_destruct( tester *t ) {
	printf("tester_destruct %p\n", t );
	free(t);
}
int tester_test_int( tester *t, int v ) {
	return v;
}
double tester_test_float( tester *t, double v ) {
	return v;
}
int tester_test_bool( tester *t, int v ) {
	return( v>0 ? 1 : 0 );
}
const char *tester_test_string( tester *t, const char *v ) {
	return v;
}
int tester_test_order( tester *t, const char* a, int b, const char* c, const char* d ) {
	return b;
}
int tester_test_many( tester *t, int a1, int a2, int a3, int a4, int a5, int a6 ) {
	return a1+a2+a3+a4+a5+a6;
}
void tester_test_void( tester *t ) {
}
value tester_test_dynamic( tester *t, value v ) {
	return( v );
}
value tester_test_object( tester *t, value v ) {
	val_check(v,object);
	value foo = val_field(v,val_id("foo"));
	value bar = val_field(v,val_id("bar"));
	val_check(foo,string);
	val_check(bar,int);
	
	value r = alloc_object(NULL);
	alloc_field( r, val_id("foo"), alloc_int( val_number(bar) ) );
	alloc_field( r, val_id("bar"), alloc_string( val_string(foo) ) );
	return( r );
}

int tester_test_pointer( tester *t, int *ptr ) {
	// simulates a function requiring a pointer to 2 integers
	// dont take this as an example of threadsafe c coding
	return ptr[2];
}
