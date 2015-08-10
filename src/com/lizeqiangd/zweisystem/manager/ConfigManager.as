package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.net.PHPAPI;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Timer;
	
	/**
	 * 全局的配置信息.
	 * @author Lizeqiangd
	 * 20150810 重做,如果想要加载json文件.请在外部处理好调用setConfigByObject
	 */
	public class ConfigManager
	{
		/**
		 * 切换允许使用本地设置.
		 */
		public static var useCacaheConfig:Boolean = false;
		private static var onInitComplete:Boolean = false;
		private static var timeout_timer:Timer;
		//private static var _callback:Function
		
		private static var config_data:Object = {};
		
		private static const _SharedObjectKey:String = "EinStation";
		private static const _configKey:String = 'ConfigManager';
		
		//private static const _configSystemKey:String = 'System';
		//private static const _configCustomKey:String = 'Custom';
		
		/**
		 * 可在本地类里面实现方法,当然也可以通过phpapi等方法访问server.
		 * @param	data
		 * @param	onCompleteFunc
		 */
		public static function setConfigByObject(data:Object, callback:Function):void
		{
			config_data = data;
			saveConfigToLocal()
			callback();
		}
		
		/**
		 * 通过json文件的url访问并获取api.记得加载crossdomain.
		 * @param	json_url
		 * @param	onCompleteFunc
		 */
		public static function setConfigByJSON(json_url:String, callback:Function):void
		{
			if (useCacaheConfig)
			{
				timeout_timer = new Timer(5000, 1)
				timeout_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeout);
				timeout_timer.start();
			}
			//_callback = callback;
			var php:PHPAPI = new PHPAPI();
			php.setGatewayUrl(json_url);
			php.call('get_einstation_config', onLoadJsonComplete);
			function onLoadJsonComplete(e:Object):void
			{
				/**
				 * @todo:这里将php返回的值转为object.
				 */
				setConfigByObject({}, callback)
				saveConfigToLocal();
				if (!onInitComplete)
				{
					callback();
				}
			}
			//超时时候的操作.
			function onTimeout(e:TimerEvent):void
			{
				setConfigByObject(SharedObject.getLocal(_SharedObjectKey).data[_configKey], callback)
				onInitComplete = true;
				timeout_timer.stop()
				timeout_timer = null;
			}
		}
		
		/**
		 * 把获取到设置保存到本地.
		 */
		private static function saveConfigToLocal():void
		{
			flushLocalConfig()
			SharedObject.getLocal(_SharedObjectKey).data[_configKey] = config_data
		}
		
		/**
		 * 获取用户设定的内容.如果没有则返回空.
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
				trace('ConfigManager.getConfig: can not find config key:', key);
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
				saveConfigToLocal();
			}
			catch (e:*)
			{
			}
		}
		
		/**
		 * 清理数据.
		 */
		public static function flushLocalConfig():void
		{
			var so:SharedObject = SharedObject.getLocal(_SharedObjectKey)
			var sos:String = ""
			try
			{
				sos = so.flush();
			}
			catch (error:Error)
			{
			}
			switch (sos)
			{
			case SharedObjectFlushStatus.PENDING: 
				trace('ConfigManager:SharedObjectFlushStatus.PENDING  what?!!??!')
				break;
			case SharedObjectFlushStatus.FLUSHED: 
				break;
			}
		
		}
	}

}