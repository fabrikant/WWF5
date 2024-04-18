import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;

class WWF5View extends WatchUi.WatchFace {
  var pattern, colors, every_second_layers;
  var fontClock, fontSeconds, fontValues, fontTemp;
  var moon_keeper, weather_layer, scale_layer;
  var weather_condition;
  var isAmoledSaveMode;

  function initialize() {
    WatchFace.initialize();
    fontClock = Application.loadResource(Rez.Fonts.clock);
    fontSeconds = Application.loadResource(Rez.Fonts.seconds);
    fontValues = Application.loadResource(Rez.Fonts.values);
    fontTemp = Application.loadResource(Rez.Fonts.temperature);
    every_second_layers = [];
    isAmoledSaveMode = false;
    weather_condition = WeatherWrapper.getCurrentConditions();
  }

  function readSettings() {
    colors = {
      :pattern => Application.Properties.getValue("c_patt"),
      :pattern_decorate => Application.Properties.getValue("c_patt_d"),
      :background => Application.Properties.getValue("c_bgnd"),
      :font => Application.Properties.getValue("c_font"),
      :font_empty_segments => Application.Properties.getValue("c_es"),
      :image => Application.Properties.getValue("c_image"),
      :scale => Application.Properties.getValue("c_scale"),
    };
  }

  function createMoonKeeper() {
    moon_keeper = new MoonKeeper(
      Lang.Time.now(),
      System.getDeviceSettings().screenWidth * 0.1
    );
  }

  function captureLocation() {
    var location = Activity.getActivityInfo().currentLocation;
    if (location != null) {
      Application.Storage.setValue(Global.LOCATION_KEY, location.toDegrees());
      getApp().registerEvents();
    } else {
      //Берем координаты из погоды, только если других совсем нет
      //Потому что часто выдает неправильные координты
      // var old_loc = Application.Storage.getValue(Global.LOCATION_KEY);
      // if (old_loc == null) {
      var weather = Toybox.Weather.getCurrentConditions();
      if (weather != null) {
        location = weather.observationLocationPosition;
        if (location != null) {
          Application.Storage.setValue(
            Global.LOCATION_KEY,
            location.toDegrees()
          );
          getApp().registerEvents();
        }
      }
      // }
    }
  }

