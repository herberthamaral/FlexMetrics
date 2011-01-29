package com.DeskMetrics
{
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.events.ChildExistenceChangedEvent;
	
	internal class App
	{
		private var buttons:Object;
		private var timestamp:uint;
		private var application:Application;
		
		public function setApplication(app:Application):void
		{
			if (application ==null)
				application = app;
			
			app.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,applicationStateChangeHandler);		
		}
		
		public function getApplication():Application
		{
			return application;
		}
		
		public function App()
		{
			var now:Date = new Date();
			timestamp = Math.round(((now.time - now.timezoneOffset)/1000)) as uint;
			buttons = new Object();
		}
		
		public function addButton(b:Button):void
		{
			if (buttons[b.id] == null)
			{
				b.addEventListener(MouseEvent.CLICK,buttonClickEventHandler);
				buttons[b.id] = b;
			}
		}
		
		private function buttonClickEventHandler(e:MouseEvent):void
		{
			var app:App = Tracker.appsByButtons[e.target] as App;
			Tracker.timeline.addButtonClick(e.target["id"] as String,app); //app == null
				if (Tracker.debug)
					Alert.show("I'm '"+app.application.name+"\\"+(e.target["id"] as String)+"' and I'm being tracked by DeskMetrics Tracker!");
		}
		
		private function applicationStateChangeHandler(e:ChildExistenceChangedEvent):void
		{
			//look for another buttons that may come in and report an state change event
			var description:XML = describeType(this.application);
			var list:XMLList = description.child("accessor");
			var t:String;
			var app:Application = e.target as Application;
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				try
				{
					var btn:Button = app[s] as Button;
					//make sure this is a button ;)
					t = btn.label;
					Tracker.trackButton(btn,application);
				}
				catch(e:TypeError){}
				catch(e:ReferenceError){}
			} 
		}
	}
}