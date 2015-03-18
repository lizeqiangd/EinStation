package com.lizeqiangd.zweitehorizont
{
	import com.lizeqiangd.zweitehorizont.manager.MessageChannelManager;
	import com.lizeqiangd.zweitehorizont.manager.ObjectManager;
	import com.lizeqiangd.zweitehorizont.manager.UserManager;
	import com.lizeqiangd.zweitehorizont.net.FMSProxy;
	import com.lizeqiangd.zweitehorizont.system.ClientUtils;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class ZweiteHorizont
	{
		
		private static var fms_token:String = "ZweiteHorizont"
		private static var fms_address:String = "rtmp://localhost/ZweiteHorizont"
		
		private static var fp:FMSProxy
		private static var um:UserManager
		private static var om:ObjectManager
		private static var mcm:MessageChannelManager
		
		public static function init():void
		{
			um = new UserManager()
			fp = new FMSProxy()
			om = new ObjectManager()
			mcm = new MessageChannelManager()
			
			mcm.init(fp)
			om.init(fp)
			um.init(fp)
			
			fp.init(fms_address, fms_token, ClientUtils.getClientCid)
		}
		
		public static function get ObjectManagers():ObjectManager
		{
			return om
		}
		
		public static function get UserManagers():UserManager
		{
			return um
		}
		
		public static function get FMSProxys():FMSProxy
		{
			return fp
		}
		
		public static function get MessageChannelManagers():MessageChannelManager
		{
			return mcm
		}
		
		
		public static function set ServerAddress(e:String):void
		{
			fms_address = e
		}
		
		public static function set ApplicationToken(e:String):void
		{
			fms_token = e
		}
	}
}