/*  Copyright (c) the Xinf contributors.
    see http://xinf.org/copyright for license. */
	
package xinf.test.svg;

import xinf.test.TestCase;
import xinf.test.TestShell;
import Xinf;

class SVG12Testsuite {
    static function main() {
		var suite = "SVG1.2";
        var shell = new TestShell(suite);
        var base="http://localhost:2000/static/"+suite+"/svg/";
        
        var runOnly:String;
        
        #if neko
            if( neko.Sys.args().length==1 ) {
                runOnly = neko.Sys.args()[0];
            }
        #end
        
        if( runOnly!=null ) {
            #if neko
            shell.add( new SVGTest( "file://"+runOnly ) );
            #end
        } else {
		//	shell.add( new SVGTest( base+"coords-coord-01-t.svg" ) );
		//	shell.add( new SVGTest( base+"coords-coord-02-t.svg" ) );
			shell.add( new SVGTest( base+"coords-pAR-201-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-01-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-02-t.svg" ) );
			
			shell.add( new SVGTest( base+"coords-trans-03-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-04-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-05-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-06-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-07-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-08-t.svg" ) );
			shell.add( new SVGTest( base+"coords-trans-09-t.svg" ) );
			shell.add( new SVGTest( base+"coords-units-01-t.svg" ) );
		// inline data messes up testserver
		//	shell.add( new SVGTest( base+"coords-viewattr-05-t.svg" ) );
		
			shell.add( new SVGTest( base+"jpeg-required-201-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-202-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-203-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-204-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-205-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-206-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-207-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-208-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-209-t.svg" ) );
			shell.add( new SVGTest( base+"jpeg-required-210-t.svg" ) );
			shell.add( new SVGTest( base+"metadata-example-01-t.svg" ) );
			shell.add( new SVGTest( base+"paint-color-01-t.svg" ) );
			shell.add( new SVGTest( base+"paint-color-03-t.svg" ) );
			shell.add( new SVGTest( base+"paint-color-04-t.svg" ) );
			shell.add( new SVGTest( base+"paint-color-05-t.svg" ) );
			shell.add( new SVGTest( base+"paint-fill-01-t.svg" ) );
			shell.add( new SVGTest( base+"paint-fill-02-t.svg" ) );
			shell.add( new SVGTest( base+"paint-fill-03-t.svg" ) );
			shell.add( new SVGTest( base+"paint-fill-04-t.svg" ) );
			shell.add( new SVGTest( base+"paint-fill-05-t.svg" ) );
		
			shell.add( new SVGTest( base+"paint-grad-04-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-05-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-07-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-08-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-09-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-11-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-12-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-15-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-16-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-17-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-18-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-19-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-201-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-202-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-203-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-204-t.svg" ) );
			shell.add( new SVGTest( base+"paint-grad-205-t.svg" ) );

			shell.add( new SVGTest( base+"paint-nsstroke-201-t.svg" ) );
			shell.add( new SVGTest( base+"paint-nsstroke-202-t.svg" ) );
			shell.add( new SVGTest( base+"paint-nsstroke-203-t.svg" ) );
			shell.add( new SVGTest( base+"paint-other-201-t.svg" ) );
			shell.add( new SVGTest( base+"paint-other-202-t.svg" ) );
			shell.add( new SVGTest( base+"paint-other-203-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-01-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-02-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-03-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-04-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-05-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-06-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-07-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-08-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-201-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-202-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-204-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-205-t.svg" ) );
			shell.add( new SVGTest( base+"paint-stroke-207-t.svg" ) );
			shell.add( new SVGTest( base+"paint-vfill-201-t.svg" ) );
			shell.add( new SVGTest( base+"paint-vfill-202-t.svg" ) );
			shell.add( new SVGTest( base+"paint-vfill-203-t.svg" ) );
			shell.add( new SVGTest( base+"paint-vfill-204-t.svg" ) );
			shell.add( new SVGTest( base+"paint-vfill-205-t.svg" ) );
			shell.add( new SVGTest( base+"paint-vfill-206-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-01-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-02-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-04-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-05-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-06-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-07-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-08-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-09-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-10-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-12-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-13-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-14-t.svg" ) );
			shell.add( new SVGTest( base+"paths-data-15-t.svg" ) );
			shell.add( new SVGTest( base+"render-elems-01-t.svg" ) );
			shell.add( new SVGTest( base+"render-elems-02-t.svg" ) );
			shell.add( new SVGTest( base+"render-elems-03-t.svg" ) );
			shell.add( new SVGTest( base+"render-elems-06-t.svg" ) );
			shell.add( new SVGTest( base+"render-elems-07-t.svg" ) );
			shell.add( new SVGTest( base+"render-elems-08-t.svg" ) );
			shell.add( new SVGTest( base+"render-groups-01-t.svg" ) );
			
		
			shell.add( new SVGTest( base+"shapes-circle-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-circle-02-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-circle-03-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-ellipse-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-ellipse-02-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-ellipse-03-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-intro-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-line-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-line-02-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-polygon-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-polygon-02-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-polyline-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-polyline-02-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-rect-01-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-rect-02-t.svg" ) );
			shell.add( new SVGTest( base+"shapes-rect-03-t.svg" ) );
			shell.add( new SVGTest( base+"struct-cond-01-t.svg" ) );
			shell.add( new SVGTest( base+"struct-cond-02-t.svg" ) );
			shell.add( new SVGTest( base+"struct-cond-205-t.svg" ) );
			shell.add( new SVGTest( base+"struct-cond-206-t.svg" ) );
			shell.add( new SVGTest( base+"struct-cond-207-t.svg" ) );
			shell.add( new SVGTest( base+"struct-defs-01-t.svg" ) );
			shell.add( new SVGTest( base+"struct-defs-201-t.svg" ) );
			shell.add( new SVGTest( base+"struct-discard-201-t.svg" ) );
			shell.add( new SVGTest( base+"struct-discard-202-t.svg" ) );
			shell.add( new SVGTest( base+"struct-discard-204-t.svg" ) );
			shell.add( new SVGTest( base+"struct-discard-205-t.svg" ) );
			shell.add( new SVGTest( base+"struct-discard-206-t.svg" ) );
			shell.add( new SVGTest( base+"struct-discard-207-t.svg" ) );
			shell.add( new SVGTest( base+"struct-frag-02-t.svg" ) );
			shell.add( new SVGTest( base+"struct-frag-03-t.svg" ) );
			shell.add( new SVGTest( base+"struct-frag-04-t.svg" ) );
			shell.add( new SVGTest( base+"struct-frag-05-t.svg" ) );
			shell.add( new SVGTest( base+"struct-frag-06-t.svg" ) );
			shell.add( new SVGTest( base+"struct-group-01-t.svg" ) );
			shell.add( new SVGTest( base+"struct-group-03-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-01-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-03-t.svg" ) );
			// messes up testserver, likely inline data
			//shell.add( new SVGTest( base+"struct-image-04-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-06-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-07-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-08-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-09-t.svg" ) );
			shell.add( new SVGTest( base+"struct-image-10-t.svg" ) );
			shell.add( new SVGTest( base+"struct-progressive-201-t.svg" ) );
			shell.add( new SVGTest( base+"struct-progressive-202-t.svg" ) );
			shell.add( new SVGTest( base+"struct-progressive-203-t.svg" ) );
			shell.add( new SVGTest( base+"struct-progressive-204-t.svg" ) );
			shell.add( new SVGTest( base+"struct-svg-201-t.svg" ) );
			shell.add( new SVGTest( base+"struct-svg-202-t.svg" ) );
			shell.add( new SVGTest( base+"struct-svg-203-t.svg" ) );
			shell.add( new SVGTest( base+"struct-use-01-t.svg" ) );
			shell.add( new SVGTest( base+"struct-use-03-t.svg" ) );
		// XXX
			shell.add( new SVGTest( base+"struct-use-201-t.svg" ) );
			shell.add( new SVGTest( base+"struct-use-202-t.svg" ) );
			shell.add( new SVGTest( base+"struct-use-204-t.svg" ) );
			shell.add( new SVGTest( base+"text-align-01-t.svg" ) );
			shell.add( new SVGTest( base+"text-align-07-t.svg" ) );
			shell.add( new SVGTest( base+"text-align-08-t.svg" ) );
			shell.add( new SVGTest( base+"text-align-201-t.svg" ) );
			shell.add( new SVGTest( base+"text-align-202-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-201-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-203-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-204-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-205-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-207-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-209-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-210-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-213-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-220-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-221-t.svg" ) );
			shell.add( new SVGTest( base+"text-area-222-t.svg" ) );
			shell.add( new SVGTest( base+"text-fonts-01-t.svg" ) );
			shell.add( new SVGTest( base+"text-fonts-02-t.svg" ) );
			shell.add( new SVGTest( base+"text-fonts-03-t.svg" ) );
			shell.add( new SVGTest( base+"text-fonts-04-t.svg" ) );
			shell.add( new SVGTest( base+"text-fonts-202-t.svg" ) );
			shell.add( new SVGTest( base+"text-intro-01-t.svg" ) );
			shell.add( new SVGTest( base+"text-intro-04-t.svg" ) );
			shell.add( new SVGTest( base+"text-intro-05-t.svg" ) );
			shell.add( new SVGTest( base+"text-intro-201-t.svg" ) );
			shell.add( new SVGTest( base+"text-text-04-t.svg" ) );
			shell.add( new SVGTest( base+"text-text-06-t.svg" ) );
			shell.add( new SVGTest( base+"text-text-07-t.svg" ) );
			shell.add( new SVGTest( base+"text-text-08-t.svg" ) );
			shell.add( new SVGTest( base+"text-text-09-t.svg" ) );
			shell.add( new SVGTest( base+"text-tselect-03-t.svg" ) );
			shell.add( new SVGTest( base+"text-ws-01-t.svg" ) );
			shell.add( new SVGTest( base+"text-ws-02-t.svg" ) );


		/*
			The following tests test features that are (currently)
			not supported in Xinf.
		*/
			
		/*
			shell.add( new SVGTest( base+"script-element-201-t.svg" ) );
			shell.add( new SVGTest( base+"script-element-202-t.svg" ) );
			shell.add( new SVGTest( base+"script-handle-05-t.svg" ) );
			shell.add( new SVGTest( base+"script-handle-06-t.svg" ) );
			shell.add( new SVGTest( base+"script-handle-07-t.svg" ) );
			shell.add( new SVGTest( base+"script-handle-08-t.svg" ) );
			shell.add( new SVGTest( base+"script-handle-201-t.svg" ) );
			shell.add( new SVGTest( base+"script-handle-202-t.svg" ) );
			shell.add( new SVGTest( base+"script-listener-201-t.svg" ) );
			shell.add( new SVGTest( base+"script-listener-202-t.svg" ) );
		*/
		/*
			shell.add( new SVGTest( base+"animate-elem-02-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-03-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-04-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-05-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-06-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-07-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-08-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-09-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-10-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-11-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-12-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-13-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-14-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-15-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-17-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-19-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-20-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-201-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-202-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-203-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-206-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-207-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-209-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-21-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-210-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-211-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-212-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-213-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-214-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-215-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-216-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-217-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-218-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-22-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-23-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-24-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-25-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-26-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-27-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-28-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-29-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-30-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-31-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-32-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-33-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-34-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-35-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-36-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-37-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-38-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-39-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-40-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-41-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-44-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-46-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-52-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-53-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-64-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-65-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-66-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-67-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-68-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-69-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-70-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-77-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-78-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-80-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-81-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-82-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-83-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-84-t.svg" ) );
			shell.add( new SVGTest( base+"animate-elem-85-t.svg" ) );
		*/
		/*
			shell.add( new SVGTest( base+"coords-constr-201-t.svg" ) );
			shell.add( new SVGTest( base+"coords-constr-202-t.svg" ) );
			shell.add( new SVGTest( base+"coords-constr-203-t.svg" ) );
			shell.add( new SVGTest( base+"coords-constr-204-t.svg" ) );
		*/
		/*
			shell.add( new SVGTest( base+"fonts-desc-02-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-desc-03-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-desc-05-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-elem-01-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-elem-02-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-elem-03-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-elem-05-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-elem-06-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-glyph-02-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-glyph-03-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-glyph-04-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-glyph-201-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-kern-01-t.svg" ) );
			shell.add( new SVGTest( base+"fonts-overview-201-t.svg" ) );
		*/
		/*
			shell.add( new SVGTest( base+"interact-dom-02-t.svg" ) );
			shell.add( new SVGTest( base+"interact-event-201-t.svg" ) );
			shell.add( new SVGTest( base+"interact-event-202-t.svg" ) );
			shell.add( new SVGTest( base+"interact-event-203-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-201-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-202-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-203-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-204-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-205-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-206-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-207-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-210-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-211-t.svg" ) );
			shell.add( new SVGTest( base+"interact-focus-212-t.svg" ) );
			shell.add( new SVGTest( base+"interact-order-04-t.svg" ) );
			shell.add( new SVGTest( base+"interact-order-05-t.svg" ) );
			shell.add( new SVGTest( base+"interact-order-06-t.svg" ) );
			shell.add( new SVGTest( base+"interact-pevents-05-t.svg" ) );
			shell.add( new SVGTest( base+"interact-pevents-06-t.svg" ) );
			shell.add( new SVGTest( base+"interact-pevents-07-t.svg" ) );
			shell.add( new SVGTest( base+"interact-pevents-08-t.svg" ) );
			shell.add( new SVGTest( base+"interact-zoom-01-t.svg" ) );
			shell.add( new SVGTest( base+"interact-zoom-02-t.svg" ) );
			shell.add( new SVGTest( base+"interact-zoom-03-t.svg" ) );
		*/
		/*
			shell.add( new SVGTest( base+"linking-a-01-t.svg" ) );
			shell.add( new SVGTest( base+"linking-a-08-t.svg" ) );
			shell.add( new SVGTest( base+"linking-frag-201-t.svg" ) );
			shell.add( new SVGTest( base+"linking-frag-202-t.svg" ) );
			shell.add( new SVGTest( base+"linking-refs-201-t.svg" ) );
			shell.add( new SVGTest( base+"linking-refs-202-t.svg" ) );
			shell.add( new SVGTest( base+"linking-refs-203-t.svg" ) );
			shell.add( new SVGTest( base+"linking-refs-204-t.svg" ) );
			shell.add( new SVGTest( base+"linking-refs-205-t.svg" ) );
			shell.add( new SVGTest( base+"linking-uri-03-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-201-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-202-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-203-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-204-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-205-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-206-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-207-t.svg" ) );
			shell.add( new SVGTest( base+"media-alevel-208-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-201-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-202-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-203-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-205-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-206-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-207-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-209-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-210-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-211-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-212-t.svg" ) );
			shell.add( new SVGTest( base+"media-anim-213-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-201-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-202-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-203-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-204-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-205-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-206-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-207-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-208-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-209-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-210-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-211-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-212-t.svg" ) );
			shell.add( new SVGTest( base+"media-audio-213-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-201-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-202-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-203-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-204-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-205-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-206-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-207-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-208-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-209-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-210-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-211-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-212-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-213-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-214-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-215-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-216-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-217-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-218-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-219-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-220-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-221-t.svg" ) );
			shell.add( new SVGTest( base+"media-video-222-t.svg" ) );
		*/
	
		/*
			shell.add( new SVGTest( base+"udom-dom-201-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-202-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-203-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-206-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-207-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-210-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-211-t.svg" ) );
			shell.add( new SVGTest( base+"udom-dom-213-t.svg" ) );
			shell.add( new SVGTest( base+"udom-event-201-t.svg" ) );
			shell.add( new SVGTest( base+"udom-event-202-t.svg" ) );
			shell.add( new SVGTest( base+"udom-event-203-t.svg" ) );
			shell.add( new SVGTest( base+"udom-event-204-t.svg" ) );
			shell.add( new SVGTest( base+"udom-event-207-t.svg" ) );
			shell.add( new SVGTest( base+"udom-glob-201-t.svg" ) );
			shell.add( new SVGTest( base+"udom-node-201-t.svg" ) );
			shell.add( new SVGTest( base+"udom-node-202-t.svg" ) );
			shell.add( new SVGTest( base+"udom-node-204-t.svg" ) );
			shell.add( new SVGTest( base+"udom-over-01-t.svg" ) );
			shell.add( new SVGTest( base+"udom-smil-201-t.svg" ) );
			shell.add( new SVGTest( base+"udom-smil-202-t.svg" ) );
			shell.add( new SVGTest( base+"udom-smil-203-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-201-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-202-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-204-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-205-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-208-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-209-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-210-t.svg" ) );
			shell.add( new SVGTest( base+"udom-svg-211-t.svg" ) );
			shell.add( new SVGTest( base+"udom-textcontent-202-t.svg" ) );
			shell.add( new SVGTest( base+"udom-traitaccess-203-t.svg" ) );
			shell.add( new SVGTest( base+"udom-traitaccess-204-t.svg" ) );
			shell.add( new SVGTest( base+"udom-traitaccess-205-t.svg" ) );
			shell.add( new SVGTest( base+"udom-traitaccess-206-t.svg" ) );
			shell.add( new SVGTest( base+"udom-traitaccess-207-t.svg" ) );
		*/
		}
        
        shell.run();
    }
}