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
					Tracker.service.finalizeApp(app);
					Alert.show("bye!");
					return false; 
				});
			
			Tracker.service.startApp(app);
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
			ev.state = app.getApplication().currentState;
			ev.timestamp = Util.getTimeStamp();
			ev.type = Events.BUTTON_CLICK;
			eventList.addItem(ev);
			
			//sync
			if (Tracker.synchronous)
				Tracker.service.sendEventData(ev,app);
		}
		
		public function addModuleLoaded(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			
			ev.app = app;
			ev.objName = name;
			ev.state = app.getApplication().currentState;
			ev.timestamp = Util.getTimeStamp();
			ev.type = Events.MODULE_LOAD;
			eventList.addItem(ev);
			
			if (Tracker.synchronous)
				Tracker.service.sendEventData(ev,app);
		}
		
		public function addStateChange(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			
			ev.app = app;
			ev.objName = name;
			ev.state = app.getApplication().currentState;
			ev.timestamp = Util.getTimeStamp();
			ev.type = Events.STATE_CHANGE;
			eventList.addItem(ev);
			
			if (Tracker.synchronous)
				Tracker.service.sendEventData(ev,app);
		}
		
		public function getApp(appName:String):App
		{
			return appList[appName] as App;
		}
		
		public function getEventList():ArrayCollection
		{
			return eventList;
		}
		
	}
	
}