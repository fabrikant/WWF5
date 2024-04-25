import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Weather;

class WeatherCurrentCondition {
  var observationTime;
  var condition, temperature, windBearing, windSpeed, icon_rez;
  var observationLocationName, feelsLikeTemperature, relativeHumidity;
  var data_source;

  function initialize() {
    updateValues();
  }

  function updateValues() {

    var owm_key = Application.Properties.getValue("owm_key");
    if (owm_key.equals("")){
      updateGarminValues();
      return;
    }

    var now = Time.now();
    if (observationTime != null) {
      var subst = now.subtract(observationTime).value();
      if (subst < 300) {
        return;
      }
    }

    data_source = null;
    var weather_data = Application.Storage.getValue(Global.CURRENT_WEATHER_KEY);
    if (weather_data != null) {
      var update_moment = weather_data[Global.STORAGE_KEY_UPDATE_MOMENT];
      if (now.value() - update_moment < 3600) {
        data_source = :owm;
        condition = weather_data[Global.STORAGE_KEY_WEATHER_ID];
        observationTime = new Time.Moment(
          weather_data[Global.STORAGE_KEY_UPDATE_MOMENT]
        );
        temperature = weather_data[Global.STORAGE_KEY_TEMP];
        windBearing = weather_data[Global.STORAGE_KEY_WIND_DEG];
        windSpeed = weather_data[Global.STORAGE_KEY_WIND_SPEED];
        icon_rez = WeatherWrapper.findOWMResByCode(
          condition,
          weather_data[Global.STORAGE_KEY_ICON]
        );
        observationLocationName = weather_data[Global.STORAGE_KEY_WEATHER_CITY];
        feelsLikeTemperature = weather_data[Global.STORAGE_KEY_TEMP_FEELS_LIKE];
        relativeHumidity = weather_data[Global.STORAGE_KEY_HUMIDITY];
      } else {
        updateGarminValues();
      }
    } else {
      updateGarminValues();
    }
  }

  function updateGarminValues() {
    var weather = Weather.getCurrentConditions();
    if (weather != null) {
      data_source = :garmin;
      condition = weather.condition;
      observationTime = weather.observationTime;
      temperature = weather.temperature;
      windBearing = weather.windBearing;
      windSpeed = weather.windSpeed;
      icon_rez = WeatherWrapper.getGarminConditionRez(weather);
      observationLocationName = weather.observationLocationName;
      feelsLikeTemperature = weather.feelsLikeTemperature;
      relativeHumidity = weather.relativeHumidity;
    }
  }
}

module WeatherWrapper {
  function getCurrentConditions() {
    var condition = new WeatherCurrentCondition();
    return condition;
  }

  /////////////////////////////////////////////////////////////////////////////
  //OWM
  function findOWMResByCode(id, icon) {
    var codes;
    if (id < 300) {
      codes = codes200();
    } else if (id < 500) {
      codes = codes300();
    } else if (id < 600) {
      codes = codes500();
    } else if (id < 700) {
      codes = codes600();
    } else if (id < 800) {
      codes = codes700();
    } else {
      codes = codes800();
    }

    var len = icon.length();
    var key = id.toString() + icon.substring(len - 1, len);

    var res = Rez.Drawables.NA;
    if (codes[key] != null) {
      res = codes[key];
    }
    return res;
  }

  function codes200() {
    //Thunderstorm
    return {
      "200d" => Rez.Drawables.Code200d,
      "200n" => Rez.Drawables.Code200n,
      "201d" => Rez.Drawables.Code201d,
      "201n" => Rez.Drawables.Code201n,
      "202d" => Rez.Drawables.Code202d,
      "202n" => Rez.Drawables.Code202n,
      "210d" => Rez.Drawables.Code210d,
      "210n" => Rez.Drawables.Code210n,
      "211d" => Rez.Drawables.Code211d,
      "211n" => Rez.Drawables.Code211n,
      "212d" => Rez.Drawables.Code212d,
      "212n" => Rez.Drawables.Code212n,
      "221d" => Rez.Drawables.Code221d,
      "221n" => Rez.Drawables.Code221n,
      "230d" => Rez.Drawables.Code230d,
      "230n" => Rez.Drawables.Code230n,
      "231d" => Rez.Drawables.Code231d,
      "231n" => Rez.Drawables.Code231n,
      "232d" => Rez.Drawables.Code232d,
      "232n" => Rez.Drawables.Code232n,
    };
  }

