package com.DeskMetrics
{
	import mx.collections.ArrayCollection;
	
	
	internal class EventTimeline
	{
		private var appList:Object;
		
		private var eventList:ArrayCollection;
			
		public function EventTimeline()
		{
			appList = new Object();
			eventList = new ArrayCollection();
		}
		
		public function addApp(appName:String):void
		{
			if (appList[appName] !=null)
				return;

			var app:App = new App();
			app.name = appName==""?"<default>":appName;
			appList[appName] = app;
		}
		
		public function addButtonClick(name:String,app:App):void
		{
			var ev:EventVO = new EventVO();
			var d: Date = new Date();
			
			ev.app = app;
			ev.timestamp = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint; //vindo como 0
			ev.type = Events.BUTTON_CLICK;
			eventList.addItem(ev);
		}
		
		public function getApp(appName:String):App
		{
			return appList[appName] as App;
		}
		
	}
	
}