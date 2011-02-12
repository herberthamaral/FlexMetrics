package com.DeskMetrics
{
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	internal class Service
	{
		private static var langs:Object = {"cs":"1029", "da":"1030", "nl":"1043","en":"1033","fi":"1035","fr":"1036","de":"1031","hu":"1038","it":"1040","ja":"1041","ko":"1042","no":"1044","xu":"0","pl":"1045","pt":"1046","ru":"1049","zh-CN":"2052","es":"1034","sv":"1053","zh-TW":"1028","tr":"1055"};;
		
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
						'"aver":"'+app.version+'",' + 
						'"ID":"'+this.getUserID()+'",' + 
						'"ss":"'+hash.toUpperCase()+'",' + 
						'"ts":'+ts.toString()+',' + 
						'"osv":"'+Capabilities.os+'",' + 
						'"ossp":null,' + 
						'"osar":null,' + 
						'"osjv":null,' + 
						'"osnet":null,' + 
						'"osnsp":null,' + 
						'"oslng":"'+langs[Capabilities.language]+'",' + 
						'"osscn":"'+Capabilities.screenResolutionX+'x'+Capabilities.screenResolutionY+'",' + 
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

			sendJson(json,app);
		}
		
		function sendEventData(e:EventVO,app:App):void
		{
			sendJson(getJsonFromEvent(e),app);
		}
		
		private function getJsonFromEvent(event:EventVO):String
		{
			return '{"tp":"ev",' + 
					'"ca":"'+event.type+'",' + 
					'"nm":"'+event.objName+'",' + 
					'"ss":"'+this.hash+'",' + 
					'"fl":1}';
		}
		
		public function finalizeApp(app:App):void
		{
			var d: Date = new Date()
			var ts:uint = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			var json:String  = '{"tp":"stApp",' + 
					'"ts":"'+ts.toString()+'",' + 
					'"ss":"'+hash.toUpperCase()+'"}';
			
			if (!Tracker.synchronous)
			{
				var i:int = 0;
				var list:ArrayCollection = Tracker.timeline.getEventList();
				json = "["+json+",";
				
				for (i = 0; i< list.length ; i++)
				{
					json += getJsonFromEvent(list[i] as EventVO)+",";
				}
				json = json.substr(0,json.length-1);
				json += "]";
				Alert.show(json);
			}

			sendJson(json,app);
		}
		
		private function sendJson(json:String,app:App):void
		{
			var http:HTTPService = new HTTPService();
			http.contentType = "text/javascript";
			http.method = "POST";
			http.resultFormat ="text";
			http.request = json;
			http.url = "http://"+app.id.toLowerCase()+".api.deskmetrics.com/sendData";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{  
					if (Tracker.debug)
						if (http.lastResult.toString().lastIndexOf('{"status_code": 1}')<0)
							Alert.show("Oops, something went wrong with Deskmetrics Analytics module. Perhaps some misconfiguration?");
				});
				
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					if (Tracker.debug)
						Alert.show("Oops, something went wrong when I tried to talk with DeskMetrics(c) server. Is your internet connection down?");
				});
				
			http.send();
		}
		
		private function getUserID():String
		{
			var obj:SharedObject = SharedObject.getLocal("ID");
			if (obj.size == 0)
				obj.data.ID = MD5.hash((new Date().getTime()).toString());
			
			return obj.data.ID;
		}
		
		public function getSystemInfo():void
		{
			
		}
		
	}
}