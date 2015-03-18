package com.lizeqiangd.zweisystem.data.config
{
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class EinStationConfigCache
	{
		
		private static var _configs:Array
		
		public static function cache(e:Object)
		{	
			_configs = new Array
			for (var i:int =0; i < e.length; i++)
			{
				var c:Config = new Config
				c.value = e[i].value + ""
				c.id = e[i].id + ""
				c.description = e[i].description + ""
				c.name = e[i].name + ""
				c.update_time = e[i].update_time + ""
				_configs.push(c)
				
			}
		}
		public static function getConfigByName(name:String ):Object  {
			for (var i:int = 0; i < EinStationConfigCache.configs.length; i++)
			{
				if (name == EinStationConfigCache.configs[i].name)
				{
					return {value:EinStationConfigCache.configs[i].value,name:EinStationConfigCache.configs[i].name}
				}
			}	return {}
		}
		public static function get configs():Array
		{
			return _configs
		}
	}

}

