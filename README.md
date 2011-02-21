FlexMetrics -- DeskMetrics library for Adobe Flex
=================================================

This is the very first and unstable version of FlexMetrics, an Google Analytics-like library for Adobe Flex and powered by [ DeskMetrics ](http://deskmetrics.com/).


Example of use (automatic version)
------------------------------------

By "automatic version", we mean a mode which all "interesting" objects are tracked automatically. This feature is interessant when you want to test DeskMetrics without changing most part of your application.

This is the most basic example of FlexMetrics in automatic mode:

    <?xml version="1.0" encoding="utf-8"?>
    <!-- need to ensure that the app has a name -->
    <mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" name="DeskMetricsApp" layout="absolute" initialize="init()">
        
        <mx:Script>
            <![CDATA[
                import com.DeskMetrics.Tracker;
                
                private function init():void
                {
                    Tracker.track(this,"app_id","app_version");
                }
            ]]>
        </mx:Script>

    </mx:Application>

Where app_id is your application id (you can get it on DeskMetrics dashboard) and app_version is your application version (like "0.1" or "1.0b").

For now, we automatically track any kind of button click, state change and module load. And it is all recursive: if you load an module, we automatically detects all states and buttons inside it and attach an event listener to them.

Since Flex has no equivalent of JavaScript' onunload, we need to do a small hack in order to track the stApp event. So, add this to your html-template:

    <script type="text/javascript">

        function getFlexApp(appName)
        {
          if (navigator.appName.indexOf ("Microsoft") !=-1)
          {
            return window[appName];
          } 
          else 
          {
            return document[appName];
          }
        }

        function finishApp()
        {
            getFlexApp('your_app_name_here').finish();
            alert('Sending data to DeskMetrics');
        }

    </script>


And add finishApp to your onunload event:

    <body scroll="no" onunload="finishApp()">


Default methods
---------------

FlexMetrics keeps the API compatibility with other DeskMetrics components. Next, we present all methods used by track you application :

    com.DeskMetrics.DeskMetricsTracker.Start(appid:String,version:String,realtime:Boolean)

Must be called when your application starts.

Example: `com.DeskMetrics.DeskMetricsTracker.Start("4c47c012d9340b116a000000","1.5b",false)`

    com.DeskMetrics.DeskMetricsTracker.TrackEvent(category:String,name:String)

Events are actionable things that occur, and that you use to organize your data. The events are updated immediately when a user interacts with your software. They are just strings and they can be called anything you want.

Events can be user actions, such as clicking a mouse button or pressing a key, or software occurrences.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackEvent("LoginScreen","LoginButton")`


    com.DeskMetrics.DeskMetricsTracker.TrackEventValue(category:String,name:String,value:String)

Method used to track any kind of event and attach a custom value.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackEventValue("LoginScreen","LoginButton","Login failed")`

    com.DeskMetrics.DeskMetricsTracker.TrackEventStart (category:String,name:String)

Method used to track the start of timed events.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackEventStart("Tasks","SynchronizeWithServer")`

    com.DeskMetrics.DeskMetricsTracker.TrackEventStop (category:String,name:String)

Method used to track the end of timed events. `category` and `name` parameters must have the same value passed to `TrackEventStart` method.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackEventStop("Tasks","SynchronizeWithServer")`

    com.DeskMetrics.DeskMetricsTracker.TrackEventCancel (category:String,name:String)

Method used to track the cancel of timed events. `category` and `name` parameters must have the same value passed to `TrackEventStart` method.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackEventCancel("Tasks","SynchronizeWithServer")`

    com.DeskMetrics.DeskMetricsTracker.TrackLog(message:String)

Utility to track logs.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackLog("this is a log message")`

    com.DeskMetrics.DeskMetricsTracker.TrackCustomData(name:String,value:String)

Sometimes you may want to obtain some specific information from your users or software. You have two ways to do that, by using our log function or the function to send custom data.

The function `TrackCustomData` is useful to send any type of data and generate information and charts. For example, you may want to get some information about your users, like a phone number. You can used the function to get it and see how many of it you are getting each day.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackCustomData("Phone","+55 12 1222-9999")`

    com.DeskMetrics.DeskMetricsTracker.TrackCustomDataR(name:String, value:String)

You may want to ask your user about his email and need that this information is sent in real-time (with server response). You can use the function TrackCustomDataR to do this job. It will sent his email to our service and will return a status code to check if your data has been sent successfully or not.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackCustomDataR("email","my@email.com")`

    com.DeskMetrics.DeskMetricsTracker.TrackException(ex:Error)

Exceptions are used to report errors when code is executing. An exception is thrown when a run-time error is generated for various reasons, i.e. mismatched data type error occurs, out-bounds memory problems and so on.

Example: `com.DeskMetrics.DeskMetricsTracker.TrackException(new Error('Oops, something went wrong'))`


Debug version
-------------

To activate debug, just add `Tracker.debug = true;`. Your app will alert some messages when an important event or error happens.

Synchronous option
------------------

The synchronous option can be activated by adding `Tracker.synchronous = true;` to your code and it allows you to send event data to DeskMetrics in real-time, without waiting until the end of execution to send all of them.

Future implementations
------------------------


Please, check our issues under `features` tag to see the FlexMetrics future implementations.

License
-------

Copyright (c) 2011, DeskMetrics
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the DeskMetrics nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
