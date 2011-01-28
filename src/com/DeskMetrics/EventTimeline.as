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
			app.name = appName;
			appList[appName] = app;
		}
		
		//public function addButtonClick(
		
		public function getApp(appName:String):App
		{
			return appList[appName] as App;
		}
		
		
	}
	
	internal class App
	{
		public var name:string;
		private var buttons:Object;
		private var timestamp:uint;
		
		public function App()
		{
			var now:Date = new Date();
			timestamp = ((now.time - now.timezoneOffset)/1000) as uint;
			buttons = new Object();
			
		}
		
		public function addButton(name:String)
		{
			
		}
	}
	
	internal class Button
	{
		
	}
	
}