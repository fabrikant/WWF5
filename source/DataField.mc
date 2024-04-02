import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Complications;
import Toybox.Lang;

class DataField extends AbstractField{

    var label_x, label_y, label_radius, label_angle, font_label;

    function initialize(options){
        AbstractField.initialize(options);
        var font_height = Math.round(System.getDeviceSettings().screenHeight * 0.07).toNumber();
        font_label = Graphics.getVectorFont({
                :face => vectorFontName(),
                :size => font_height,
            }); 
        if (getId().equals("data_type_1")){
            calculateLabelCoord(177, 1);
        }if (getId().equals("data_type_3")){
            calculateLabelCoord(363, -1);
        }
    }

    function draw(colors){
        AbstractField.draw(colors);
        var dc = getDc();
        var compl = getFieldComplication();

        if (compl != null){
            var font_value = getApp().watch_view.fonts[:sun_events];
            font_value.writeString(dc, 
                dc.getWidth()/2, 
                0, 
                getComplicationValue(compl), 
                Graphics.TEXT_JUSTIFY_CENTER);
            
            //draw label, decorate fields
            var options = {
                :compl => compl, :font_label => font_label, 
                :font_value => font_value, :colors => colors};
            if (getId().equals("data_type_1")){
                drawFieldLabel(options, Graphics.TEXT_JUSTIFY_RIGHT);
            }if (getId().equals("data_type_2")){
                drawField2Label(options);
            }if (getId().equals("data_type_3")){
                drawFieldLabel(options, Graphics.TEXT_JUSTIFY_LEFT);
            }
        }
        drawBorder(dc);
    }

    function getComplicationValue(compl){
        var res = compl.value.toString(); 
        return res;
    }

    function calculateLabelCoord(angle_offset, direction){
        var pattern = getApp().watch_view.pattern;
        var diam = System.getDeviceSettings().screenHeight;
        var system_radius = diam / 2;
        label_radius = system_radius - pattern.reference_points[:pen_width];
        var leg = pattern.reference_points[:y][5] - system_radius;
        var sin_angle = leg / system_radius;
        label_angle = angle_offset + direction * Math.toDegrees(Math.asin(sin_angle));

        label_x = system_radius - getX();
        label_y = system_radius - getY();
    }

    function drawFieldLabel(options, just){

        var dc = getDc();
        dc.setColor(options[:colors][:font], options[:colors][:background]);
        var label = getComplicationLabel(options[:compl]);

        if (label != null){
            dc.drawRadialText(
                label_x, 
                label_y, 
                font_label, label, 
                just, 
                label_angle, 
                label_radius, 
                Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);
        }
    } 

    function drawField2Label(options){
        var dc = getDc();
        
        //decorate field
        dc.setColor(options[:colors][:pattern_decorate], options[:colors][:pattern_decorate]);
        var offset = dc.getHeight() * 0.15 ;
        dc.drawLine(0, offset, 0, dc.getHeight() - offset);
        dc.drawLine(dc.getWidth() - 1, offset, dc.getWidth() - 1, dc.getHeight() - offset);

        dc.setColor(options[:colors][:font], options[:colors][:background]);
        var label = getComplicationLabel(options[:compl]);
        if (label != null){
            dc.drawText(dc.getWidth() / 2, 
            dc.getHeight() - Graphics.getFontHeight(options[:font_label]), 
            options[:font_label], 
            options[:compl].shortLabel, 
            Graphics.TEXT_JUSTIFY_CENTER);
        }
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

    function getComplicationLabel(compl){
        var res = compl.shortLabel;
        if (res == null){
            if (compl.unit instanceof Lang.String){
                res = compl.unit;
            }
        }
        return res;
    }

}