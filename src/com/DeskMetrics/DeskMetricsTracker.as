package com.DeskMetrics
{
	import flash.events.*;
	import flash.system.Capabilities;
	import flash.utils.describeType;
	
	import mx.controls.Button;
	import mx.core.Application;

	public class DeskMetricsTracker
	{
		static var service:Service;
		static var timeline:EventTimeline;
		
		// hash object which has button objects as keys and applications as
		// values
		static var appsByButtons:Object;  
		
		public static var debug:Boolean;
		public static var synchronous:Boolean;
		
		private static function init()
		{
			if(service == null)
				service = new Service();
			
			if (timeline == null)
				timeline = new EventTimeline();
			
			if (appsByButtons == null)
				appsByButtons = new Object();
		}
		
		
		/**
		 * DeskMetrics library default methods
		 */
	   
	   	static var appID;
	   	static var appVersion;
	   	
		public static function Start(appid:String,version:String,realtime:Boolean):void
		{
			init();
				
			synchronous = realtime;
			appID = appid;
			appVersion = version;
			service.startApp(appid,version);
		}
		
		public static function TrackEvent(category:String,name:String):void
		{
			TrackEventValue(category,name);
		}
		
		public static function TrackEventValue(category:String,name:String,value:String=""):void
		{
			var e:EventVO = EventFactory(category,name);
			
			e.type = Events.DeskMetricsEvent;
			if (value!="" && value != null)
			{
				e.type = Events.DeskMetricsEventValue;
				e.value = value;
			}
			
			DispatchEvent(e);
		}
		
		public static function TrackEventStart (category:String,name:String):void
		{
			var e:EventVO = EventFactory(category,name);
			
			e.type = Events.DeskMetricsEventTimedStart;
			
			DispatchEvent(e);
		}
		
		public static function TrackEventStop (category:String,name:String):void
		{
			var e:EventVO = EventFactory(category,name);
			
			e.type = Events.DeskMetricsEventTimedStop;
			
			DispatchEvent(e);
		}
		
		public static function TrackEventCancel (category:String,name:String):void
		{
			var e:EventVO = EventFactory(category,name);
			
			e.type = Events.DeskMetricsEventCancel;
			
			DispatchEvent(e);
		}
		
		public static function TrackEventPeriod(category:String,name:String,time:int):void
		{
			var e:EventVO = EventFactory(category,name);
			
			e.type = Events.DeskMetricsEventPeriod;
			e.period = time;
			
			DispatchEvent(e);
		}
		
		public static function TrackLog(message:String):void
		{
			var e:EventVO = EventFactory("log","log");
			
			e.type = Events.DeskMetricsLog;
			e.message = message;
			DispatchEvent(e);
		}
		
		public static function TrackCustomData(name:String,value:String):void
		{
			var e:EventVO = EventFactory("event","value");
			
			e.type = Events.DeskMetricsCustomData;
			e.objName = name;
			e.value = value;
			DispatchEvent(e);
		}
		
		public static function TrackCustomDataR(name:String, value:String):void
		{
			var e:EventVO = EventFactory("event","value");
			
			e.type = Events.DeskMetricsCustomDataR;
			e.objName = name;
			e.value = value;
			DispatchEvent(e);
		}
		
		public static function TrackException(ex:Error):void
		{
			var e:EventVO = EventFactory("event","value");
			
			var targetsite:String =ex.getStackTrace().split("\n")[1]; 
			
			e.type = Events.DeskMetricsException;
			e.message = ex.message;
			e.stack = ex.getStackTrace().replace("\n","  ").replace("\t","  ");
			
			while (e.stack.indexOf("\\")>=0)
				e.stack = e.stack.replace("\\","/");
			
			while (targetsite.indexOf("\\")>=0)
				targetsite = targetsite.replace("\\","/");
			
			targetsite = targetsite.replace("\t","  ");
			e.targetsite = targetsite;
			
			e.objName = ex.name;
			DispatchEvent(e);
		}
		
		/**
		 * Helper methods
		 */ 
		
		private static function DispatchEvent(e:EventVO):void
		{
			if (synchronous || e.type == Events.DeskMetricsCustomDataR)
			{
				service.sendEventData(e,appID);
			}
			else
			{
				timeline.addEvent(e);
			}
		}
		
		private static function EventFactory(category:String,name:String):EventVO
		{
			var e:EventVO = new EventVO();
			e.timestamp = Util.getTimeStamp();
			e.category = category;
			e.objName = name;
			return e;
		}
		
		public static function Stop():void
		{
			service.finalizeApp(appID);
		}
	}
}