  function codes300() {
    //Drizzle
    return {
      "300d" => Rez.Drawables.Code300d,
      "300n" => Rez.Drawables.Code300n,
      "301d" => Rez.Drawables.Code301d,
      "301n" => Rez.Drawables.Code301n,
      "302d" => Rez.Drawables.Code302d,
      "302n" => Rez.Drawables.Code302n,
      "310d" => Rez.Drawables.Code310d,
      "310n" => Rez.Drawables.Code310n,
      "311d" => Rez.Drawables.Code311d,
      "311n" => Rez.Drawables.Code311n,
      "312d" => Rez.Drawables.Code312d,
      "312n" => Rez.Drawables.Code312n,
      "313d" => Rez.Drawables.Code313d,
      "313n" => Rez.Drawables.Code313n,
      "314d" => Rez.Drawables.Code314d,
      "314n" => Rez.Drawables.Code314n,
      "321d" => Rez.Drawables.Code321d,
      "321n" => Rez.Drawables.Code321n,
    };
  }

  function codes500() {
    //Rain
    return {
      "500d" => Rez.Drawables.Code500d,
      "500n" => Rez.Drawables.Code500n,
      "501d" => Rez.Drawables.Code501d,
      "501n" => Rez.Drawables.Code501n,
      "502d" => Rez.Drawables.Code502d,
      "502n" => Rez.Drawables.Code502n,
      "503d" => Rez.Drawables.Code503d,
      "503n" => Rez.Drawables.Code503n,
      "504d" => Rez.Drawables.Code504d,
      "504n" => Rez.Drawables.Code504n,
      "511d" => Rez.Drawables.Code511d,
      "511n" => Rez.Drawables.Code511n,
      "520d" => Rez.Drawables.Code520d,
      "520n" => Rez.Drawables.Code520n,
      "521d" => Rez.Drawables.Code521d,
      "521n" => Rez.Drawables.Code521n,
      "522d" => Rez.Drawables.Code522d,
      "522n" => Rez.Drawables.Code522n,
      "531d" => Rez.Drawables.Code531d,
      "531n" => Rez.Drawables.Code531n,
    };
  }

  function codes600() {
    //Snow
    return {
      "600d" => Rez.Drawables.Code600d,
      "600n" => Rez.Drawables.Code600n,
      "601d" => Rez.Drawables.Code601d,
      "601n" => Rez.Drawables.Code601n,
      "602d" => Rez.Drawables.Code602d,
      "602n" => Rez.Drawables.Code602n,
      "611d" => Rez.Drawables.Code611d,
      "611n" => Rez.Drawables.Code611n,
      "612d" => Rez.Drawables.Code612d,
      "612n" => Rez.Drawables.Code612n,
      "613d" => Rez.Drawables.Code613d,
      "613n" => Rez.Drawables.Code613n,
      "615d" => Rez.Drawables.Code615d,
      "615n" => Rez.Drawables.Code615n,
      "616d" => Rez.Drawables.Code616d,
      "616n" => Rez.Drawables.Code616n,
      "620d" => Rez.Drawables.Code620d,
      "620n" => Rez.Drawables.Code620n,
      "621d" => Rez.Drawables.Code621d,
      "621n" => Rez.Drawables.Code621n,
      "622d" => Rez.Drawables.Code622d,
      "622n" => Rez.Drawables.Code622n,
    };
  }

  function codes700() {
    //Atmosphere
    return {
      "701d" => Rez.Drawables.Code701d,
      "701n" => Rez.Drawables.Code701n,
      "711d" => Rez.Drawables.Code711d,
      "711n" => Rez.Drawables.Code711n,
      "721d" => Rez.Drawables.Code721d,
      "721n" => Rez.Drawables.Code721n,
      "731d" => Rez.Drawables.Code731d,
      "731n" => Rez.Drawables.Code731n,
      "741d" => Rez.Drawables.Code741d,
      "741n" => Rez.Drawables.Code741n,
      "751d" => Rez.Drawables.Code751d,
      "751n" => Rez.Drawables.Code751n,
      "761d" => Rez.Drawables.Code761d,
      "761n" => Rez.Drawables.Code761n,
      "762d" => Rez.Drawables.Code762d,
      "762n" => Rez.Drawables.Code762n,
      "771d" => Rez.Drawables.Code771d,
      "771n" => Rez.Drawables.Code771n,
      "781d" => Rez.Drawables.Code781d,
      "781n" => Rez.Drawables.Code781n,
    };
  }

