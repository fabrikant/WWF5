import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;

class WWF5View extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();
        drawBackgoundPattern(dc);
        // Get and show the current time
        // var clockTime = System.getClockTime();
        // var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        // var view = View.findDrawableById("TimeLabel") as Text;
        // view.setText(timeString);

        // // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);
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

    function drawBackgoundPattern(dc as Dc) as Void {

        var pattern_color = Graphics.COLOR_DK_GRAY;
        var pattern_color_decorate = Graphics.COLOR_LT_GRAY;

        var colors = [pattern_color, pattern_color_decorate];
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
    }
}
