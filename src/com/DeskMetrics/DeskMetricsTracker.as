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
		
		public static function track(app:Object,appID:String,appVersion:String):void
		{
			init();
			
			timeline.addApp(app as Application,appID,appVersion);
			
			var description:XML = describeType(app);
			var list:XMLList = description.child("accessor");		
			var t:String;
			var application:Application = app as Application;
			
			var a:Object  = Capabilities; 
			
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				
				try
				{
					var btn:Button = app[s] as Button;
					
					//make sure this is a button ;)
					t = btn.label;
					DeskMetricsTracker.trackButton(btn,application);
				}
				catch(e:TypeError){}
				catch(e:ReferenceError){}
			}
		}
		
		public static function trackButton(b:Button,application:Application):void
		{
			var app:App = DeskMetricsTracker.timeline.getApp(application.name);
			appsByButtons[b] = app;
			app.addButton(b);
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
		
		/**
		 * Helper methods
		 */ 
		
		private static function DispatchEvent(e:EventVO):void
		{
			if (synchronous)
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