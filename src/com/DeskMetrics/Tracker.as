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
		
		public static var debug:Boolean;
		
		public static function track(app:Object):void
		{
			if (tracker == null)
				tracker = new Tracker();
			
			if(service == null)
				service = new Service();
				
			var description:XML = describeType(app);
			var list:XMLList = description.child("accessor");		
			var t:String;
			
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				try
				{
					var btn:Button = app[s] as Button;
					t = btn.label;
					tracker.trackButton(btn);
				}catch(e){}
			}
		}
		
		private function trackButton(b:Button):void
		{
			b.addEventListener(MouseEvent.CLICK,
			function():void{ 
				if (Tracker.debug)
					Alert.show("I'm being tracked by DeskMetrics Tracker!"); 
			});
		} 
	}
}