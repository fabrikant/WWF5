import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class DataField extends AbstractField{

    function initialize(options){
        AbstractField.initialize(options);
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        var compl = getFieldComplication();

        if (compl != null){
            var font = getApp().watch_view.fonts[:sun_events];
            font.writeString(dc, dc.getWidth()/2, 0, compl.value.toString(), Graphics.TEXT_JUSTIFY_CENTER);
        }
        drawBorder(dc);
    }

    function getFieldComplication(){
        var compl = null;
        var compl_id = Application.Storage.getValue(getId());
		if (compl_id == null){
			compl_id = new Complications.Id(Application.Properties.getValue(getId()));
		}
		try {
			compl = Complications.getComplication(compl_id); 
		} catch(ex){
			System.println(compl_id);
			System.println(ex.getErrorMessage());
		}         
        return compl;
    }

}