package com.DeskMetrics
{
	import flash.utils.describeType;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import flash.events.*;

	public class Tracker
	{
		public function Tracker()
		{
		}
		
		private static var tracker:Tracker;
		
		public static function track(app:Object)
		{
			if (tracker == null)
				tracker = new Tracker();
				
			var description:XML = describeType(app);
			var cont:int = 0;
			var list:XMLList = description.child("accessor");		
			var t:String;
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				try
				{
					var btn:Button = app[s] as Button;
					t = btn.id;
					tracker.trackButton(btn);
					cont++;
				}catch(e){}
			}
			
			
			Alert.show(cont.toString()+" botões foram encontrados");
		}
		
		private function trackButton(b:Button):void
		{
			b.addEventListener(MouseEvent.CLICK,function():void{ Alert.show("I'm being tracked by DeskMetrics Tracker!"); });
		} 
	}
}