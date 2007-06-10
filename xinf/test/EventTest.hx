package xinf.test;

import xinf.event.MouseEvent;

class TestMouseOver extends TestCase {
    override public function test() {
        shell.mouseMove( 1, 1 );

        var r = X.rectangle();
        r.x=120; r.y=90;
        r.width=80; r.height=60;
        X.root().attach(r);

        assertEvent( r, MouseEvent.MOUSE_OVER, function(e) {
                return( e.x==130 && e.y==100 );
            }, cleanFinish, 2 );
        
        var self=this;
        shell.runAtNextFrame( function() {
            self.shell.mouseMove( 130, 100 );
        });
    }
}

class TestMouseOut extends TestCase {
    override public function test() {
        shell.mouseMove( 130, 100 );

        var r = X.rectangle();
        r.x=120; r.y=90;
        r.width=80; r.height=60;
        X.root().attach(r);

        assertEvent( r, MouseEvent.MOUSE_OUT, function(e) {
                return( e.x==10 && e.y==10 );
            }, cleanFinish, 2 );
        
        var self=this;
        shell.runAtNextFrame( function() {
            self.shell.mouseMove( 10, 10 );
        });
    }
}

class TestMouseDown extends TestCase {
    override public function test() {
        shell.mouseMove( 130, 100 );

        var r = X.rectangle();
        r.x=120; r.y=90;
        r.width=80; r.height=60;
        X.root().attach(r);

        assertEvent( r, MouseEvent.MOUSE_DOWN, function(e) {
                return( e.button==1 && e.x==130 && e.y==100 );
            }, cleanFinish, 2 );
        
        var self=this;
        shell.runAtNextFrame( function() {
            self.shell.mouseButton( 1, true );
            self.shell.mouseButton( 1, false );
        });
    }
}

class TestMouseDown2 extends TestCase {
    override public function test() {
        shell.mouseMove( 130, 100 );

        var r = X.rectangle();
        r.x=120; r.y=90;
        r.width=80; r.height=60;
        X.root().attach(r);

        assertEvent( r, MouseEvent.MOUSE_DOWN, function(e) {
                return( e.button==2 && e.x==130 && e.y==100 );
            }, cleanFinish, 2 );
        
        var self=this;
        shell.runAtNextFrame( function() {
            self.shell.mouseButton( 2, true );
            self.shell.mouseButton( 2, false );
        });
    }
}

class TestMouseUp extends TestCase {
    override public function test() {
        shell.mouseMove( 130, 100 );
        shell.mouseButton( 1, true );

        assertEvent( xinf.erno.Runtime.runtime, MouseEvent.MOUSE_UP, function(e) {
                return( e.x==130 && e.y==100 ); // FIXME: button?
            }, cleanFinish, 2 );
        
        var self=this;
        shell.runAtNextFrame( function() {
            self.shell.mouseButton( 1, false );
        });
    }
}

class TestMouseMove extends TestCase {
    override public function test() {
        assertEvent( xinf.erno.Runtime.runtime, MouseEvent.MOUSE_MOVE, function(e) {
                return( e.x==111 && e.y==112 );
            }, cleanFinish, 2 );
        
        var self=this;
        shell.runAtNextFrame( function() {
            self.shell.mouseMove( 111, 112 );
        });
    }
}