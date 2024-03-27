import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class WWF5View extends WatchUi.WatchFace {

    var pattern, colors, fields;

    function initialize() {
        WatchFace.initialize();

        colors = {
            :pattern => Graphics.COLOR_DK_GRAY,
            :pattern_decorate => Graphics.COLOR_LT_GRAY,
            :background => Graphics.COLOR_BLACK,
            :font => Graphics.COLOR_WHITE,
            :font_border => Graphics.COLOR_BLUE,
            :font_empty_segments => Graphics.COLOR_DK_GREEN,
        };
        pattern = new Pattern(colors);
    }

    function createLayers(){

        // self.addLayer(new SimpleField({
        //     :locX => 0,
        //     :locY => ,
        //     :width => ,
        //     :height => ,
        //     :colorDepth => ,
        //     :visibility  => ,
        //     :identifier =>
        // }));

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {


        dc.setColor(colors[:background], colors[:background]);
        dc.clear();
        dc.drawBitmap(0, 0, pattern.background_image);
        //var pattern_points = drawBackgoundPattern(dc, colors);

        // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    

    
}
