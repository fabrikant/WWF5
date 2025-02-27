import Toybox.WatchUi;

class TextDelegate extends WatchUi.TextPickerDelegate {
  var parent_week;

  function initialize(parent_week) {
    self.parent_week = parent_week;
    TextPickerDelegate.initialize();
  }

  function onTextEntered(text, changed) {
    if (changed && parent_week.stillAlive()) {
      var obj = parent_week.get();
      obj.onSetText(text);
    }
  }

  function onCancel() {
    //screenMessage = "Canceled";
  }
}
