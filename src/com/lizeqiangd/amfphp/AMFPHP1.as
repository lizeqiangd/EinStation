package com.lizeqiangd.amfphp
{
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class AMFPHP1
	{
		private static var _eventDispatch:EventDispatcher
		
		private var serviceLoader:Dictionary = new Dictionary();
		private var loaderMap:Dictionary = new Dictionary();
		public function AMFPHP1()
		{
		
		}
		public function callWeiboAPI(uri:String, params:Object = null, method:String = "GET", resultEventType:String = "callWeiboApiResult", errorEventType:String = "callWeiboApiError"):void
		{
			addProcessor(uri, processGeneralApi, resultEventType, errorEventType);
			if (params == null) var params:Object = { };
			var baKey:String = "";
			for(var key:* in params)
			{
				if(params[key] is ByteArray)
				{
					baKey = key;
					break;
				}
			}
			if(baKey != "")
			{
				var file:ByteArray = params[key];
				delete(params[key]);
			}
			
			var req:URLRequest;
			if(_isSecureDomain){
				req = getMicroBlogRequest(API.API_BASE_URL + uri + ".json", params, method);
			}else{
				req = getMicroBlogRequest(_proxyURI + "?uri=" + uri + "&file=" + baKey + "&method=" + method, params, URLRequestMethod.POST);
			}
			if(baKey != "")
			{
				var boundary:String=makeBoundary();
				req.contentType = MULTIPART_FORMDATA + boundary;		
				req.data = makeMultipartPostData(boundary, baKey, "demo.jpg", file, req.data);
			}		
			executeRequest(uri, req);
		}
		protected function addProcessor(name:String, dataProcess:Function, resultEventType:String, errorEventType:String):void
		{
			if (null == serviceLoader[name])
			{
				var loader:URLLoader=new URLLoader();
				loader.addEventListener(Event.COMPLETE, loader_onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_onSecurityError);
				serviceLoader[name]=loader;
				loaderMap[loader]={dataFunc: dataProcess, resultEvent: resultEventType, errorEvent: errorEventType};
			}
		}private function loader_onComplete(event:Event):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var dataStr:String = loader.data as String;
			
			if ( dataStr.length  <= 0 )
			{
				var ioError:MicroBlogErrorEvent = new MicroBlogErrorEvent(MicroBlogErrorEvent.NET_WORK_ERROR);
				ioError.message = "The network error";
				dispatchEvent(ioError);
				return;
			}
			
			_testData = dataStr;
			
//			trace("========================================" + processor.resultEvent);
//			trace(_testData);
//			trace("========================================");
			
			var decoder:JSONDecoder = new JSONDecoder( dataStr );//为了避开Fp11和之前的冲突
			var result:Object = decoder.getValue();
			
			if (result["error"]  != null)
			{
				var error:MicroBlogErrorEvent = new MicroBlogErrorEvent(processor.errorEvent);
				error.message = "Error " + result.error_code + " : " + result.error + ",description:" + result.error_description;
				error.code = result.error_code;
				dispatchEvent(error);
			}else{
				var e:MicroBlogEvent = new MicroBlogEvent(processor.resultEvent);
				e.result = processor.dataFunc(result);
				e.nextCursor=Number(result.next_cursor);
				e.previousCursor=Number(result.previous_cursor);
				dispatchEvent(e);
			}
		}
		
		private function loader_onError(event:IOErrorEvent):void
		{
			var loader:URLLoader=event.target as URLLoader;
			var processor:Object=loaderMap[loader];
			var error:MicroBlogErrorEvent=new MicroBlogErrorEvent(processor.errorEvent);
			error.message=event.text;
			dispatchEvent(error);
		}
		
		private function loader_onSecurityError(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		
		
		
		
		
		
		public static function addEventListener(type:String, listener:Function):void
		{
			_eventDispatch.addEventListener(type, listener, false, 0, true);
		}
		
		public static function removeEventListener(type:String, listener:Function):void
		{
			_eventDispatch.removeEventListener(type, listener);
		}
	}

}