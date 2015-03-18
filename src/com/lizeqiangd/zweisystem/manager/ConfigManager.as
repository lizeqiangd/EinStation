package com.lizeqiangd.zweisystem.manager
{
	
	/**
	 * 全局的配置信息.
	 * @author Lizeqiangd
	 */
	public class ConfigManager
	{
		private static var config_data:Object = {}
		private static var complete_func:Function
		
		public static function setConfigByLocal(onCompleteFunc:Function):void
		{
			complete_func = onCompleteFunc;
			config_data = {test: '123'
				
				}
			
			complete_func();
		}
		
		public static function setConfigByServer(onCompleteFunc:Function):void
		{
			complete_func = onCompleteFunc;
		}
		
		public static function setConfigByUrl(onCompleteFunc:Function):void
		{
			complete_func = onCompleteFunc;
		}
		
		public static function getConfig(key:String):*
		{
			try
			{
				return config_data[key]
			}
			catch (e:*)
			{
				
			}
			return;
		}
		
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