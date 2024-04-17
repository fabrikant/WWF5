using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Position;
using Toybox.Time;

(:background)
class BackgroundService extends System.ServiceDelegate {
  function initialize() {
    ServiceDelegate.initialize();
  }

  function onTemporalEvent() {
    var url = "https://api.openweathermap.org/data/2.5/weather";

    var location = Application.Storage.getValue(Global.LOCATION_KEY);
    if (location == null) {
      return;
    }
    var appid = Application.Properties.getValue("owm_key");

    Communications.makeWebRequest(
      url,
      {
        "lat" => location[0],
        "lon" => location[1],
        "appid" => appid,
        "units" => "metric",
        "lang" => getLang(),
      },
      {},
      method(:responseCallback)
    );
  }

  function responseCallback(responseCode, data) {
    var backgroundData;
    if (responseCode == 200) {
      backgroundData = {
        Global.STORAGE_KEY_RESPONCE_CODE => responseCode,
        Global.STORAGE_KEY_UPDATE_MOMENT => Time.now().value(),
        Global.STORAGE_KEY_TEMP => data["main"]["temp"],
        Global.STORAGE_KEY_ICON => data["weather"][0]["icon"],
        Global.STORAGE_KEY_WEATHER_ID => data["weather"][0]["id"],
        Global.STORAGE_KEY_WIND_SPEED => data["wind"]["speed"],
        Global.STORAGE_KEY_WIND_DEG => data["wind"]["deg"],
        Global.STORAGE_KEY_WEATHER_MAIN => data["weather"][0]["main"],
        Global.STORAGE_KEY_WEATHER_CITY => data["name"],
      };
      Background.exit(backgroundData);
    }
  }

  function getLang() {
    var res = "en";
    var sysLang = System.getDeviceSettings().systemLanguage;

    if (sysLang == System.LANGUAGE_ARA) {
      res = "ar";
    } else if (sysLang == System.LANGUAGE_BUL) {
      res = "bg";
    } else if (sysLang == System.LANGUAGE_CES) {
      res = "cz";
    } else if (sysLang == System.LANGUAGE_CHS) {
      res = "zh_cn";
    } else if (sysLang == System.LANGUAGE_CHT) {
      res = "zh_tw";
    } else if (sysLang == System.LANGUAGE_DAN) {
      res = "da";
    } else if (sysLang == System.LANGUAGE_DEU) {
      res = "de";
    } else if (sysLang == System.LANGUAGE_DUT) {
      res = "de";
    } else if (sysLang == System.LANGUAGE_FIN) {
      res = "fi";
    } else if (sysLang == System.LANGUAGE_FRE) {
      res = "fr";
    } else if (sysLang == System.LANGUAGE_GRE) {
      res = "el";
    } else if (sysLang == System.LANGUAGE_HEB) {
      res = "he";
    } else if (sysLang == System.LANGUAGE_HRV) {
      res = "hr";
    } else if (sysLang == System.LANGUAGE_HUN) {
      res = "hu";
    } else if (sysLang == System.LANGUAGE_IND) {
      res = "hi";
    } else if (sysLang == System.LANGUAGE_ITA) {
      res = "it";
    } else if (sysLang == System.LANGUAGE_JPN) {
      res = "ja";
    } else if (sysLang == System.LANGUAGE_KOR) {
      res = "	kr";
    } else if (sysLang == System.LANGUAGE_LAV) {
      res = "la";
    } else if (sysLang == System.LANGUAGE_LIT) {
      res = "lt";
    } else if (sysLang == System.LANGUAGE_NOB) {
      res = "no";
    } else if (sysLang == System.LANGUAGE_POL) {
      res = "pl";
    } else if (sysLang == System.LANGUAGE_POR) {
      res = "pt";
    } else if (sysLang == System.LANGUAGE_RON) {
      res = "ro";
    } else if (sysLang == System.LANGUAGE_RUS) {
      res = "ru";
    } else if (sysLang == System.LANGUAGE_SLO) {
      res = "sk";
    } else if (sysLang == System.LANGUAGE_SLV) {
      res = "	sl";
    } else if (sysLang == System.LANGUAGE_SPA) {
      res = "sp";
    } else if (sysLang == System.LANGUAGE_SWE) {
      res = "sv";
    } else if (sysLang == System.LANGUAGE_THA) {
      res = "th";
    } else if (sysLang == System.LANGUAGE_TUR) {
      res = "tr";
    } else if (sysLang == System.LANGUAGE_UKR) {
      res = "ua";
    } else if (sysLang == System.LANGUAGE_VIE) {
      res = "vi";
    } else if (sysLang == System.LANGUAGE_ZSM) {
      res = "zu";
    }
    return res;
  }
}
