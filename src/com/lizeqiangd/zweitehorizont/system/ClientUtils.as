package com.lizeqiangd.zweitehorizont.system
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class ClientUtils
	{
		private static var _clientCid:uint = 0
		private static var _clientSid:uint = 0
		
		public static function get getClientCid():uint
		{
			if (!_clientCid)
			{
				_clientCid = Math.floor(Math.random() * 1000000) + getTimer()
				
			}
			return _clientCid
		}
		
		public static function get getNewObjectUid():uint
		{
			return Math.floor(Math.random() * 100000000)		
		}
		
		public static function set setClientSid(sid:uint):void
		{
			_clientSid = sid
		}
		
		public static function get getClientSid():uint
		{
			return _clientSid
		}
	
	}
}