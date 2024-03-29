import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class FontLessFont {

    protected var height, width, line_width, line_offset;
    protected var simple_style;
    protected var punctuation_width;

    private var segments, punctuation_segments;
    private var digits_dict, punctuation_dict, other_dict;

    function initialize(params) {
        
        self.height = params[:height];
        self.width = params[:width];
        self.line_width = params[:line_width];
        self.line_offset = params[:line_offset];
        simple_style = false;
        if (params.hasKey(:simple_style)){
            simple_style = params[:simple_style];
        }

        initSevenSegmentsPoligons();
        initPunctuationSegments();
        initOtherSymbols();
    }

    function getStringWidth(str){
        var res = 0;
        for (var i = 0; i < str.length(); i++){
            var sub_str = str.substring(i, i+1);
            if (digits_dict.hasKey(sub_str)){
                res += width;
            }else if (punctuation_dict.hasKey(sub_str)){
                res += punctuation_width;
            }else if (other_dict.hasKey(sub_str)){
                res += other_dict[sub_str].invoke(null, null, null, null);
            }
        }
        return res;
    }
    
    function writeString(dc, x, y, str, color_settings, justify){

        var next_x = x;
        var current_y = y;
        var str_width = getStringWidth(str);


        var just = justify;
        if (just >= Graphics.TEXT_JUSTIFY_VCENTER){
            current_y -= height / 2;
            just -= Graphics.TEXT_JUSTIFY_VCENTER;
        }
        if (just == Graphics.TEXT_JUSTIFY_CENTER){
            next_x -= str_width / 2;
        }else if (just == Graphics.TEXT_JUSTIFY_RIGHT){
            next_x -= str_width;
        }
        

        for (var i = 0; i < str.length(); i++){
            next_x += writeSymbol(dc, next_x, current_y, str.substring(i, i+1), color_settings);
        }
    }

    private function initSevenSegmentsPoligons(){
        segments = [];

        if (simple_style){
            
            var horizontal_size = width - 2 * line_offset;
            var vertical_size = Math.round((height - 2 * line_offset) / 2);

            var poligon_horizontal = [
                [0,0],
                [horizontal_size,0], 
                [horizontal_size,line_width],
                [0, line_width]
            ];

            var poligon_vertical = [
                [0, 0],
                [line_width, 0],
                [line_width, vertical_size],
                [0, vertical_size]
            ];
         
            var x_right = width - line_width - line_offset;
            var y_vertical = line_offset + vertical_size;
   
            segments.add(movePoligon(poligon_horizontal, line_offset, line_offset));
            segments.add(movePoligon(poligon_vertical, x_right, line_offset));
            segments.add(movePoligon(poligon_vertical, x_right, y_vertical));
            segments.add(movePoligon(poligon_horizontal, line_offset, height - line_offset - line_width));
            segments.add(movePoligon(poligon_vertical, line_offset, y_vertical));
            segments.add(movePoligon(poligon_vertical, line_offset, line_offset));
            segments.add(movePoligon(poligon_horizontal, line_offset, (height - line_width)/ 2));
        
        }else{

            var horizontal_size = width - 2 * line_offset - 5;
            var vertical_size = Math.round((height - 2 * line_offset) / 2) - 2;

            var poligon_up = [
                [0,0],
                [horizontal_size,0],
                [horizontal_size - line_width, line_width],
                [line_width, line_width]
            ];

            var poligon_right_up = [
                [0, line_width],
                [line_width, 0],
                [line_width, vertical_size],
                [0, vertical_size - line_width / 2]
            ];

            var poligon_right_bottom = [
                [0, line_width / 2],
                [line_width, 0],
                [line_width, vertical_size],
                [0, vertical_size - line_width]
            ];

            var poligon_left_up = [
                [0,0],
                [line_width, line_width / 2],
                [line_width, vertical_size - line_width],
                [0, vertical_size]
            ];

            var poligon_left_bottom = [
                [0,0],
                [line_width, line_width],
                [line_width, vertical_size - line_width / 2],
                [0, vertical_size]
            ];

            var poligon_bottom = [
                [line_width, 0],
                [horizontal_size - line_width, 0],
                [horizontal_size, line_width],
                [0, line_width]
            ];
            
            var poligon_center = [
                [0,line_width / 2],
                [line_width, 0],
                [horizontal_size - line_width,0],
                [horizontal_size, line_width / 2],
                [horizontal_size - line_width, line_width],
                [line_width, line_width]
            ];
        
            var x_up_bottom = line_offset + 2;
            var x_right = width - line_width - line_offset - 1;
            var y_vertical = line_offset + vertical_size + 2;

            segments.add(movePoligon(poligon_up, x_up_bottom, line_offset));
            segments.add(movePoligon(poligon_right_up, x_right, line_offset+1));
            segments.add(movePoligon(poligon_right_bottom, x_right, y_vertical+1));
            segments.add(movePoligon(poligon_bottom, x_up_bottom, height - line_offset - line_width));
            segments.add(movePoligon(poligon_left_up, line_offset, y_vertical+1));
            segments.add(movePoligon(poligon_left_bottom, line_offset, line_offset+1));
            segments.add(movePoligon(poligon_center, x_up_bottom, (height - line_width)/ 2));
        }

        //           0
        //          5 1
        //           6   
        //          4 2
        //           3

        digits_dict = {
            "0" =>[0, 1, 2, 3, 4, 5],
            "1" =>[1, 2],
            "2" =>[0, 1, 6, 4, 3],
            "3" =>[0, 1, 6, 2, 3],
            "4" =>[5, 6, 1, 2],
            "5" =>[0, 5, 6, 2, 3],
            "6" =>[0, 5, 4, 3, 2, 6],
            "7" =>[0, 1, 2],
            "8" =>[0, 1, 2, 3, 4, 5, 6],
            "9" =>[0, 1, 2, 3, 5, 6],
            "-" => [6],
            "C" => [0, 5, 4, 3],
            "F" => [0, 5, 6, 4],
        };    

    }

    private function initPunctuationSegments(){
        punctuation_segments = [];
        punctuation_width = 2 * line_offset + line_width;
        var dot_poligon = [
            [0, 0],
            [line_width, 0],
            [line_width, line_width],
            [0, line_width]
        ];

        punctuation_segments.add(movePoligon(dot_poligon, line_offset, 
            (height-line_width) / 2));
        punctuation_segments.add(movePoligon(dot_poligon, line_offset, 
            height - line_offset - line_width));
        
        // 0
        // 1
        
        punctuation_dict = {
            "." => [1],
            ":" => [0, 1],
            "," => [1],
        };

    }

    function initOtherSymbols(){

        other_dict = {
            "°" => self.method(:drawDegree),
        };
        
    }

    private function movePoligon(poligon, offset_x, offset_y){
        var res = [];
        for (var i = 0; i < poligon.size(); i++){
            res.add([poligon[i][0] + offset_x,  poligon[i][1] + offset_y]);
        }
        return res;
    }

    private function writeSymbol(dc, x, y, symb, color_settings){
        
        var res = 0;

        if (digits_dict.hasKey(symb)){
            drawLCDSymbol(dc, x, y, segments, digits_dict[symb], color_settings);
            res = width;
        }else if (punctuation_dict.hasKey(symb)){
            drawLCDSymbol(dc, x, y, punctuation_segments, punctuation_dict[symb], color_settings);
            res = punctuation_width;
        }else if (other_dict.hasKey(symb)){
            res = other_dict[symb].invoke(dc, x, y, color_settings);
        }

        drawBorder(dc, x, y, res);         
        return res;
    }

    private function drawLCDSymbol(dc, x, y, symb_segments, indexes, color_settings){

        //Закраска пустых сегментов
        //if (simple_style == false && color_settings[:font_empty_segments] != Graphics.COLOR_TRANSPARENT){
        if (color_settings[:font_empty_segments] != Graphics.COLOR_TRANSPARENT){    
            dc.setColor(color_settings[:font_empty_segments], color_settings[:font_empty_segments]);
            for (var i = 0; i < symb_segments.size(); i++){
                dc.fillPolygon(movePoligon(symb_segments[i], x, y));
            }
        }

        //Отрисовка символа
        dc.setColor(color_settings[:font], color_settings[:font]);
        for (var i = 0; i < indexes.size(); i++){
            dc.fillPolygon(movePoligon(symb_segments[indexes[i]], x, y));
        }
        
        //Контуры вокруг сегментов
        if (simple_style == false && color_settings[:font_border] != Graphics.COLOR_TRANSPARENT){
            dc.setColor(color_settings[:font_border], color_settings[:font_border]);
            for (var i = 0; i < symb_segments.size(); i++){
                drawSegmentBorder(movePoligon(symb_segments[i], x, y), dc);
            }
        }
    }

    private function drawSegmentBorder(poligon, dc){
        for (var i = 0; i < poligon.size(); i++){
            dc.drawLine(poligon[i][0], poligon[i][1], 
                poligon[(i + 1) % poligon.size()][0], poligon[(i + 1) % poligon.size()][1]);
        }
    }

    private function drawBorder(dc, x, y, symb_width){
        return;
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_GREEN);
        dc.drawRectangle(x, y, symb_width,  self.height);
    }


    /////////////////////////////////////////////////////////////////
    //OTHER SYMBOLS

    function drawDegree(dc, x, y, color_settings){
        
        var radius = Global.max((line_width * 1.3).toNumber(), 3);
        var symbol_width = 2 * radius + 2 * line_offset;
        if (dc != null){
            dc.setColor(color_settings[:font], color_settings[:background]);
            dc.setPenWidth(Global.max((line_width).toNumber(), 1));
            dc.drawCircle(x + line_offset + radius , y + line_offset + radius, radius);
        }
        return symbol_width;
    }
}