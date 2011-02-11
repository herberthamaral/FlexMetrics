package com.DeskMetrics
{
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.events.StateChangeEvent;
	import mx.modules.Module;
	import mx.modules.ModuleLoader;
	
	internal class App
	{
		private var buttons:Object;
		private var timestamp:uint;
		private var application:Application;
		private var moduleLoaders:Object;
		private var modules:Object;
		var id:String;
		var version:String;
		
		public function App()
		{
			var now:Date = new Date();
			timestamp = Math.round(((now.time - now.timezoneOffset)/1000)) as uint;
			buttons = new Object();
			moduleLoaders = new Object();
			modules = new Object();
		}
		
		public function setApplication(app:Application):void
		{
			if (application ==null)
				application = app;
			
			app.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE,applicationStateChangeHandler);
			searchForModules();
		}
		
		private function searchForModules():void
		{
			var description:XML = describeType(this.application);
			var list:XMLList = description.child("accessor");
			var t:String;
			
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				try
				{
					var moduleLoader:ModuleLoader = this.application[s] as ModuleLoader;
					
					//make sure this is a moduleloader ;)
					t = moduleLoader.url;
					addModuleLoader(moduleLoader);
				}
				catch(e:TypeError){}
				catch(e:ReferenceError){}
			}	
		}
		
		public function getApplication():Application
		{
			return application;
		}
		
		public function addButton(b:Button):void
		{
			if (buttons[b.id] == null)
			{
				b.addEventListener(MouseEvent.CLICK,buttonClickEventHandler);
				buttons[b.id] = b;
			}
		}
		
		public function addModuleLoader(m:ModuleLoader):void
		{
			if(moduleLoaders[m.id] == null)
			{
				moduleLoaders[m.id] = m;
				m.addEventListener(ModuleEvent.READY,moduleLoadEventHandler);
				m.addEventListener(ModuleEvent.UNLOAD,moduleUnloadEventHandler);
			}
		}
		
		private function moduleLoadEventHandler(e:ModuleEvent):void
		{
			var module:Module = (e.target as ModuleLoader).child as Module;
			
			
			if (modules[module.id] == null)
			{
				//Tracker.timeline.addModuleLoaded(module.name,this);
				modules[module.id] = module;
				module.addEventListener(FlexEvent.INITIALIZE,moduleInitEventHandler);
			}
			
		}
		
		private function moduleInitEventHandler(e:FlexEvent):void
		{
			var module:Module = e.target as Module;
			var name:String = module.name;
			
			var description:XML = describeType(module);
			var list:XMLList = description.child("accessor");
			var t:String;
			var app:Application = this.application;
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				try
				{
					var btn:Button = module[s] as Button;
					//make sure this is a button ;)
					t = btn.label;
					Tracker.trackButton(btn,application);
				}
				catch(e:TypeError){}
				catch(e:ReferenceError){}
			}
			
			if(Tracker.debug)
				Alert.show("Hi, I'm a module named "+module.name+".");
		}
		
		public function moduleUnloadEventHandler(e:ModuleEvent):void
		{
			
		}
		
		private function buttonClickEventHandler(e:MouseEvent):void
		{
			var app:App = Tracker.appsByButtons[e.target] as App;
			Tracker.timeline.addButtonClick(e.target["id"] as String,app); 
				if (Tracker.debug)
					Alert.show("I'm '"+app.application.name+"\\"+(e.target["id"] as String)+"' and I'm being tracked by DeskMetrics Tracker!");
		}
		
		private function applicationStateChangeHandler(e:StateChangeEvent):void
		{
			//look for another buttons that may come in and report an state change event
			var description:XML = describeType(this.application);
			var list:XMLList = description.child("accessor");
			var t:String;
			var app:Application = e.target as Application;
			for (var i:int;i<list.length();i++)
			{
				var s:String = list[i].@name;
				try
				{
					var btn:Button = app[s] as Button;
					//make sure this is a button ;)
					t = btn.label;
					Tracker.trackButton(btn,application);
				}
				catch(e:TypeError){}
				catch(e:ReferenceError){}
			} 
		}
	}
}