package com.lizeqiangd.zweisystem.net
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class PHPAPI
	{
		private static var instance:PHPAPI
		
		public static function get getInstance():PHPAPI
		{
			if (!instance)
				instance = new PHPAPI
			return instance
		}
		
		private var gateway_url:String = '';
		
		/**
		 * 设置php的api接口入口地址.不建议使用多接口..
		 * @param	e
		 */
		public function setGatewayUrl(e:String):void
		{
			gateway_url = e
		}
		
		/**
		 * 呼叫php的方法由callback定义回调函数.param
		 * 已经转换成为URLVariables
		 * @param	api
		 * @param	callback
		 * @param	params
		 */
		public function call(api:String, callback:Function, params:Object = null):void
		{
			if (!params)
			{
				params = {};
			}
			var urlr:URLRequest = new URLRequest
			var urll:URLLoader = new URLLoader
			urll.addEventListener(Event.COMPLETE, onLoadComplete)
			urll.addEventListener(IOErrorEvent.IO_ERROR, onError)
			urll.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError)
			urll.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus)
			function onStatus(e:HTTPStatusEvent):void
			{
				//trace(e)
			}
			function onError(e:*):void
			{
				trace('phpapi call failed:', api, var_dump(params))
				callback(false)
			}
			function onLoadComplete(e:Event):void
			{
				try
				{
					callback(JSON.parse(urll.data));
				}
				catch (e:*)
				{
					trace(urll.data)
				}
			}
			urlr.url = gateway_url;
			params['action'] = api;
			var urlv:URLVariables = new URLVariables;
			for (var i:Object in params)
			{
				urlv[i] = params[i];
			}
			urlr.method = URLRequestMethod.POST;
			urlr.data = urlv;
			urll.load(urlr)
		}
		
		/**
		 * debug用,用php明明风格吧.
		 * @param	e
		 */
		public static function var_dump(e:*):void
		{
			for (var i:Object in e)
			{
				trace(i + ":" + e[i]);
				for (var k:Object in e[i])
				{
					trace('   ' + k + ":" + e[i][k]);
					for (var j:Object in e[i][k])
					{
						trace('      ' + j + ":" + e[i][k][j]);
						for (var l:Object in e[i][k][j])
						{
							trace('         ' + l + ":" + e[i][k][j][l]);
						}
					}
				}
			}
		}
	}

}