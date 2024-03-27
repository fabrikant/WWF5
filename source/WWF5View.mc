import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class WWF5View extends WatchUi.WatchFace {

    var pattern, colors, every_second_layers;

    function initialize() {
        WatchFace.initialize();

        colors = {
            :pattern => Graphics.COLOR_DK_GRAY,
            :pattern_decorate => Graphics.COLOR_LT_GRAY,
            :background => Graphics.COLOR_BLACK,
            :font => Graphics.COLOR_WHITE,
            //:font_border => Graphics.COLOR_LT_GRAY,
            //:font_empty_segments => Graphics.COLOR_DK_GRAY,
        };
        pattern = new Pattern(colors);
        
    }

    function createLayers(){

        var options = pattern.calculateLayerCoordinates(
            [pattern.reference_points[:x][8], pattern.reference_points[:y][2]],
            [pattern.reference_points[:x][4], pattern.reference_points[:y][4]]);
        options[:identifier] = :hours;
        options[:max_lenght] = 2;
        var hours_layer = new SimpleField(options);
        self.addLayer(hours_layer);

        var temp_h = pattern.calculateLayerHeight(
            pattern.reference_points[:y][2], 
            pattern.reference_points[:y][3]);
        var temp_w = Math.floor(temp_h * 
            hours_layer.getDc().getWidth() / hours_layer.getDc().getHeight());
        options = {
            :locX => pattern.reference_points[:x][4], 
            :locY => pattern.calculateLayerUp(pattern.reference_points[:y][2]), 
            :width => temp_w, 
            :height => temp_h,
            :identifier => :minutes,
            :max_lenght => 2,
        };
        self.addLayer(new SimpleField(options));
    }

    
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFace(dc));
        createLayers();
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

        var layers = getLayers();
        for (var i = 0; i < layers.size(); i++){
            layers[i].draw(colors);
        }

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
