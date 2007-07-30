#ifndef __TESTER_H
#define __TESTER_H

// a minimal "object-oriented C" library.
// this is not war, just a simulation.

// usually, libraries dont know about neko. we do, to test advanced dynamic/object handling
#include <neko/neko.h>

#define TESTER_CONST_GLOBAL_TEST 23

typedef struct _tester {
	int someInt;
	double someDouble;
	const char *someString; // FIXME: strings open the memory question!
} tester;

tester *tester_construct();
void tester_destruct( tester *t );
int tester_test_int( tester *t, int v );
double tester_test_float( tester *t, double v );
int tester_test_bool( tester *t, int v );
const char *tester_test_string( tester *t, const char *v );
int tester_test_order( tester *t, const char* a, int b, const char* c, const char* d );
int tester_test_many( tester *t, int a1, int a2, int a3, int a4, int a5, int a6 );
void tester_test_void( tester *t );
value tester_test_dynamic( tester *t, value v );
value tester_test_object( tester *t, value v );
int tester_test_pointer( tester *t, int *ptr );

	
#endif // __TESTER_H
