package xinf.test;

import xinf.event.MouseEvent;

class TestStyleBasics extends TestCase {
    override public function test() {

        var r = X.rectangle();
        r.x=15; r.y=10;
        r.width=50; r.height=50;
        r.style.fill = null;
        r.style.stroke = xinf.erno.Color.WHITE;
        r.style.strokeWidth = 1.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=75; r.y=10;
        r.width=50; r.height=50;
        r.style.fill = null;
        r.style.stroke = xinf.erno.Color.WHITE;
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=135; r.y=10;
        r.width=50; r.height=50;
        r.style.fill = null;
        r.style.stroke = xinf.erno.Color.WHITE;
        r.style.strokeWidth = 3.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=195; r.y=10;
        r.width=50; r.height=50;
        r.style.fill = null;
        r.style.stroke = xinf.erno.Color.WHITE;
        r.style.strokeWidth = 4.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=255; r.y=10;
        r.width=50; r.height=50;
        r.style.fill = null;
        r.style.stroke = xinf.erno.Color.WHITE;
        r.style.strokeWidth = 5.;
        X.root().attach(r);



        var r = X.rectangle();
        r.x=15; r.y=70;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.RED;
        r.style.stroke = null;
        r.style.strokeWidth = 1.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=75; r.y=70;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.GREEN;
        r.style.stroke = null;
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=135; r.y=70;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.BLUE;
        r.style.stroke = null;
        r.style.strokeWidth = 3.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=195; r.y=70;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.WHITE;
        r.style.stroke = null;
        r.style.strokeWidth = 4.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=255; r.y=70;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.BLACK;
        r.style.stroke = null;
        r.style.strokeWidth = 5.;
        X.root().attach(r);


        var r = X.rectangle();
        r.x=15; r.y=130;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.rgba(1,1,1,.1);
        r.style.stroke = xinf.erno.Color.rgba(1,1,1,.9);
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=75; r.y=130;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.rgba(1,1,1,.3);
        r.style.stroke = xinf.erno.Color.rgba(1,1,1,.7);
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=135; r.y=130;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.rgba(1,1,1,.5);
        r.style.stroke = xinf.erno.Color.rgba(1,1,1,.5);
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=195; r.y=130;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.rgba(1,1,1,.7);
        r.style.stroke = xinf.erno.Color.rgba(1,1,1,.3);
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        r = X.rectangle();
        r.x=255; r.y=130;
        r.width=50; r.height=50;
        r.style.fill = xinf.erno.Color.rgba(1,1,1,.9);
        r.style.stroke = xinf.erno.Color.rgba(1,1,1,.1);
        r.style.strokeWidth = 2.;
        X.root().attach(r);

        assertDisplay( cleanFinish );
    }
}
