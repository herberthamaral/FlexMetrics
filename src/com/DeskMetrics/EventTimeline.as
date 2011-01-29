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
			app.application = application;
			appList[application.name] = app;
		}
		
		public function addButtonClick(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			var d: Date = new Date();
			
			ev.app = app;
			ev.timestamp = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			ev.type = Events.BUTTON_CLICK;
			eventList.addItem(ev);
		}
		
		public function getApp(appName:String):App
		{
			return appList[appName] as App;
		}
		
	}
	
}