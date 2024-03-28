using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;

//GeneralMenu
//	Colors  
//		color_font 		
//		color_font_border
//		color_font_empty_segments 
//		color_background
//		color_pattern 
//		color_pattern_decorate 
// 
// 


module Menu {

	function GeneralMenu(){
		var items_props = [];
		items_props.add({
			:item_class => :SubMenuItem,
			:rez_label => Rez.Strings.SubmenuColors,
			:identifier => :ColorsSubMenu,
			:method => :ColorsSubMenu,
		});

		var options = {:title => Rez.Strings.MenuHeader, :items => items_props};
		return new SubMenu(options);
	}

	function ColorsSubMenu(){

		var items_props = [];
		items_props.add({
			:item_class => :ColorPropertyItem,
			:rez_label => Rez.Strings.color_font,
			:identifier => "color_font",
			:method => :ColorSelectMenu,
		});
		items_props.add({
			:item_class => :ColorPropertyItem,
			:rez_label => Rez.Strings.color_font_border,
			:identifier => "color_font_border",
			:method => :ColorSelectMenu,
		});
		items_props.add({
			:item_class => :ColorPropertyItem,
			:rez_label => Rez.Strings.color_font_empty_segments,
			:identifier => "color_font_empty_segments",
			:method => :ColorSelectMenu,
		});
		items_props.add({
			:item_class => :ColorPropertyItem,
			:rez_label => Rez.Strings.color_background,
			:identifier => "color_background",
			:method => :ColorSelectMenu,
		});
		items_props.add({
			:item_class => :ColorPropertyItem,
			:rez_label => Rez.Strings.color_pattern,
			:identifier => "color_pattern",
			:method => :ColorSelectMenu,
		});
		items_props.add({
			:item_class => :ColorPropertyItem,
			:rez_label => Rez.Strings.color_pattern_decorate,
			:identifier => "color_pattern_decorate",
			:method => :ColorSelectMenu,
		});

		var options = {:title => Rez.Strings.SubmenuColors, :items => items_props};
		return new SubMenu(options);
	
	}

	function ColorSelectMenu(paren_item_week){

		var items_props = [{
						:item_class => :ColorSelectItem,
						:identifier => Graphics.COLOR_TRANSPARENT.toString(),
						:color => Graphics.COLOR_TRANSPARENT,
						:paren_item_week => paren_item_week}];

		var values = [0x00, 0x55 ,0xAA, 0xFF];
		for (var i=0; i < values.size(); i++){
			for (var j=0; j < values.size(); j++){
				for (var k=0; k < values.size(); k++){
					var color = (values[i] << 16)+(values[j] << 8)+values[k];
					items_props.add({
						:item_class => :ColorSelectItem,
						:identifier => color.toString(),
						:color => color,
						:paren_item_week => paren_item_week});
				}
			}
		}

		var options = {:title => Rez.Strings.SubmenuColors, 
			:items => items_props,};
		return new SubMenu(options);
	}
}

//*****************************************************************************
class SubMenuItem extends WatchUi.MenuItem{
	
	var method_symbol;

	function initialize(options) {
		self.method_symbol = options[:method];
		var label = Application.loadResource(options[:rez_label]);
		MenuItem.initialize(label, "", options[:identifier], {});
	}
	
	function onSelectItem(){
		var method = new Lang.Method(Menu, method_symbol);
		var submenu = method.invoke();
		WatchUi.pushView(submenu, new SimpleMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
	}
}

//*****************************************************************************
class ColorPropertyItem extends WatchUi.IconMenuItem{

	var method_symbol;

	function initialize(options) {
		self.method_symbol = options[:method];
		var label = Application.loadResource(options[:rez_label]);
		var color = Application.Properties.getValue(options[:identifier]);
		var icon = createIcon(color);
		IconMenuItem.initialize(label, color.toString(), options[:identifier], icon, {});
	}
	
	function borderIcon(icon, color, color_border){
		var dc = icon.get().getDc();
		dc.setColor(color, color);
		dc.clear();
		dc.setColor(color_border, color_border);
		dc.drawRectangle(0, 0, dc.getWidth(), dc.getHeight());
	}

	function createIcon(color){
		var icon;
		var w = 30;
		var h = 30;
		if (color == Graphics.COLOR_TRANSPARENT){
			icon = Graphics.createBufferedBitmap({:width => w, :height => h,
				:palette => [Graphics.COLOR_WHITE, Graphics.COLOR_BLACK],});
			var dc = icon.get().getDc();
			dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
			dc.clear();
			dc.setPenWidth(5);
			dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
			dc.drawLine(0, 0, dc.getWidth(), dc.getHeight());
			dc.drawLine(0, dc.getHeight(), dc.getWidth(), 0);
		}else if(color == Graphics.COLOR_BLACK){
			icon = Graphics.createBufferedBitmap({:width => w, :height => h,
				:palette => [color, Graphics.COLOR_WHITE],});
			borderIcon(icon, color, Graphics.COLOR_WHITE);
		}else if(color == Graphics.COLOR_WHITE){
			icon = Graphics.createBufferedBitmap({:width => w, :height => h,
				:palette => [color, Graphics.COLOR_BLACK],});
			borderIcon(icon, color, Graphics.COLOR_BLACK);
		}else{
			icon = Graphics.createBufferedBitmap({:width => w, :height => h,
				:palette => [color]});
		}
		return new WatchUi.Bitmap({:bitmap => icon});
	}

	function onSelectItem(){
		var method = new Lang.Method(Menu, method_symbol);
		var submenu = method.invoke(self.weak());
		WatchUi.pushView(submenu, new SimpleMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
	}

	function onSelectSubmenuItem(newValue){
		var color = newValue.toNumber();
		Application.Properties.setValue(getId(),color);
		setSubLabel(newValue.toString());
		setIcon(createIcon(color));
	}
}

//*****************************************************************************
class ColorSelectItem extends ColorPropertyItem{

	var paren_item_week;

	function initialize(options) {
		var label = options[:identifier].toString();
		var icon = createIcon(options[:color]);
		self.paren_item_week = options[:paren_item_week];
		IconMenuItem.initialize(label, null, options[:identifier], icon, {});
	}
	
	function onSelectItem(){
		if (paren_item_week.stillAlive()){
			var obj = paren_item_week.get();
			if (obj != null){
				obj.onSelectSubmenuItem(getId());
			}
		}
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);			
	}
}

//*****************************************************************************
class SubMenu extends WatchUi.Menu2{
	
	function initialize(options) {
		Menu2.initialize({:title=> Application.loadResource(options[:title])});

		for (var i = 0; i < options[:items].size(); i++){
			var item_prop = options[:items][i];
			if (item_prop[:item_class] == :SubMenuItem){
				addItem(new SubMenuItem(item_prop));	
			}else if(item_prop[:item_class] == :ColorPropertyItem){
				addItem(new ColorPropertyItem(item_prop));
			}else if(item_prop[:item_class] == :ColorSelectItem){
				addItem(new ColorSelectItem(item_prop));
			}
		}
	}
	
	function onHide(){
		getApp().onSettingsChanged();
	}
}

//*****************************************************************************
//DELEGATE
class SimpleMenuDelegate extends WatchUi.Menu2InputDelegate{
	
	function initialize() {
        Menu2InputDelegate.initialize();
    }
    
	function onSelect(item){
		item.onSelectItem();
	}
}