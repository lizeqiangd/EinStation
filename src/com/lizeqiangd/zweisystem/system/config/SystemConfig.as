package com.lizeqiangd.zweisystem.system.config
{
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	//import com.lizeqiangd.zweisystem.net.AMFPHP;
	import flash.events.NetStatusEvent;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	/**
	 *该类用于给其他类快速访问到服务器上的设定所用,所有设定都在网络上.
	 * @author lizeqiangd
	 * @update 2014.03.30 更新路径和增加注释
	 * 20141231 暂时关闭网络功能,变成可以独立访问的类.
	 */
	public class SystemConfig
	{
		private static var _SharedObjectKey:String = ""
		
		public static function init(key:String):void
		{
			if (_SharedObjectKey)
			{
				trace("key already set.")
				return
			}
			_SharedObjectKey = key
		}
		
		/**
		 * 该方法将一个设定覆盖到服务器上去,同时会从LoginManager中获取用户名和密码用于确认是否有这个权限.
		 * @param	name 设置名称
		 * @param	value 内容
		 * @param	okFunc 成功后调用的方法
		 */
		public static function setSystemConfig(name:String, value:String, okFunc:Function = null):void
		{
			var o:Array = []
			o.password = LoginManager.getPassword
			o.username = LoginManager.getUsername
			o.name = name
			o.value = value
			//AMFPHP.call("EinStationServices/setEinStationConfig2", new Responder(okFunc, onSystemConfigFailed), o)
		}
		
		/**
		 * 获取一个设定的名称.
		 * 使用方法: SystemConfig.getSystemConfig("test",onResult)
		 * function onResult(o:Object){
		 * o.name=="test" //true
		 * var obj:Object = JSON.parse(o.value)
		 * }很容易吧~
		 * @param	name 设定名称
		 * @param	okFunc 成功后调用的方法
		 */
		public static function getSystemConfig(name:String, okFunc:Function):void
		{
			//AMFPHP.call("EinStationServices/getEinStationConfig2", new Responder(okFunc, onSystemConfigFailed), name)
		}
		
		/**
		 * 获取一个设定的名称.更加方便!!!
		 * 使用方法: SystemConfig.getSystemConfig("test",onResult)
		 * function onResult(o:Object){
		 * o.name=="test" //true
		 * var obj:Object = JSON.parse(o.value)
		 * }很容易吧~
		 * @param	name 设定名称
		 * @param	okFunc 成功后调用的方法
		 */
		public static function getSystemConfig2(name:String, okFunc:Function):void
		{
			//AMFPHP.call("EinStationServices/getEinStationConfig2", new Responder(function(e:*):void
				//{
					//okFunc(JSON.parse(e.value));
				//}, onSystemConfigFailed), name)
		}
		
		/**
		 * 设置本地SharedObject数据.需要数据的名字以及数据本身的资料.
		 * @param	name
		 * @param	value
		 */
		public static function setLocalConfig(name:String, value:Object):void
		{
			var so:SharedObject = SharedObject.getLocal(_SharedObjectKey)
			var sos:String = ""
			so.data[name] = value
			try
			{
				sos = so.flush();
			}
			catch (error:Error)
			{
			}
			if (sos != null)
			{
				switch (sos)
				{
					case SharedObjectFlushStatus.PENDING: 
						so.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void
							{
								switch (event.info.code)
								{
									case "SharedObject.Flush.Success": 
										break;
									case "SharedObject.Flush.Failed": 
										break;
								}
								so.removeEventListener(NetStatusEvent.NET_STATUS, this);
							});
						break;
					case SharedObjectFlushStatus.FLUSHED: 
						break;
				}
			}
		}
		
		public static function deleteLocalConfig(name:String):void
		{
			var so:SharedObject = SharedObject.getLocal(_SharedObjectKey)
			so.data.name = null
			so.flush();
		}
		
		public static function getLocalConfig(name:String):Object
		{
			return SharedObject.getLocal(_SharedObjectKey).data[name]
		}
		
		/**
		 * 当设置或获取设定失败的时候会提示本信息 (通过是php错误,一般不会显示)
		 * @param	state
		 */
		private static function onSystemConfigFailed(state:Object):void
		{
			if (state.state == "failed")
			{
				Message.AMFPHPSystemConfigMessage(state.message)
			}
		}
	
	}

}