package com.DeskMetrics
{
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	internal class Service
	{
		private var hash:String;
		public function Service()
		{
			
		}
		
		public function startApp(app:App):void
		{
			var d:Date = new Date();
			var ts:uint = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			hash = MD5.hash(d.getTime().toString());
			
			var json:String = '{' + 
						'"tp":"startApp",' + 
						'"aver":"0.1",' + 
						'"ID":"827CCB0EEA8A706C4C34A16891F84E7B",' + 
						'"ss":"'+hash.toUpperCase()+'",' + 
						'"ts":'+ts.toString()+',' + 
						'"osv":"Windows XP",' + 
						'"ossp":null,' + 
						'"osar":null,' + 
						'"osjv":null,' + 
						'"osnet":null,' + 
						'"osnsp":null,' + 
						'"oslng":1046,' + 
						'"osscn":"1024x768",' + 
						'"cnm":null,' + 
						'"cbr":null,' + 
						'"cfr":null,' + 
						'"ccr":null,' + 
						'"car":null,' + 
						'"mtt":null,' + 
						'"mfr":null,' + 
						'"dtt":null,' + 
						'"dfr":null' + 
					'}';

			sendJson(json);
		}
		
		public function finalizeApp(app:App):void
		{
			
		}
		
		private function sendJson(json:String):void
		{
			var http:HTTPService = new HTTPService();
			http.contentType = "text/javascript";
			http.method = "POST";
			http.resultFormat ="text";
			http.request = json;
			http.url = "http://4d47c012d9340b116a000000.api.deskmetrics.com/sendData";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{  
					if (Tracker.debug)
						if (http.lastResult.toString().lastIndexOf('{"status_code": 1}')>=0)
							Alert.show("Congratulations, you're being tracked by DeskMetrics(c)");
						else
							Alert.show("Oops, something went wrong. Perhaps some misconfiguration?");
				});
				
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					if (Tracker.debug)
						Alert.show("Oops, something went wrong when I tried to talk with DeskMetrics(c) server. Is your internet connection down?");
				});
				
			http.send();
		}
		
		public function getSystemInfo():void
		{
			
		}
		
		
	}
}