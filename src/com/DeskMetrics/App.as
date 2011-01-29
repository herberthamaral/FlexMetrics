package com.DeskMetrics
{
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	
	internal class App
	{
		private var buttons:Object;
		private var timestamp:uint;
		public var application:Application;
		
		public function App()
		{
			var now:Date = new Date();
			timestamp = Math.round(((now.time - now.timezoneOffset)/1000)) as uint;
			buttons = new Object();
		}
		
		public function addButton(b:Button):void
		{
			b.addEventListener(MouseEvent.CLICK,buttonClickEventHandler);
		}
		
		private function buttonClickEventHandler(e:MouseEvent):void
		{
			var app:App = Tracker.appsByButtons[e.target] as App;
			Tracker.timeline.addButtonClick(e.target["id"] as String,app); //app == null
				if (Tracker.debug)
					Alert.show("I'm '"+app.application.name+"\\"+(e.target["id"] as String)+"' and I'm being tracked by DeskMetrics Tracker!");
		}
	}
}