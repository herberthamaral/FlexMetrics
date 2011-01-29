package com.DeskMetrics
{
	import flash.events.*;
	import flash.utils.describeType;
	
	import mx.controls.Button;
	import mx.core.Application;

	public class Tracker
	{
		static var tracker:Tracker;
		static var service:Service;
		static var timeline:EventTimeline;
		
		// hash object which has button objects as keys and applications as
		// values
		static var appsByButtons:Object;  
		
		public static var debug:Boolean;
		
		public static function track(app:Object):void
		{
			if (tracker == null)
				tracker = new Tracker();
			
			if(service == null)
				service = new Service();
			
			if (timeline == null)
				timeline = new EventTimeline();
			
			if (appsByButtons == null)
				appsByButtons = new Object();
			
			timeline.addApp(app as Application);
			
			var description:XML = describeType(app);
			var list:XMLList = description.child("accessor");		
			var t:String;
			var application:Application = app as Application;
			
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				
				try
				{
					var btn:Button = app[s] as Button;
					t = btn.label;
					tracker.trackButton(btn,application);
				}
				catch(e:TypeError){}
				catch(e:ReferenceError){}
			}
		}
		
		private function trackButton(b:Button,application:Application):void
		{
			var app:App = Tracker.timeline.getApp(application.name);
			appsByButtons[b] = app;
			app.addButton(b);
		} 
	}
}