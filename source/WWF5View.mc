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
        
        var clock_layer_max_lenght = 4.25;
        var options = pattern.calculateLayerCoordinates(
            [pattern.reference_points[:x][8], pattern.reference_points[:y][2]],
            [pattern.reference_points[:x][4], pattern.reference_points[:y][4]]);
        options[:identifier] = :hours_minutes;
        options[:max_lenght] = clock_layer_max_lenght;
        var clock_layer = new SimpleField(options);
        self.addLayer(clock_layer);

        var temp_h = pattern.calculateLayerHeight(
            pattern.reference_points[:y][2], 
            pattern.reference_points[:y][3]);
        var temp_w = Math.floor(temp_h * 
            clock_layer.getDc().getWidth() / clock_layer.getDc().getHeight());
        temp_w = Math.floor(temp_w / clock_layer_max_lenght * 2);

        options = {
            :locX => pattern.reference_points[:x][3], 
            :locY => pattern.calculateLayerUp(pattern.reference_points[:y][2]), 
            :width => temp_w, 
            :height => temp_h,
            :identifier => :seconds,
            :max_lenght => 2,
        };
        var seconds_layer = new SimpleField(options);
        self.addLayer(seconds_layer);
        every_second_layers = [seconds_layer];
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
        dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
        dc.clear();
        dc.drawBitmap(0, 0, pattern.background_image);

        var layers = getLayers();
        for (var i = 0; i < layers.size(); i++){
            layers[i].draw(colors);
        }
    }

    function onPartialUpdate(dc){
        
        for (var i = 0; i < every_second_layers.size(); i++){
            var layer = every_second_layers[i];
            dc.setClip(layer.getX(), layer.getY(), 
                layer.getDc().getWidth(),
                layer.getDc().getHeight());
            layer.draw(colors);
        }
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
