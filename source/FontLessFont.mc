import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

class FontLessFont {

    protected var glifs;
    protected var height;

    //options - dictonary
    // {
    //     :width => Number,
    //     :height => Number,
    //     :line_width => Number,
    //     :line_offset => Number,
    //     :simple_style => Boolean (optional, default - false),
    // }
    function initialize(options) {
        
        if (! options.hasKey(:simple_style)){
            options[:simple_style] = false;
        }
        glifs = {};
        height = options[:height];
        initSevenSegmentsPoligons(options);
        initPunctuationSegments(options);
        initOtherSymbols(options);

    }

    function getStringWidth(str){
        var res = 0;
        for (var i = 0; i < str.length(); i++){
            var sub_str = str.substring(i, i+1);
            if (glifs.hasKey(sub_str)){
                res += glifs[sub_str].getWidth();
            }
        }
        return res;
    }
    
    function writeString(dc, x, y, str, justify){

        var next_x = x;
        var current_y = y;
        var str_width = getStringWidth(str);


        var just = justify;
        if (just >= Graphics.TEXT_JUSTIFY_VCENTER){
            current_y -= Math.floor(height / 2);
            just -= Graphics.TEXT_JUSTIFY_VCENTER;
        }
        if (just == Graphics.TEXT_JUSTIFY_CENTER){
            next_x -= Math.floor(str_width / 2);
        }else if (just == Graphics.TEXT_JUSTIFY_RIGHT){
            next_x -= str_width;
        }
        

        for (var i = 0; i < str.length(); i++){
            var sub_str = str.substring(i, i+1);
            if (glifs.hasKey(sub_str)){
                var bitmap = glifs[sub_str].get();
                dc.drawBitmap(next_x, current_y, bitmap);
                next_x += bitmap.getDc().getWidth();    
            }
        }
    }

    //width-height ratio
    function getRatio(){
        var width = getStringWidth("0");
        return (width.toFloat() / height);
    }

    private function initSevenSegmentsPoligons(options){
        var seven_segments_poligons = [];

        if (options[:simple_style]){
            
            var horizontal_size = options[:width] - 2 * options[:line_offset];
            var vertical_size = Math.round((options[:height] - 2 * options[:line_offset]) / 2);

            var poligon_horizontal = [
                [0,0],
                [horizontal_size,0], 
                [horizontal_size,options[:line_width]],
                [0, options[:line_width]]
            ];

            var poligon_vertical = [
                [0, 0],
                [options[:line_width], 0],
                [options[:line_width], vertical_size],
                [0, vertical_size]
            ];
         
            var x_right = options[:width] - options[:line_width] - options[:line_offset];
            var y_vertical = options[:line_offset] + vertical_size;
   
            seven_segments_poligons.add(movePoligon(poligon_horizontal, options[:line_offset], options[:line_offset]));
            seven_segments_poligons.add(movePoligon(poligon_vertical, x_right, options[:line_offset]));
            seven_segments_poligons.add(movePoligon(poligon_vertical, x_right, y_vertical));
            seven_segments_poligons.add(movePoligon(poligon_horizontal, options[:line_offset], options[:height] - options[:line_offset] - options[:line_width]));
            seven_segments_poligons.add(movePoligon(poligon_vertical, options[:line_offset], y_vertical));
            seven_segments_poligons.add(movePoligon(poligon_vertical, options[:line_offset], options[:line_offset]));
            seven_segments_poligons.add(movePoligon(poligon_horizontal, options[:line_offset], (options[:height] - options[:line_width])/ 2));
        
        }else{

            var horizontal_size = options[:width] - 2 * options[:line_offset] - 5;
            var vertical_size = Math.round((options[:height] - 2 * options[:line_offset]) / 2) - 2;

            var poligon_up = [
                [0,0],
                [horizontal_size,0],
                [horizontal_size - options[:line_width], options[:line_width]],
                [options[:line_width], options[:line_width]]
            ];

            var poligon_right_up = [
                [0, options[:line_width]],
                [options[:line_width], 0],
                [options[:line_width], vertical_size],
                [0, vertical_size - options[:line_width] / 2]
            ];

            var poligon_right_bottom = [
                [0, options[:line_width] / 2],
                [options[:line_width], 0],
                [options[:line_width], vertical_size],
                [0, vertical_size - options[:line_width]]
            ];

            var poligon_left_up = [
                [0,0],
                [options[:line_width], options[:line_width] / 2],
                [options[:line_width], vertical_size - options[:line_width]],
                [0, vertical_size]
            ];

            var poligon_left_bottom = [
                [0,0],
                [options[:line_width], options[:line_width]],
                [options[:line_width], vertical_size - options[:line_width] / 2],
                [0, vertical_size]
            ];

            var poligon_bottom = [
                [options[:line_width], 0],
                [horizontal_size - options[:line_width], 0],
                [horizontal_size, options[:line_width]],
                [0, options[:line_width]]
            ];
            
            var poligon_center = [
                [0,options[:line_width] / 2],
                [options[:line_width], 0],
                [horizontal_size - options[:line_width],0],
                [horizontal_size, options[:line_width] / 2],
                [horizontal_size - options[:line_width], options[:line_width]],
                [options[:line_width], options[:line_width]]
            ];
        
            var x_up_bottom = options[:line_offset] + 2;
            var x_right = options[:width] - options[:line_width] - options[:line_offset] - 1;
            var y_vertical = options[:line_offset] + vertical_size + 2;

            seven_segments_poligons.add(movePoligon(poligon_up, x_up_bottom, options[:line_offset]));
            seven_segments_poligons.add(movePoligon(poligon_right_up, x_right, options[:line_offset]+1));
            seven_segments_poligons.add(movePoligon(poligon_right_bottom, x_right, y_vertical+1));
            seven_segments_poligons.add(movePoligon(poligon_bottom, x_up_bottom, options[:height] - options[:line_offset] - options[:line_width]));
            seven_segments_poligons.add(movePoligon(poligon_left_up, options[:line_offset], y_vertical+1));
            seven_segments_poligons.add(movePoligon(poligon_left_bottom, options[:line_offset], options[:line_offset]+1));
            seven_segments_poligons.add(movePoligon(poligon_center, x_up_bottom, (options[:height] - options[:line_width])/ 2));
        }

        //           0
        //          5 1
        //           6   
        //          4 2
        //           3

        var digits_patterns = {
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
            // "C" => [0, 5, 4, 3],
            // "F" => [0, 5, 6, 4],
        };   


        var invert_digits_patterns = {};
        var keys = digits_patterns.keys();
        for(var i=0; i<keys.size(); i++){
            invert_digits_patterns[keys[i]] = [];
            for(var j=0; j < 7; j++){
                if (digits_patterns[keys[i]].indexOf(j) < 0){
                    invert_digits_patterns[keys[i]].add(j);
                }
            }
        }

        for (var i = 0; i < keys.size(); i++){
            glifs[keys[i]] = createGlifBitmap(options, 
                seven_segments_poligons, 
                digits_patterns[keys[i]], 
                invert_digits_patterns[keys[i]]);
        }

    }

