package com.DeskMetrics
{
	import flash.events.*;
	import flash.utils.describeType;
	
	import mx.controls.Alert;
	import mx.controls.Button;

	public class Tracker
	{
		private static var tracker:Tracker;
		private static var service:Service;
		private static var timeline:EventTimeline;
		
		public static var debug:Boolean;
		
		public static function track(app:Object):void
		{
			if (tracker == null)
				tracker = new Tracker();
			
			if(service == null)
				service = new Service();
			
			if (timeline == null)
				timeline = new EventTimeline();
			
			timeline.addApp(app["name"] as String);
			
			var description:XML = describeType(app);
			var list:XMLList = description.child("accessor");		
			var t:String;
			
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				
				//try to coerce to a button
				try
				{
					var btn:Button = app[s] as Button;
					t = btn.label;
					tracker.trackButton(btn);
				}catch(e){}
			}
		}
		
		private function trackButton(b:Button,stageName:String="<default>",appName:String="<default>"):void
		{
			var app:App = Tracker.timeline.getApp(appName);
			
			//app.addButton(b.id);
			
			b.addEventListener(MouseEvent.CLICK,
			function():void{ 				
				timeline.addButtonClick(b.id,app); //app == null
				if (Tracker.debug)
					Alert.show("I'm being tracked by DeskMetrics Tracker!"); 
			});
		} 
	}
}