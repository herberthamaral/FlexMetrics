package com.DeskMetrics
{
	internal class App
	{
		public var name:String;
		private var buttons:Object;
		private var timestamp:uint;
		
		public function App()
		{
			var now:Date = new Date();
			timestamp = ((now.time - now.timezoneOffset)/1000) as uint;
			buttons = new Object();
			
		}
		
		public function addButton(name:String):void
		{
			
		}
	}
}