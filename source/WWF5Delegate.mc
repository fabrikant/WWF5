import Toybox.WatchUi;
import Toybox.System;

class WWF5Delegate extends WatchUi.WatchFaceDelegate{

    function onPowerBudgetExceeded(powerInfo){
        System.println("onPowerBudgetExceeded");
        System.println("TimeAverage: "+powerInfo.executionTimeAverage);
        System.println("TimeLimit: "+powerInfo.executionTimeLimit);
    }

}