using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class mywatchfaceView extends Ui.WatchFace {

	var customNum_100;
	var customIcon;
	var hourColor;
	var minuteColor;
	
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.WatchFace(dc));
        customNum_100 = Ui.loadResource(Rez.Fonts.customNum_100);
        customIcon = Ui.loadResource(Rez.Fonts.customIcon);
        hourColor = getDefaultProperty("hourColor", 999);
        minuteColor = getDefaultProperty("minuteColor", 999);
    }
    
    function getDefaultProperty(keyWord, defaultNum){
    	var value = App.getApp().getProperty(keyWord);
    	if (value != null) {

            if (value instanceof Lang.Number) {
                return value;
            }
            else if (value instanceof Lang.Boolean) {
                return value ? 1 : 0;
            }
            else if (value instanceof Lang.Double ||
                     value instanceof Lang.Float ||
                     value instanceof Lang.Long ||
                     value instanceof Lang.String) {
                return value.toNumber();
            }
        }
        return defaultNum;
    }

	function getColor(keyWord, defaultColor){
    	var Color = App.getApp().getProperty(keyWord);
    	if(Color == 999){
    		Color = defaultColor;
    	}
    	return Color;
    }

    // Update the view
    function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.clear();
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        if(!Sys.getDeviceSettings().is24Hour){
        	if(hour > 12){
        		hour %= 12;
        	}
        }
        hourColor = getColor("hourColor", Gfx.COLOR_WHITE);
        dc.setColor(hourColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(109, 60, customNum_100, hour.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT);
        minuteColor = getColor("minuteColor", Gfx.COLOR_WHITE);
        dc.setColor(minuteColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(109, 60, customNum_100, clockTime.min.format("%02d"), Gfx.TEXT_JUSTIFY_LEFT);
        
        var deviceStats = Sys.getSystemStats();
        var batteryLife = deviceStats.battery;
        if (batteryLife >= 82 && batteryLife <= 100) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			dc.drawText(100, 15, customIcon, "B", Gfx.TEXT_JUSTIFY_RIGHT);
		}else if (batteryLife < 82 && batteryLife >= 60) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			dc.drawText(100, 15, customIcon, "C", Gfx.TEXT_JUSTIFY_RIGHT);
		}else if (batteryLife < 60 && batteryLife >= 35) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
			dc.drawText(100, 15, customIcon, "D", Gfx.TEXT_JUSTIFY_RIGHT);
		}else if (batteryLife < 35 && battery >= 15) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			dc.drawText(100, 15, customIcon, "E", Gfx.TEXT_JUSTIFY_RIGHT);
		}else if (batteryLife < 15 && battery >= 0) {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
			dc.drawText(100, 15, customIcon, "F", Gfx.TEXT_JUSTIFY_RIGHT);
		}
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(109, 15, Gfx.FONT_SYSTEM_XTINY, batteryLife.format("%.1f") + "%", Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawText(109, 15, customIcon, "B", Gfx.TEXT_JUSTIFY_RIGHT);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
