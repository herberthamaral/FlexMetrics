package com.DeskMetrics
{
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	internal class Service
	{
		private static var langs:Object = {"cs":"1029", "da":"1030", "nl":"1043","en":"1033","fi":"1035","fr":"1036","de":"1031","hu":"1038","it":"1040","ja":"1041","ko":"1042","no":"1044","xu":"0","pl":"1045","pt":"1046","ru":"1049","zh-CN":"2052","es":"1034","sv":"1053","zh-TW":"1028","tr":"1055"};;
		
		private var hash:String;
		private var flow:int = 1;
		private var startAppJson:String;
		
		public function startApp(appID:String,appVersion:String):void
		{
			var d:Date = new Date();
			var ts:uint = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			hash = MD5.hash(d.getTime().toString());
			
			var json:String = '{' + 
						'"tp":"startApp",' + 
						'"aver":"'+appVersion+'",' + 
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

			startAppJson = json;
		}
		
		function sendEventData(e:EventVO,appID:String):void
		{
			sendJson(getJsonFromEvent(e),appID);
		}
		
		private function getJsonFromEvent(event:EventVO):String
		{
			var d: Date = new Date();
			
			var json:String = 
					'{"tp":"'+event.type+'",' + 
					'"ss":"'+this.hash.toUpperCase()+'",' + 
					'"fl":'+flow.toString()+',' + 
					'"ts":'+event.timestamp+',';
			
			if (event.type != Events.DeskMetricsLog && event.type != Events.DeskMetricsCustomData && event.type != Events.DeskMetricsCustomDataR && event.type != Events.DeskMetricsException && event.type != Events.DeskMetricsLog)
			{
				json += '"ca":"'+event.category+'",' + 
						'"nm":"'+event.objName+'",'; 
			}
			else if (event.type == Events.DeskMetricsLog)
			{
				json += '"ms":"'+event.message+'",';
			}
			else if (event.type == Events.DeskMetricsCustomData || event.type == Events.DeskMetricsCustomDataR)
			{
				json += '"nm":"'+event.objName+'",' + 
						'"vl":"'+event.value+'",';
				
				if (event.type == Events.DeskMetricsCustomDataR)
				{
					json += '"aver":"'+DeskMetricsTracker.appID+'",' + 
							'"ID":"'+this.getUserID()+'",';
				}
			}
			else if (event.type == Events.DeskMetricsException)
			{
				json += '"msg":"'+event.message+'",' + 
						'"stk":"'+event.stack+'",' + 
						'"src":"'+event.objName+'",' + 
						'"tgs":"'+event.targetsite+'",';
			}
			else if (event.type == Events.DeskMetricsEventPeriod)
			{
				json += '"ec":'+event.completed?"1":"0";
			}
			
			flow++;
			
			if (event.value != "" && event.value != null)
				json += '"vl":"'+event.value+'",';
			
			if (event.period > 0)
				json += '"tm":'+event.period+',';
			
			json = json.substr(0,json.length-1); //removes last ,
			json += '}';
			return json;
		}
		
		public function finalizeApp(appID:String,finalize:Function=null):void
		{
			var d: Date = new Date()
			var ts:uint = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			var json:String  = '{"tp":"stApp",' + 
					'"ts":'+ts.toString()+',' + 
					'"ss":"'+hash.toUpperCase()+'"}';
			

			var i:int = 0;
			var list:ArrayCollection = DeskMetricsTracker.timeline.getEventList();
			json = "["+json+",";
			
			for (i = 0; i< list.length ; i++)
			{
				json += getJsonFromEvent(list[i] as EventVO)+",";
			}
			json += startAppJson;
			json += "]";


			sendJson(json,appID,finalize);
		}
		
		private function sendJson(json:String,appID:String,finalize:Function=null):void
		{
			var http:HTTPService = new HTTPService();
			http.contentType = "text/javascript";
			http.method = "POST";
			http.resultFormat ="text";
			http.request = json;
			http.url = "http://"+appID.toLowerCase()+".api.deskmetrics.com/sendData";
			http.addEventListener(ResultEvent.RESULT,
				function(e:ResultEvent):void
				{  
					if (DeskMetricsTracker.debug)
						if (http.lastResult.toString().lastIndexOf('{"status_code": 1}')<0)
							Alert.show("Oops, something went wrong with DeskMetrics Analytics module. Perhaps some misconfiguration?");
					if (finalize!=null)
						finalize();
				});
				
			http.addEventListener(FaultEvent.FAULT,
				function(e:FaultEvent):void
				{
					if (DeskMetricsTracker.debug)
						Alert.show("Oops, something went wrong when I tried to talk with DeskMetrics(c) server. Is your internet connection down?");
					
					if (finalize!=null)
						finalize();
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
		
		private function getSystemInfo():Object
		{
			var obj:Object = new Object();
			obj["osv"] = Capabilities.os;
			obj["oslng"] = langs[Capabilities.language];
			obj["osscn"] = Capabilities.screenResolutionX+'x'+Capabilities.screenResolutionY;
			
			// it can get more information if it is running under Adobe air
			if (Capabilities.playerType == "Desktop")
			{
				trace(File.applicationStorageDirectory.spaceAvailable);
				trace(flash.system.System.totalMemory);
				
			}
			return obj;
		}
		
	}
}