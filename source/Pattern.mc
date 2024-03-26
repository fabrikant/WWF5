import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class Pattern {

    var reference_points;
    var background_image;

    function initialize(all_colors){
        
        var opt = {
            :width=>System.getDeviceSettings().screenWidth,
            :height=>System.getDeviceSettings().screenHeight,
        };

        if ( Graphics has :createBufferedBitmap){
			background_image = Graphics.createBufferedBitmap(opt).get();
		}else{
			background_image = new Graphics.BufferedBitmap(opt);
		}

        reference_points = drawBackgoundPattern(all_colors);

    }
    
    private function drawBackgoundPattern(all_colors) {

        var dc = background_image.getDc();
        var colors = [all_colors[:pattern], all_colors[:pattern_decorate]];
        var pen_widths = [Math.round(dc.getWidth() / 50), 1];

        var r = dc.getWidth() / 2;
        var center = [dc.getWidth() / 2 - 1, dc.getHeight() / 2 - 1];
        dc.setAntiAlias(true);

        //Верхняя дуга
        var arc_angle = 80;
        var arc_angle_offset = 15;
        for (var i = 0; i < colors.size(); i++){
            dc.setColor(colors[i], colors[i]);
            dc.setPenWidth(pen_widths[i]);
            dc.drawArc(center[0], center[1], r, Graphics.ARC_COUNTER_CLOCKWISE, 
                arc_angle_offset, arc_angle_offset + arc_angle);
        }

        //Вычисление координат относительно верхней дуги
        var x1 = center[0] + r * Math.cos(Math.toRadians(arc_angle_offset + arc_angle));
        var x2 = x1 - Math.round(dc.getWidth() / 10);
        var y1 = center[1] - r * Math.sin(Math.toRadians(arc_angle_offset + arc_angle));
        var y2 = center[1] - r * Math.sin(Math.toRadians(arc_angle_offset));
        
        for (var i = 0; i < colors.size(); i++){
            dc.setColor(colors[i], colors[i]);
            dc.setPenWidth(pen_widths[i]);
            //Верхняя перекладина
            dc.drawLine(0, y2, dc.getWidth(), y2);
            //Верхняя косая черта
            dc.drawLine(x1, y1, x2, y2);
        }

        //Нижние дуги
        var arc_angle_bottom = 30;
        var arc_angle_offset_bottom = 35;
        for (var i = 0; i < colors.size(); i++){
            dc.setColor(colors[i], colors[i]);
            dc.setPenWidth(pen_widths[i]);

            dc.drawArc(center[0], center[1], r, Graphics.ARC_CLOCKWISE, 
                270 - arc_angle_offset_bottom, 270 - arc_angle_offset_bottom - arc_angle_bottom);
            dc.drawArc(center[0], center[1], r, Graphics.ARC_COUNTER_CLOCKWISE, 
                270 + arc_angle_offset_bottom, 270 + arc_angle_offset_bottom + arc_angle_bottom);
        }

        var y4 = center[1] + r * Math.sin(Math.toRadians(90 - arc_angle_bottom - arc_angle_offset_bottom));
        var y5 = center[1] + r * Math.sin(Math.toRadians(90 - arc_angle_offset_bottom));

        for (var i = 0; i < colors.size(); i++){
            dc.setColor(colors[i], colors[i]);
            dc.setPenWidth(pen_widths[i]);
            //Перекладина нижних дуг верхняя
            dc.drawLine(0, y4, dc.getWidth(), y4);
            //Перекладина нижних дуг нижняя
            dc.drawLine(0, y5, dc.getWidth(), y5);
        }

        //Дполнительное поле справа снизу под циферблатом
        var y3 = y4 - Math.round(dc.getHeight() / 10);
        var c = Math.sqrt(Math.pow(y1-y2, 2)+Math.pow(x1-x2, 2));
        
        var x4 = x2 + Math.round((x1 - x2) / 2);
        var x3 = x4 + Math.round((y4 - y3) * (x1 - x2) / c);
        for (var i = 0; i < colors.size(); i++){
            dc.setColor(colors[i], colors[i]);
            dc.setPenWidth(pen_widths[i]);
            dc.drawLine(x3, y3, x4, y4);
            dc.drawLine(x3, y3, dc.getWidth(), y3);
        }
        return {:x => [x1, x2, x3, x4], :y => [y1, y2, y3, y4, y5], :pen_width => pen_widths[0]};
    }
}