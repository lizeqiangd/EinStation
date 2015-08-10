package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.net.PHPAPI;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 全局的配置信息.
	 * @author Lizeqiangd
	 */
	public class ConfigManager
	{
		/**
		 * 切换允许使用本地设置.
		 */
		public static var useCacaheConfig:Boolean = false;
		
		private static var config_data:Object = {}
		private static var complete_func:Function
		private static var timeout_timer:Timer
		private static var onInitComplete:Boolean =false
		
		/**
		 * 可在本地类里面实现方法,当然也可以通过phpapi等方法访问server.
		 * @param	data
		 * @param	onCompleteFunc
		 */
		public static function setConfigByData(data:Object, onCompleteFunc:Function):void
		{
			complete_func = onCompleteFunc;
			config_data = data;
			saveConfigToLocal()
			complete_func();
		}
		
		/**
		 * 通过json文件的url访问并获取api.记得加载crossdomain.
		 * @param	json_url
		 * @param	onCompleteFunc
		 */
		public static function setConfigByJSON(json_url:String, onCompleteFunc:Function):void
		{
			timeout_timer = new Timer(5000, 1)
			timeout_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout)
			var php:PHPAPI = new PHPAPI()
			php.setGatewayUrl(json_url);
			php.call('get_einstation_config', onLoadJsonComplete)
			function onLoadJsonComplete(e:Object):void
			{
			if (!onInitComplete) {
				saveConfigToLocal();
				onCompleteFunc();
			}
			}
			function onTimeout(e:Object):void
			{
				if (useCacaheConfig)
				{
					loadConfigFromLocal();
					onInitComplete=true
					onCompleteFunc()
				}
			
			}
			//saveConfigToLocal()
			//complete_func = onCompleteFunc;
		}
		
		/**
		 * 把获取到设置保存到本地.
		 */
		private static function saveConfigToLocal():void
		{
		
		}
		
		/**
		 * 读取本地设置.(需要实现设置,这样5秒后没读取到则使用本地数据)
		 */
		private static function loadConfigFromLocal():void
		{
		
		}
		
		/**
		 * 获取设定的内容.如果没有则返回空.
		 * @param	key
		 * @return
		 */
		public static function getConfig(key:String):*
		{
			try
			{
				return config_data[key]
			}
			catch (e:*)
			{
				
			}
			return '';
		}
		
		/**
		 * 用于记录一些有趣的事情.一般是用户自己设置的功能.
		 * @param	key
		 * @param	data
		 */
		public static function setConfig(key:String, data:*):void
		{
			try
			{
				config_data[key] = data
			}
			catch (e:*)
			{
			}
		}
	}

}