  function codes800() {
    //Cloud
    return {
      "800d" => Rez.Drawables.Code800d,
      "800n" => Rez.Drawables.Code800n,
      "801d" => Rez.Drawables.Code801d,
      "801n" => Rez.Drawables.Code801n,
      "802d" => Rez.Drawables.Code802d,
      "802n" => Rez.Drawables.Code802n,
      "803d" => Rez.Drawables.Code803d,
      "803n" => Rez.Drawables.Code803n,
      "804d" => Rez.Drawables.Code804d,
      "804n" => Rez.Drawables.Code804n,
    };
  }

  /////////////////////////////////////////////////////////////////////////////
  //GARMIN
  function getGarminConditionRez(weather) {
    var condition = weather.condition;
    var isDay = true;
    var moment_now = Time.now();

    if (weather.observationLocationPosition != null) {
      var sunrise = Weather.getSunrise(
        weather.observationLocationPosition,
        moment_now
      );
      var sunset = Weather.getSunset(
        weather.observationLocationPosition,
        moment_now
      );
      if (sunrise != null && sunset != null) {
        if (
          moment_now.lessThan(sunrise) ||
          weather.observationTime.greaterThan(sunset)
        ) {
          isDay = false;
        }
      }
    }

    if (isDay) {
      if (condition == Weather.CONDITION_CLEAR) {
        return Rez.Drawables.Code800d;
      } else if (condition == Weather.CONDITION_PARTLY_CLOUDY) {
        return Rez.Drawables.Code802d;
      } else if (condition == Weather.CONDITION_MOSTLY_CLOUDY) {
        return Rez.Drawables.Code804d;
      } else if (condition == Weather.CONDITION_RAIN) {
        return Rez.Drawables.Code520d;
      } else if (condition == Weather.CONDITION_SNOW) {
        return Rez.Drawables.Code620d;
      } else if (condition == Weather.CONDITION_WINDY) {
        return Rez.Drawables.CONDITION_WINDY;
      } else if (condition == Weather.CONDITION_THUNDERSTORMS) {
        return Rez.Drawables.Code211d;
      } else if (condition == Weather.CONDITION_WINTRY_MIX) {
        return Rez.Drawables.CONDITION_WINTRY_MIX;
      } else if (condition == Weather.CONDITION_FOG) {
        return Rez.Drawables.Code741d;
      } else if (condition == Weather.CONDITION_HAZY) {
        return Rez.Drawables.Code721d;
      } else if (condition == Weather.CONDITION_HAIL) {
        return Rez.Drawables.Code511d;
      } else if (condition == Weather.CONDITION_SCATTERED_SHOWERS) {
        return Rez.Drawables.Code531d;
      } else if (condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
        return Rez.Drawables.Code221d;
      } else if (condition == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
        return Rez.Drawables.CONDITION_UNKNOWN_PRECIPITATION;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN) {
        return Rez.Drawables.Code500d;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN) {
        return Rez.Drawables.Code502d;
      } else if (condition == Weather.CONDITION_LIGHT_SNOW) {
        return Rez.Drawables.Code600d;
      } else if (condition == Weather.CONDITION_HEAVY_SNOW) {
        return Rez.Drawables.Code602d;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN_SNOW) {
        return Rez.Drawables.Code615d;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN_SNOW) {
        return Rez.Drawables.Code616d;
      } else if (condition == Weather.CONDITION_CLOUDY) {
        return Rez.Drawables.Code803d;
      } else if (condition == Weather.CONDITION_RAIN_SNOW) {
        return Rez.Drawables.Code616d;
      } else if (condition == Weather.CONDITION_PARTLY_CLEAR) {
        return Rez.Drawables.Code802d;
      } else if (condition == Weather.CONDITION_MOSTLY_CLEAR) {
        return Rez.Drawables.Code801d;
      } else if (condition == Weather.CONDITION_LIGHT_SHOWERS) {
        return Rez.Drawables.Code520d;
      } else if (condition == Weather.CONDITION_SHOWERS) {
        return Rez.Drawables.Code521d;
      } else if (condition == Weather.CONDITION_HEAVY_SHOWERS) {
        return Rez.Drawables.Code522d;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SHOWERS) {
        return Rez.Drawables.Code500d;
      } else if (condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS) {
        return Rez.Drawables.Code200d;
      } else if (condition == Weather.CONDITION_MIST) {
        return Rez.Drawables.Code701d;
      } else if (condition == Weather.CONDITION_DUST) {
        return Rez.Drawables.Code731d;
      } else if (condition == Weather.CONDITION_DRIZZLE) {
        return Rez.Drawables.Code301d;
      } else if (condition == Weather.CONDITION_TORNADO) {
        return Rez.Drawables.Code781d;
      } else if (condition == Weather.CONDITION_SMOKE) {
        return Rez.Drawables.Code711d;
      } else if (condition == Weather.CONDITION_ICE) {
        return Rez.Drawables.CONDITION_ICE;
      } else if (condition == Weather.CONDITION_SAND) {
        return Rez.Drawables.Code751d;
      } else if (condition == Weather.CONDITION_SQUALL) {
        return Rez.Drawables.CONDITION_SQUALL;
      } else if (condition == Weather.CONDITION_SANDSTORM) {
        return Rez.Drawables.Code751d;
      } else if (condition == Weather.CONDITION_VOLCANIC_ASH) {
        return Rez.Drawables.Code762d;
      } else if (condition == Weather.CONDITION_HAZE) {
        return Rez.Drawables.Code721d;
      } else if (condition == Weather.CONDITION_FAIR) {
        return Rez.Drawables.Code800d;
      } else if (condition == Weather.CONDITION_HURRICANE) {
        return Rez.Drawables.Code771d;
      } else if (condition == Weather.CONDITION_TROPICAL_STORM) {
        return Rez.Drawables.CONDITION_TROPICAL_STORM;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SNOW) {
        return Rez.Drawables.Code600d;
      } else if (condition == Weather.CONDITION_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.Code615d;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN) {
        return Rez.Drawables.Code500d;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW) {
        return Rez.Drawables.Code600d;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.Code616d;
      } else if (condition == Weather.CONDITION_FLURRIES) {
        return Rez.Drawables.CONDITION_FLURRIES;
      } else if (condition == Weather.CONDITION_FREEZING_RAIN) {
        return Rez.Drawables.CONDITION_FREEZING_RAIN;
      } else if (condition == Weather.CONDITION_SLEET) {
        return Rez.Drawables.Code613d;
      } else if (condition == Weather.CONDITION_ICE_SNOW) {
        return Rez.Drawables.Code611d;
      } else if (condition == Weather.CONDITION_THIN_CLOUDS) {
        return Rez.Drawables.Code801d;
      } else if (condition == Weather.CONDITION_UNKNOWN) {
        return Rez.Drawables.CONDITION_UNKNOWN;
      } else {
        return Rez.Drawables.NA;
      }
    } else {
      if (condition == Weather.CONDITION_CLEAR) {
        return Rez.Drawables.Code800n;
      } else if (condition == Weather.CONDITION_PARTLY_CLOUDY) {
        return Rez.Drawables.Code802n;
      } else if (condition == Weather.CONDITION_MOSTLY_CLOUDY) {
        return Rez.Drawables.Code804n;
      } else if (condition == Weather.CONDITION_RAIN) {
        return Rez.Drawables.Code520n;
      } else if (condition == Weather.CONDITION_SNOW) {
        return Rez.Drawables.Code620n;
      } else if (condition == Weather.CONDITION_WINDY) {
        return Rez.Drawables.CONDITION_WINDY;
      } else if (condition == Weather.CONDITION_THUNDERSTORMS) {
        return Rez.Drawables.Code211n;
      } else if (condition == Weather.CONDITION_WINTRY_MIX) {
        return Rez.Drawables.CONDITION_WINTRY_MIX;
      } else if (condition == Weather.CONDITION_FOG) {
        return Rez.Drawables.Code741n;
      } else if (condition == Weather.CONDITION_HAZY) {
        return Rez.Drawables.Code721n;
      } else if (condition == Weather.CONDITION_HAIL) {
        return Rez.Drawables.Code511n;
      } else if (condition == Weather.CONDITION_SCATTERED_SHOWERS) {
        return Rez.Drawables.Code531n;
      } else if (condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
        return Rez.Drawables.Code221n;
      } else if (condition == Weather.CONDITION_UNKNOWN_PRECIPITATION) {
        return Rez.Drawables.CONDITION_UNKNOWN_PRECIPITATION;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN) {
        return Rez.Drawables.Code500n;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN) {
        return Rez.Drawables.Code502n;
      } else if (condition == Weather.CONDITION_LIGHT_SNOW) {
        return Rez.Drawables.Code600n;
      } else if (condition == Weather.CONDITION_HEAVY_SNOW) {
        return Rez.Drawables.Code602n;
      } else if (condition == Weather.CONDITION_LIGHT_RAIN_SNOW) {
        return Rez.Drawables.Code615n;
      } else if (condition == Weather.CONDITION_HEAVY_RAIN_SNOW) {
        return Rez.Drawables.Code616n;
      } else if (condition == Weather.CONDITION_CLOUDY) {
        return Rez.Drawables.Code803n;
      } else if (condition == Weather.CONDITION_RAIN_SNOW) {
        return Rez.Drawables.Code616n;
      } else if (condition == Weather.CONDITION_PARTLY_CLEAR) {
        return Rez.Drawables.Code802n;
      } else if (condition == Weather.CONDITION_MOSTLY_CLEAR) {
        return Rez.Drawables.Code801n;
      } else if (condition == Weather.CONDITION_LIGHT_SHOWERS) {
        return Rez.Drawables.Code520n;
      } else if (condition == Weather.CONDITION_SHOWERS) {
        return Rez.Drawables.Code521n;
      } else if (condition == Weather.CONDITION_HEAVY_SHOWERS) {
        return Rez.Drawables.Code522n;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SHOWERS) {
        return Rez.Drawables.Code500n;
      } else if (condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS) {
        return Rez.Drawables.Code200n;
      } else if (condition == Weather.CONDITION_MIST) {
        return Rez.Drawables.Code701n;
      } else if (condition == Weather.CONDITION_DUST) {
        return Rez.Drawables.Code731n;
      } else if (condition == Weather.CONDITION_DRIZZLE) {
        return Rez.Drawables.Code301n;
      } else if (condition == Weather.CONDITION_TORNADO) {
        return Rez.Drawables.Code781n;
      } else if (condition == Weather.CONDITION_SMOKE) {
        return Rez.Drawables.Code711n;
      } else if (condition == Weather.CONDITION_ICE) {
        return Rez.Drawables.CONDITION_ICE;
      } else if (condition == Weather.CONDITION_SAND) {
        return Rez.Drawables.Code751n;
      } else if (condition == Weather.CONDITION_SQUALL) {
        return Rez.Drawables.CONDITION_SQUALL;
      } else if (condition == Weather.CONDITION_SANDSTORM) {
        return Rez.Drawables.Code751n;
      } else if (condition == Weather.CONDITION_VOLCANIC_ASH) {
        return Rez.Drawables.Code762n;
      } else if (condition == Weather.CONDITION_HAZE) {
        return Rez.Drawables.Code721n;
      } else if (condition == Weather.CONDITION_FAIR) {
        return Rez.Drawables.Code800n;
      } else if (condition == Weather.CONDITION_HURRICANE) {
        return Rez.Drawables.Code771n;
      } else if (condition == Weather.CONDITION_TROPICAL_STORM) {
        return Rez.Drawables.CONDITION_TROPICAL_STORM;
      } else if (condition == Weather.CONDITION_CHANCE_OF_SNOW) {
        return Rez.Drawables.Code600n;
      } else if (condition == Weather.CONDITION_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.Code615n;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN) {
        return Rez.Drawables.Code500n;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW) {
        return Rez.Drawables.Code600n;
      } else if (condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW) {
        return Rez.Drawables.Code616n;
      } else if (condition == Weather.CONDITION_FLURRIES) {
        return Rez.Drawables.CONDITION_FLURRIES;
      } else if (condition == Weather.CONDITION_FREEZING_RAIN) {
        return Rez.Drawables.CONDITION_FREEZING_RAIN;
      } else if (condition == Weather.CONDITION_SLEET) {
        return Rez.Drawables.Code613n;
      } else if (condition == Weather.CONDITION_ICE_SNOW) {
        return Rez.Drawables.Code611n;
      } else if (condition == Weather.CONDITION_THIN_CLOUDS) {
        return Rez.Drawables.Code801n;
      } else if (condition == Weather.CONDITION_UNKNOWN) {
        return Rez.Drawables.CONDITION_UNKNOWN;
      } else {
        return Rez.Drawables.NA;
      }
    }
  }
}
