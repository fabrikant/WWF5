import Toybox.Application;
import Toybox.Time;
import Toybox.System;

module Presets {
  enum {
    STORAGE_KEY = 0,
    NAME_KEY,
  }

  function generatePresetsStorage() {
    if (Application.Storage.getValue(STORAGE_KEY) != null) {
      return;
    }

    var resources = Application.loadResource(Rez.JsonData.presets);
    var preset_key = Time.now().value();
    var target_presets = {};

    for (var i = 0; i < resources.size(); i++) {
      target_presets[preset_key] = convertResToStoragePreset(resources[i]);
      preset_key++;
    }

    var keys = target_presets.keys();
    if (keys.size() > 0) {
      Application.Storage.setValue(STORAGE_KEY, target_presets);
    }
  }

  function convertResToStoragePreset(res_dict) {
    var keys = res_dict.keys();
    var name = keys[0];
    var values_dict = res_dict[name];
    var result = { NAME_KEY => name };
    keys = values_dict.keys();
    for (var i = 0; i < keys.size(); i++) {
      result[keys[i]] = values_dict[keys[i]].toLongWithBase(16);
    }
    return result;
  }

  function renamePreset(options) {
    var presets = Application.Storage.getValue(STORAGE_KEY);
    presets[options[:id]][NAME_KEY] = options[:value];
    Application.Storage.setValue(STORAGE_KEY, presets);
  }

  function savePreset(options) {
    var prop_keys = Global.getPropertiesKeys();
    var preset = {};
    for (var i = 0; i < prop_keys.size(); i++) {
      preset[prop_keys[i]] = Application.Properties.getValue(prop_keys[i]);
    }

    var presets = Application.Storage.getValue(STORAGE_KEY);
    if (presets == null) {
      presets = {};
    }
    presets[Time.now().value()] = preset;

    Application.Storage.setValue(STORAGE_KEY, presets);
  }

  function applyPreset(options) {
    var presets = Application.Storage.getValue(STORAGE_KEY);
    if (presets == null) {
      return;
    }
    var id = options[:id];
    if (presets.hasKey(id)) {
      var prop_keys = Global.getPropertiesKeys();
      for (var i = 0; i < prop_keys.size(); i++) {
        if (presets[id].hasKey(prop_keys[i])) {
          Application.Properties.setValue(
            prop_keys[i],
            presets[id][prop_keys[i]]
          );
        }
      }
    }
  }

  function removePreset(options) {
    var presets = Application.Storage.getValue(STORAGE_KEY);
    if (presets == null) {
      return;
    }
    var id = options[:id];
    if (presets.hasKey(id)) {
      presets.remove(id);
    }
    Application.Storage.setValue(STORAGE_KEY, presets);
  }

  function presetIdToString(moment_value, presets) {
    if (presets[moment_value][NAME_KEY] != null) {
      return presets[moment_value][NAME_KEY];
    } else {
      var moment = new Time.Moment(moment_value);
      var info = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
      return Toybox.Lang.format("$1$/$2$/$3$ $4$:$5$:$6$", [
        info.year.format("%04d"),
        info.month.format("%02d"),
        info.day.format("%02d"),
        info.hour.format("%02d"),
        info.min.format("%02d"),
        info.sec.format("%02d"),
      ]);
    }
  }
}
