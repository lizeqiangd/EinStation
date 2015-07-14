package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.components.debug.db;
	import com.lizeqiangd.zweisystem.events.LoginEvent;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	//import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import flash.events.EventDispatcher;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	/**
	 * EinStation系统提权用类,所有重要操作会询问这里获取权限,但是同时这里的信息会一次次的发送到服务器上防止暴力破解
	 * 2014.04.05 更新注释更改引用
	 */
	public class LoginManager
	{
		private static var _username:String = "";
		private static var _password:String = "";
		private static var _user_type:String = "";
		private static var _email:String = ""
		private static var _uid:int = 0;
		private static var _dispatcher:EventDispatcher;
		private static var _saveLoginInfo:Boolean = false;
		private static var _userChangeFuncs:Dictionary;
		
		private static var sharedobject_name:String = 'EinStaion';
		/**
		 * 初始化应用,同时询问是否从cookies中获取上次登录信息.
		 * @param	isGettingLoginSO
		 */
		public static function init(isGettingLoginSO:Boolean = true):void
		{
			_dispatcher = new EventDispatcher;
			_userChangeFuncs = new Dictionary;
			isGettingLoginSO ? getLoginSO() : null;
		}
		
		///添加侦听
		public static function addEventListener(type:String, listener:Function):void
		{
			_dispatcher.addEventListener(type, listener, false, 0, true);
		}
		
		///移除侦听
		public static function removeEventListener(type:String, listener:Function):void
		{
			_dispatcher.removeEventListener(type, listener);
		}
		
		///从cookies中登陆
		private static function getLoginSO():void
		{
			if (SystemConfig.getLocalConfig(sharedobject_name) != null)
			{
				_username = SystemConfig.getLocalConfig(sharedobject_name).username
				_password = SystemConfig.getLocalConfig(sharedobject_name).password
				login(_username, _password, true);
			}
			else
			{
				_user_type = "guest";
			}
		}
		
		///直接输入用户名密码以及是否需要缓存.
		public static function login(username:String, password:String, cache:Boolean = false):void
		{
			if (username == "")
			{
				db.log("LoginManager:empty username,will not login");
				return;
			}
			db.log("LoginManager:username:", username, "is logining...");
			_saveLoginInfo = cache;
			_username = username;
			_password = password;
			_user_type = "guest";
			var o:Array = [];
			o.username = username;
			o.password = password
			//AMFPHP.call("CoreServices/getUserInfoByPassword", new Responder(onCheckLogOK, onFault), o);
			_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.USER_CHANGE));
			AMFPHP.call("UserManager/CherkUserAuthorize", new Responder(onCheckLogOK, onFault), o);
		
		}
		
		///当确定的信息成功从服务器反馈的时候进行处理.登陆确认为失败的时候回触发登出事件.
		private static function onCheckLogOK(e:*):void
		{
			if (e.state == "success")
			{
				_user_type = e.user_type;
				_uid = e.uid;
				_username = e.username;
				_email = e.email;
				if (_saveLoginInfo)
				{
					SystemConfig.setLocalConfig(sharedobject_name, {username: _username, password: _password})
				}
				db.log("LoginManager.onCheckLogOK: Login success:" + _username)
				_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_OK));
				_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.USER_CHANGE));
				updateUserChange();
			}
			if (e.state == "failed")
			{
				db.log("LoginManager.onCheckLogOK: Login failed:" + _username)
				_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGIN_FAULT));
				logOut()
			}
		}
		
		///登陆过程中的网络失败问题.
		private static function onFault(e:*):void
		{
			db.log("LoginManager.onFault:Login Failure,net problem.");
			logOut()
		}
		
		/**
		 * 登出当前用户,设置用户名为guest.密码为0 权限组为guest 同时清空cookies.触发事件.
		 */
		public static function logOut():void
		{
			_username = "guest";
			_password = "";
			_user_type = "guest";
			SystemConfig.deleteLocalConfig(sharedobject_name)
			
			//_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGOUT_OK));
			_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.USER_CHANGE));
			_dispatcher.dispatchEvent(new LoginEvent(LoginEvent.LOGOUT_OK));
			updateUserChange();
		}
		
		/**
		 * 添加方法到LoginManager中,当发生响应事件时会触发字典内所有方法
		 * @param	_arg1
		 */
		public static function addLoginFunction(_arg1:Function):void
		{
			if (!(_userChangeFuncs[_arg1] is Function))
			{
				_userChangeFuncs[_arg1] = _arg1;
				_arg1()
			}
		}
		
		/**
		 * 从LoginMangaer删除方法.
		 * @param	_arg1
		 */
		public static function removeLoginFunction(_arg1:Function):void
		{
			if ((_userChangeFuncs[_arg1] is Function))
			{
				_userChangeFuncs[_arg1] = null;
				delete _userChangeFuncs[_arg1];
			}
		}
		
		///重新激活所有方法检测当前用户权限.
		public static function updateUserChange():void
		{
			_userChange(null);
		}
		
		///自动化处理
		private static function _userChange(_arg1:*):void
		{
			var _local2:Function;
			for each (_local2 in _userChangeFuncs)
			{
				if ((_local2 is Function))
				{
					_local2();
				}
			}
		}
		
		///获取当前用户UID
		static public function get getUid():int
		{
			return _uid
		}
		
		///获取当前用户username
		static public function get getUsername():String
		{
			return _username;
		}
		
		///获取当前用户password明文
		static public function get getPassword():String
		{
			return _password;
		}
		
		///获取当前用户email ???
		static public function get getEmail():String
		{
			return _email;
		}
		
		///获取当前用户usertype 用户权限组
		static public function get getUserType():String
		{
			return _user_type;
		}
		
		///获取当前用户的usertype是否为administrator
		public static function get isAdministrator():Boolean
		{
			return _user_type == "administrator";
		}
	}
}