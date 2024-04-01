import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class WWF5View extends WatchUi.WatchFace {

    var pattern, colors, every_second_layers;
    var fonts;

    function initialize() {
        WatchFace.initialize();
    }

    function readSettings(){
        colors = {
            :pattern => Application.Properties.getValue("color_pattern"),
            :pattern_decorate => Application.Properties.getValue("color_pattern_decorate"),
            :background => Application.Properties.getValue("color_background"),
            :font => Application.Properties.getValue("color_font"),
            :font_empty_segments => Application.Properties.getValue("color_font_empty_segments"),
        };
    }

    function createLayers(){
        
        //Время
        var clock_layer_max_lenght = 4.25;
        var options = pattern.calculateLayerCoordinates(
            [pattern.reference_points[:x][8], pattern.reference_points[:y][2]],
            [pattern.reference_points[:x][4], pattern.reference_points[:y][4]]);
        options[:identifier] = :clock;
        options[:max_lenght] = clock_layer_max_lenght;
        var clock_layer = new SimpleField(options);
        self.addLayer(clock_layer);

        //Секунды
        var temp_h = pattern.calculateLayerHight(
            pattern.reference_points[:y][2], 
            pattern.reference_points[:y][3]);
        var temp_w = Math.floor(temp_h * 
            clock_layer.getDc().getWidth() / clock_layer.getDc().getHeight());
        temp_w = Math.floor(temp_w / clock_layer_max_lenght * 2);

        options = {
            :locX => pattern.calculateLayerLeft(pattern.reference_points[:x][4]), 
            :locY => pattern.calculateLayerUp(pattern.reference_points[:y][2]), 
            :width => temp_w, 
            :height => temp_h,
            :identifier => :seconds,
            :max_lenght => 2,
        };
        var seconds_layer = new SimpleField(options);
        self.addLayer(seconds_layer);
        every_second_layers = [seconds_layer];

        //Дата
        options = pattern.calculateLayerCoordinates(
            [pattern.reference_points[:x][10], pattern.reference_points[:y][5]],
            [pattern.reference_points[:x][11], System.getDeviceSettings().screenHeight]);
        options[:identifier] = :date;
        self.addLayer(new BottomField(options));

        //Рассвет-Закат
        var temp_y = pattern.reference_points[:y][2] 
            - Math.floor(pattern.reference_points[:y][2]/3);

        var temp_x = Math.floor(Global.mod(temp_y  - pattern.reference_points[:y][2]) / 2);
        options = pattern.calculateLayerCoordinates(
            [pattern.reference_points[:x][2], temp_y],
            [pattern.reference_points[:x][6] - temp_x, pattern.reference_points[:y][2]]);
        options[:identifier] = :sun_events;
        options[:max_lenght] = 11;
        var sun_event_field = new SunEventsField(options);
        self.addLayer(sun_event_field);

        //Погода
        options = {
            :locX => pattern.reference_points[:x][1], 
            :locY => 0, 
            :width => pattern.reference_points[:x][6] - pattern.reference_points[:x][1], 
            :height => sun_event_field.getY(),
            :identifier => :weather,
        };
        self.addLayer(new WeatherWidget(options));

        //Шкала
        options = pattern.calculateLayerCoordinates(
            [pattern.reference_points[:x][5], 0],
            [pattern.reference_points[:x][2], pattern.reference_points[:y][2]]);
        options[:identifier] = :scale;
        self.addLayer(new ScaleWidget(options));

        //Поля данных
        var field_widtch = Math.floor(
            Global.mod((pattern.reference_points[:x][9] - pattern.reference_points[:x][8])) / 3);

        options = {:locX => pattern.calculateLayerLeft(pattern.reference_points[:x][8]), 
                :locY => pattern.calculateLayerUp(pattern.reference_points[:y][4]), 
                :width => field_widtch, 
                :height => pattern.calculateLayerHight(pattern.reference_points[:y][4], pattern.reference_points[:y][5])};

        options[:identifier] = :data1;
        options[:property_name] = "data_type_1";
        self.addLayer(new DataField(options));

        options[:locX] = options[:locX] + options[:width];
        options[:identifier] = :data2;
        options[:property_name] = "data_type_3";
        self.addLayer(new DataField(options));

        options[:locX] = options[:locX] + options[:width];
        options[:identifier] = :data3;
        options[:property_name] = "data_type_3";
        self.addLayer(new DataField(options));

        //Подложка
        options = {
            :locX => 0, 
            :locY => 0, 
            :width => System.getDeviceSettings().screenWidth, 
            :height => System.getDeviceSettings().screenHeight,
            :identifier => :pattern,
            :pattern => self.pattern,
        };
        self.addLayer(new PatternField(options));

    }

    
    // Load your resources here
    function onLayout(dc as Dc) as Void {
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        fonts = {};
        readSettings();
        self.pattern = new Pattern(colors);
        createLayers();
   }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        dc.setColor(colors[:background], colors[:background]);
        dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
        dc.clear();
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
