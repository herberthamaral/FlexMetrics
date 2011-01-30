package com.DeskMetrics
{
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	internal class EventTimeline
	{
		private var appList:Object;
		
		private var eventList:ArrayCollection;
			
		public function EventTimeline()
		{
			appList = new Object();
			eventList = new ArrayCollection();
		}
		
		public function addApp(application:Application):void
		{
			if (appList[application.name] !=null)
				return;

			var app:App = new App();
			app.setApplication(application);
			appList[application.name] = app;
			
			var d:Date = new Date();
			
			var ev:EventVO = new EventVO();
			ev.app = app;
			ev.objName = application.name;
			ev.state = application.currentState;
			
			ev.timestamp = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			ev.type = Events.APP_START;
			eventList.addItem(ev);
		}
		
		public function addButtonClick(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			var d: Date = new Date();
			
			ev.app = app;
			ev.objName = name;
			ev.state = app.getApplication().currentState;
			ev.timestamp = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			ev.type = Events.BUTTON_CLICK;
			eventList.addItem(ev);
		}
		
		public function addModuleLoaded(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			var d: Date = new Date();
			
			ev.app = app;
			ev.objName = name;
			ev.state = app.getApplication().currentState;
			ev.timestamp = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			ev.type = Events.MODULE_LOAD;
			eventList.addItem(ev);
		}
		
		public function getApp(appName:String):App
		{
			return appList[appName] as App;
		}
		
	}
	
}