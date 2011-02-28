package com.DeskMetrics
{
	import flash.external.ExternalInterface;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.FlexEvent;
	
	internal class EventTimeline
	{
		private var appList:Object;
		
		private var eventList:ArrayCollection;
			
		public function EventTimeline()
		{
			appList = new Object();
			eventList = new ArrayCollection();
		}
		
		public function addEvent(event:EventVO):void
		{
			eventList.addItem(event);
		}
		
		public function getEventList():ArrayCollection
		{
			return eventList;
		}
		
	}
	
}