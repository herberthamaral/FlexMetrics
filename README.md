FlexMetrics -- Deskmetrics library for Adobe Flex
=================================================

This is the very first and unstable version of FlexMetrics, an Google Analytics-like library for Adobe Flex and powered by [ Deskmetrics ](http://deskmetrics.com/).


Example of use
--------------

This is the most basic example:

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

Where app_id is your application id (you can get it on Deskmetrics dashboard) and app_version is your application version (like "0.1" or "1.0b").

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

Debug version
-------------

To activate debug, just add `Tracker.debug = true;`. Your app will alert some messages when an important event or error happens.

Synchronous option
------------------

The synchronous option can be activated by adding `Tracker.synchronous = true;` to your code and it allows you to send event data to Deskmetrics in real-time, without waiting until the end of execution to send all of them.

License
-------

Copyright (c) 2011, DeskMetrics
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the Deskmetrics nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
