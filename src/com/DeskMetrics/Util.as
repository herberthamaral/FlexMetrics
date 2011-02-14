package com.DeskMetrics
{
	internal final class Util
	{
		public static function getTimeStamp():uint
		{
			var d: Date = new Date()
			var ts:uint = Math.round((d.getTime() - d.getTimezoneOffset())/1000) as uint;
			return ts;
		}

	}
}