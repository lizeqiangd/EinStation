package com.lizeqiangd.zweisystem.events
{
	import flash.events.Event;
	
	/**
	 * 登陆事件,当用户进行登陆或登出的时候会调度的事件.
	 * @author:Lizeqiangd
	 * update 2014.03.28 修改路径
	 */
	public class LoginEvent extends Event
	{
		public static var LOGIN_OK:String = "on_login";
		
		public static var LOGOUT_OK:String = "on_login_out";
		
		public static var LOGIN_FAULT:String = "on_fault";
		
		public static var USER_CHANGE:String = "user_change";
		public var data:*;
		
		public function LoginEvent(type:String, DispatchData:* = null, bubbles:Boolean = false)
		{
			super(type, bubbles);
			data = DispatchData;
		}
	}
}