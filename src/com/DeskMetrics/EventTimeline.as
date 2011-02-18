package com.DeskMetrics
{
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.FlexEvent;
	
	internal class EventTimeline
	{
		private var appList:Object;
		
		private var eventList:ArrayCollection;
			
		public function EventTimeline()
		{
			appList = new Object();
			eventList = new ArrayCollection();
		}
		
		public function addApp(application:Application,appID:String,appVersion:String):void
		{
			if (appList[application.name] !=null)
				return;

			var app:App = new App();
			app.setApplication(application);
			app.version = appVersion;
			app.id = appID;
			
			appList[application.name] = app;
			
			ExternalInterface.addCallback("finish",
				function():Boolean
				{ 
					DeskMetricsTracker.service.finalizeApp(app.id);
					Alert.show("bye!");
					return false; 
				});
			
			DeskMetricsTracker.service.startApp(app.id,app.version);
			application.addEventListener(FlexEvent.APPLICATION_COMPLETE,
				function():void{ 
					Alert.show("Finishing app");
				});
		}
		
		public function addButtonClick(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			
			ev.app = app;
			ev.objName = name;
			ev.timestamp = Util.getTimeStamp();
			ev.category = DefaultEventCategories.BUTTON_CLICK;
			
			eventList.addItem(ev);
			
			//sync
			if (DeskMetricsTracker.synchronous)
				DeskMetricsTracker.service.sendEventData(ev,app.id);
		}
		
		public function addModuleLoaded(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			
			ev.app = app;
			ev.objName = name;
			ev.timestamp = Util.getTimeStamp();
			ev.category = DefaultEventCategories.MODULE_LOAD;
			eventList.addItem(ev);
			
			if (DeskMetricsTracker.synchronous)
				DeskMetricsTracker.service.sendEventData(ev,app.id);
		}
		
		public function addStateChange(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			
			ev.app = app;
			ev.objName = name;
			ev.timestamp = Util.getTimeStamp();
			ev.category = DefaultEventCategories.STATE_CHANGE;
			eventList.addItem(ev);
			
			if (DeskMetricsTracker.synchronous)
				DeskMetricsTracker.service.sendEventData(ev,app.id);
		}
		
		public function getApp(appName:String):App
		{
			return appList[appName] as App;
		}
		
		public function addEvent(event:EventVO):void
		{
			eventList.addItem(event);
		}
		
		public function getEventList():ArrayCollection
		{
			return eventList;
		}
		
	}
	
}