  function createLayers() {
    self.clearLayers();

    //Время
    var clock_layer_max_lenght = 4.25;
    var options = pattern.calculateLayerCoordinates(
      [pattern.reference_points[:x][8], pattern.reference_points[:y][2]],
      [pattern.reference_points[:x][4], pattern.reference_points[:y][4]]
    );
    options[:identifier] = :clock;
    options[:font] = fontClock;
    var clock_layer = new SimpleField(options);
    self.addLayer(clock_layer);

    //Секунды
    var temp_h = pattern.calculateLayerHeight(
      pattern.reference_points[:y][2],
      pattern.reference_points[:y][3]
    );
    var temp_w = Math.floor(
      (temp_h * clock_layer.getDc().getWidth()) /
        clock_layer.getDc().getHeight()
    );
    temp_w = Math.floor((temp_w / clock_layer_max_lenght) * 2);

    options = {
      :locX => pattern.calculateLayerLeft(pattern.reference_points[:x][4]),
      :locY => pattern.calculateLayerUp(pattern.reference_points[:y][2]),
      :width => temp_w,
      :height => temp_h,
      :identifier => :seconds,
      :font => fontSeconds,
    };
    var seconds_layer = new SimpleField(options);
    seconds_layer.compl_id = new Complications.Id(
      Complications.COMPLICATION_TYPE_HEART_RATE
    );
    self.addLayer(seconds_layer);
    every_second_layers.add(seconds_layer);

    //Дата
    options = pattern.calculateLayerCoordinates(
      [pattern.reference_points[:x][10], pattern.reference_points[:y][5]],
      [
        pattern.reference_points[:x][11],
        System.getDeviceSettings().screenHeight,
      ]
    );
    options[:identifier] = "data_bottom";
    var date_field = new BottomField(options);
    date_field.compl_id = new Complications.Id(
      Complications.COMPLICATION_TYPE_CALENDAR_EVENTS
    );
    self.addLayer(date_field);

    //Рассвет-Закат
    var temp_y =
      pattern.reference_points[:y][2] -
      Math.floor(pattern.reference_points[:y][2] * 0.4);

    var temp_x = Math.floor(
      Global.mod(temp_y - pattern.reference_points[:y][2]) / 2
    );
    options = pattern.calculateLayerCoordinates(
      [pattern.reference_points[:x][2], temp_y],
      [
        pattern.reference_points[:x][6] - temp_x,
        pattern.reference_points[:y][2],
      ]
    );
    options[:identifier] = :sun_events;
    var sun_event_field = new SunEventsField(options);
    self.addLayer(sun_event_field);

    //Погода
    options = {
      :locX => pattern.reference_points[:x][1],
      :locY => 0,
      :width => pattern.reference_points[:x][6] -
      pattern.reference_points[:x][1],
      :height => sun_event_field.getY(),
      :identifier => :weather,
    };
    weather_layer = new WeatherWidget(options);
    self.addLayer(weather_layer);

    //Шкала
    options = pattern.calculateLayerCoordinates(
      [pattern.reference_points[:x][5], 0],
      [pattern.reference_points[:x][2], pattern.reference_points[:y][2]]
    );
    options[:identifier] = "data_scale";
    scale_layer = new ScaleWidget(options);
    self.addLayer(scale_layer);

    //Поля данных
    var field_widtch = Math.floor(
      Global.mod(
        pattern.reference_points[:x][9] - pattern.reference_points[:x][8]
      ) / 3
    );

    options = {
      :locX => pattern.calculateLayerLeft(pattern.reference_points[:x][8]),
      :locY => pattern.calculateLayerUp(pattern.reference_points[:y][4]),
      :width => field_widtch,
      :height => pattern.calculateLayerHeight(
        pattern.reference_points[:y][4],
        pattern.reference_points[:y][5]
      ),
    };

    options[:identifier] = "data_1";
    self.addLayer(new DataField(options));

    options[:locX] = options[:locX] + options[:width];
    options[:identifier] = "data_2";
    self.addLayer(new DataField(options));

    options[:locX] = options[:locX] + options[:width];
    options[:identifier] = "data_3";
    self.addLayer(new DataField(options));

    //Small data field
    options = {
      :locX => seconds_layer.getX(),
      :width => pattern.reference_points[:x][6] - options[:locX],
      :height => Application.loadResource(Rez.Drawables.HR).getHeight(),
      :identifier => "data_small",
    };

    options[:locY] =
      clock_layer.getY() + clock_layer.getDc().getHeight() - options[:height];

    var small_field = new SmallField(options);
    self.addLayer(small_field);
    //every_second_layers.add(small_field);

    //Статусы
    var bitmap = Application.loadResource(Rez.Drawables.message);
    options = pattern.calculateLayerCoordinates(
      [
        pattern.reference_points[:x][6] - bitmap.getWidth() - 2,
        pattern.reference_points[:y][2],
      ],
      [pattern.reference_points[:x][6], pattern.reference_points[:y][4]]
    );
    options[:height] = small_field.getY() - options[:locY];
    options[:identifier] = :status;
    var status_layer = new StatusField(options);
    self.addLayer(status_layer);

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

    pattern.reference_points = null;
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {}

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {
    captureLocation();
    readSettings();
    self.pattern = new Pattern(colors);
    createMoonKeeper();
    createLayers();
  }

  // Update the view
  function onUpdate(dc as Dc) as Void {
    dc.setColor(colors[:background], colors[:background]);
    dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
    dc.clear();
    var layers = getLayers();
    for (var i = 0; i < layers.size(); i++) {
      layers[i].draw(colors);
    }
  }

  function onPartialUpdate(dc) {
    for (var i = 0; i < every_second_layers.size(); i++) {
      var layer = every_second_layers[i];
      dc.setClip(
        layer.getX(),
        layer.getY(),
        layer.getDc().getWidth(),
        layer.getDc().getHeight()
      );
      layer.draw(colors);
    }
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {
    isAmoledSaveMode = false;
    readSettings();
    if (moon_keeper instanceof MoonKeeper) {
      moon_keeper.calculate(Time.now());
    } else {
      createMoonKeeper();
    }
    if (weather_layer instanceof WeatherWidget) {
      weather_layer.arrow_bitmap = null;
    }
    if (scale_layer instanceof ScaleWidget) {
      scale_layer.small_bitmap = null;
    }
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {
    var settings = System.getDeviceSettings();
    if (
      settings has :requiresBurnInProtection &&
      settings.requiresBurnInProtection
    ) {
      isAmoledSaveMode = true;
      colors = {
        :pattern => Graphics.COLOR_TRANSPARENT,
        :pattern_decorate => Graphics.COLOR_TRANSPARENT,
        :background => Graphics.COLOR_BLACK,
        :font => Graphics.COLOR_WHITE,
        :font_empty_segments => Graphics.COLOR_TRANSPARENT,
        :image => Graphics.COLOR_WHITE,
        :scale => Graphics.COLOR_WHITE,
      };
      if (moon_keeper instanceof MoonKeeper) {
        moon_keeper.bitmap = Moon.drawMoon(
          moon_keeper.moon_phase[:IP1],
          moon_keeper.bitmap_size,
          colors[:image],
          colors[:background]
        );
      } else {
        createMoonKeeper();
      }
      if (weather_layer instanceof WeatherWidget) {
        weather_layer.arrow_bitmap = null;
      }
      if (scale_layer instanceof ScaleWidget) {
        scale_layer.small_bitmap = null;
      }
    }
  }
}
