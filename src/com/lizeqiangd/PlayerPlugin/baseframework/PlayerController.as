package com.lizeqiangd.PlayerPlugin.baseframework
{
	
	/**
	 * 播放器控制插件.
	 * @author Lizeqiangd
	 */
	public class PlayerController
	{
		private static var instance:PlayerController
		
		public static function get getInstance():PlayerController
		{
			if (!instance)
				instance = new PlayerController
			return instance
		}
		
		
		private var player_stop_function:Function
		private var player_play_function:Function
		private var plugin_close_function:Function
		public function PlayerController()
		{
			if (instance)
				throw new Error('please use getInstance to get this instance.', 1)
		}
		
		public function Play():void
		{
		
		}
		
		public function Pause():void
		{
		
		}
		
		public function Close():void
		{
		
		}
	
	}

}