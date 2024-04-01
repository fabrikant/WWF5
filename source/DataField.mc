import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class DataField extends AbstractField{

    var data_type_property_name;

    function initialize(options){
        AbstractField.initialize(options);
        data_type_property_name = options[:property_name];
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        // var compl_type = getApp().system_complications[Complications.COMPLICATION_TYPE_BATTERY];
        // var compl = Complications.getComplication(compl_type);

        // if (compl != null){
        //     drawScale(dc, colors, compl, scaleWidth());
        // }
        drawBorder(dc);
    }

}