    private function initPunctuationSegments(options){
        var punctuation_segments_poligons = [];
        var dot_poligon = [
            [0, 0],
            [options[:line_width], 0],
            [options[:line_width], options[:line_width]],
            [0, options[:line_width]]
        ];

        punctuation_segments_poligons.add(movePoligon(dot_poligon, options[:line_offset], 
            (options[:height]-options[:line_width]) / 2));
        punctuation_segments_poligons.add(movePoligon(dot_poligon, options[:line_offset], 
            options[:height] - options[:line_offset] - options[:line_width]));
        
        // 0
        // 1
        
        var punctuations_patterns = {
            "." => [1],
            ":" => [0, 1],
            //"," => [1],
        };

        options[:width] = 2 * options[:line_offset] + options[:line_width];
        var keys = punctuations_patterns.keys();
        for (var i = 0; i < keys.size(); i++){
            glifs[keys[i]] = createGlifBitmap(options, 
                punctuation_segments_poligons, 
                punctuations_patterns[keys[i]], []);
        }

    }

    function createGlifBitmap(options, segment_poligons, symbol_pattern, invert_symbol_pattern){
        var colors = getApp().watch_view.colors;
        var _buf_bitmap_ref = Graphics.createBufferedBitmap({
				:width => options[:width],
				:height => options[:height],
			});
        var buf_bitmap = _buf_bitmap_ref.get();
        var dc = buf_bitmap.getDc(); 
        dc.setColor(colors[:background], colors[:background]);
        dc.setAntiAlias(true);
        dc.clear();

        //Закраска пустых сегментов
        if (colors[:font_empty_segments] != Graphics.COLOR_TRANSPARENT){    
            dc.setColor(colors[:font_empty_segments], colors[:font_empty_segments]);
            for (var i = 0; i < invert_symbol_pattern.size(); i++){
                dc.fillPolygon(segment_poligons[invert_symbol_pattern[i]]);
            }
        }

        //Отрисовка символа
        dc.setColor(colors[:font], colors[:font]);
        for (var i = 0; i < symbol_pattern.size(); i++){
            dc.fillPolygon(segment_poligons[symbol_pattern[i]]);
        }
        
        return _buf_bitmap_ref;
    }


    function initOtherSymbols(options){

        glifs["°"] = drawDegree(options);
        
    }

    private function movePoligon(poligon, offset_x, offset_y){
        var res = [];
        for (var i = 0; i < poligon.size(); i++){
            res.add([poligon[i][0] + offset_x,  poligon[i][1] + offset_y]);
        }
        return res;
    }

    /////////////////////////////////////////////////////////////////
    //OTHER SYMBOLS

    function drawDegree(options){
        
        var colors = getApp().watch_view.colors;

        var radius = Global.max((options[:line_width] * 1.3).toNumber(), 3);
        var symbol_width = 2 * radius + 2 * options[:line_offset];

        var _buf_bitmap_ref = Graphics.createBufferedBitmap({
				:width => symbol_width,
				:height => options[:height],
			});
        var buf_bitmap = _buf_bitmap_ref.get();
        var dc = buf_bitmap.getDc(); 
        dc.setColor(colors[:background], colors[:background]);
        dc.setAntiAlias(true);
        dc.clear();

        dc.setColor(colors[:font], colors[:background]);
        dc.setPenWidth(Global.max(Math.floor(options[:line_width] * 0.6), 1));
        dc.drawCircle(options[:line_offset] + radius, options[:line_offset] + radius, radius);
        return _buf_bitmap_ref;
    }
}