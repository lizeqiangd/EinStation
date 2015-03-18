package com.lizeqiangd.zweisystem.system.applications.message
{
	
	/**
	 * 用于简便使用信息弹出框，并翻译文本框内容的类
	 * @author Lizeqiangd
	 */
	public class Message
	{
		///默认系列		
		public static function SystemErrorMessage(message:String = "")
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = message + " "
			obj.btn1 = "确定";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "系统错误";
			obj.animeText2 = "System Error";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "red";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SystemMessage(message:String = "", autoClose:Boolean = false)
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = message + " "
			obj.btn1 = "确定";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "系统提示";
			obj.animeText2 = "System Notification";
			obj.autoClose = autoClose;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "lightblue";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SystemConfirm(s:String, e:Function)
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = s + " ";
			obj.btn1 = "是";
			obj.btn2 = "否";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = false;
			obj.color = "lightblue";
			obj.sound = "";
			Msg.confirm(obj, e);
		}
		
		public static function BoardcastMessage(c)
		{
			var obj:Object = new Object;
			obj.title = "EinStation Boardcast";
			obj.info = c;
			obj.btn1 = "确认";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "广播信息";
			obj.animeText2 = "Boardcast Message";
			obj.autoClose = false;
			obj.replayAnime = false;
			obj.showCloseButton = false;
			obj.color = "lightblue";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function ApplicationExisted(c)
		{
			var obj:Object = new Object;
			obj.title = "ZweiSystem Notification";
			obj.info = "程序地址[" + c + "]已经打开，该程序不允许存在其他副本。";
			obj.btn1 = "确认";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = true;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "lightblue";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function ApplicationFullWindowsExisted(c)
		{
			var obj:Object = new Object;
			obj.title = "ZweiSystem Notification";
			obj.info = "程序地址[" + c + "]为全屏程序，目前已经存在全屏程序，请关闭后再打开。";
			obj.btn1 = "确认";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = true;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "lightblue";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function ApplicationOpenFailed(c)
		{
			var obj:Object = new Object;
			obj.title = "ZweiSystem Notification";
			obj.info = "程序地址[" + c + "]打开失败。";
			obj.btn1 = "确认";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "系统错误";
			obj.animeText2 = "System Error";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "red";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function MessageBoxTooMuch(e:Function)
		{
			var obj:Object = new Object;
			obj.title = "ZweiSystem Notification";
			obj.info = "目前屏幕内存在过多信息提示窗口，是否要全部关闭？";
			obj.btn1 = "是";
			obj.btn2 = "否";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = false;
			obj.replayAnime = false;
			obj.showCloseButton = false;
			obj.color = "red";
			obj.sound = "";
			Msg.confirm(obj, e);
		}
		
		public static function OpenUrl(url:String, type:String, func:Function, trusted:Boolean = false)
		{
			var obj:Object = new Object;
			obj.title = "ZweiSystem Notification";
			if (trusted)
			{
				obj.info = "您确认以 " + type + " 形式打开受信任网站\n(" + url + ")吗？";
				obj.anime = "mb_yellow_interrogation";
			}
			else
			{
				obj.info = "您确认以 " + type + " 形式打开网站\n(" + url + ")吗？";
				obj.anime = "mb_yellow_interrogation";
			}
			obj.btn1 = "确定";
			obj.btn2 = "取消";
			
			obj.animeText1 = "系统提示";
			obj.animeText2 = "System Notification";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			Msg.confirm(obj, func);
		}
		
		public static function NetLoadXmlError(c:String)
		{
			var obj:Object = new Object;
			obj.title = "ZweiSystem Notification";
			obj.info = "无法加载xml文件，请检查网络是否存在问题。\n" + c;
			obj.btn1 = "确认";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "网络错误";
			obj.animeText2 = "Net Error";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "red";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function GuestbooxPublishOk()
		{
			var obj:Object = new Object;
			obj.title = "Guestbook Notification";
			obj.info = "发送成功";
			obj.btn1 = "确认";
			obj.anime = "mb_green_correct";
			obj.animeText1 = "成功";
			obj.animeText2 = "Success";
			obj.autoClose = true;
			obj.replayAnime = true;
			obj.showCloseButton = false;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function GuestbooxCommentDelete(content:String, func:Function)
		{
			var obj:Object = new Object;
			obj.title = "Guestbook Notification";
			obj.info = "你确认要删除这篇信息吗？\n" + content;
			obj.btn1 = "确认";
			obj.anime = "mb_yellow_interrogation";
			obj.animeText1 = "警告";
			obj.animeText2 = "Warning";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.confirm(obj, func)
		}
		
		public static function GuestbooxCommentDeleteOk()
		{
			var obj:Object = new Object;
			obj.title = "Guestbook Notification";
			obj.info = "删除评论成功";
			obj.btn1 = "确认";
			obj.anime = "mb_green_correct";
			obj.animeText1 = "成功";
			obj.animeText2 = "Success";
			obj.autoClose = true;
			obj.replayAnime = true;
			obj.showCloseButton = false;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function GuestbooxCommentReplyOk()
		{
			var obj:Object = new Object;
			obj.title = "Guestbook Notification";
			obj.info = "回复评论成功";
			obj.btn1 = "确认";
			obj.anime = "mb_green_correct";
			obj.animeText1 = "成功";
			obj.animeText2 = "Success";
			obj.autoClose = true;
			obj.replayAnime = true;
			obj.showCloseButton = false;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function InformationTips(message:String, func:Function)
		{
			var obj:Object = new Object;
			obj.title = "Notification";
			obj.info = message;
			obj.btn1 = "进入";
			obj.btn2 = "关闭";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "信息";
			obj.animeText2 = "Information";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "lightblue";
			obj.sound = "";
			Msg.confirm(obj, func);
		}
		
		public static function SinaWeiboApiError(e:String)
		{
			var obj:Object = new Object;
			obj.title = "Weibo Notification";
			obj.info = "新浪微博Api调用错误\n" + e;
			obj.btn1 = "确认";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "应用错误";
			obj.animeText2 = "Application Error";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "red";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SinaWeiboAuthorizationError(reason:String)
		{
			var obj:Object = new Object;
			obj.title = "Weibo Notification";
			obj.info = reason;
			obj.btn1 = "确认";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SinaWeiboPublishOk()
		{
			var obj:Object = new Object;
			obj.title = "Weibo Notification";
			obj.info = "微博发送成功。";
			obj.btn1 = "确认";
			obj.anime = "mb_green_correct";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SinaWeiboPublishError(reason:String)
		{
			var obj:Object = new Object;
			obj.title = "Weibo Notification";
			obj.info = reason;
			obj.btn1 = "确认";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "信息提示";
			obj.animeText2 = "Information Notification";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SystemVarsError(e:String)
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = "未知的参数调用\n" + e;
			obj.btn1 = "确认";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "系统错误";
			obj.animeText2 = "System Error";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "red";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function PsychoPassError(func:Function)
		{
			var obj:Object = new Object;
			obj.title = "Sibyl System on EinStation";
			obj.info = "Sibly System出现了故障，是否重新尝试？";
			obj.btn1 = "是";
			obj.btn2 = "否";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "计算失败";
			obj.animeText2 = "Calculation failed";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.confirm(obj, func)
		}
		
		public static function PsychoPassOk(e:String)
		{
			var obj:Object = new Object;
			obj.title = "Sibyl System on EinStation";
			obj.info = e;
			obj.btn1 = "关闭";
			obj.anime = "mb_green_correct";
			obj.animeText1 = "计算完成";
			obj.animeText2 = "Calculated";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function HQ_offline_control()
		{
			var obj:Object = new Object;
			obj.title = "EinStationHeadQuarters";
			obj.info = "你已经进入离线控制模式，你只可以控制本客户端的一些参数。 请注意，您将无法控制涉及网络的功能。";
			obj.btn1 = "关闭";
			obj.anime = "mb_green_correct";
			obj.animeText1 = "成功";
			obj.animeText2 = "Success";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function LoginFailed(message:String)
		{
			var obj:Object = new Object;
			obj.title = "UserManager";
			obj.info = "请检查用户名和密码是否有误,网络返回信息：" + message;
			obj.btn1 = "关闭";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "登陆失败";
			obj.animeText2 = "Login Failed";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "red";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function AMFPHPMessage(message:String)
		{
			var obj:Object = new Object;
			obj.title = "AMFPHP Notification";
			obj.info = message;
			obj.btn1 = "关闭";
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "通信信息";
			obj.animeText2 = "Connection Message";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function AMFPHPSystemConfigMessage(message:String)
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = message;
			obj.btn1 = "关闭";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "通信失败";
			obj.animeText2 = "Connection Failed";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SystemUnavailable()
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = "系统无法使用，请管理员登陆。";
			obj.btn1 = "关闭";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "系统维护";
			obj.animeText2 = "System Maintenance";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function SystemNeedUpdate()
		{
			var obj:Object = new Object;
			obj.title = "System Notification";
			obj.info = "系统版本并不是最新版本，请刷新或清理缓存。";
			obj.btn1 = "关闭";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "系统升级";
			obj.animeText2 = "System Update";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function GraduationHelper_Message(e:String)
		{
			
			var obj:Object = new Object;
			obj.title = "GraduationHelper";
			obj.info = e;
			obj.btn1 = "关闭";
			obj.anime = "mb_green_correctmb_green_correct";
			obj.animeText1 = "操作成功";
			obj.animeText2 = "Success";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function GraduationHelper_Failed(e:String)
		{
			
			var obj:Object = new Object;
			obj.title = "GraduationHelper";
			obj.info = e;
			obj.btn1 = "关闭";
			obj.anime = "mb_red_cross";
			obj.animeText1 = "操作失败";
			obj.animeText2 = "Failed";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.show(obj);
		}
		
		public static function GraduationHelper_Warning(func:Function, message:String)
		{
			var obj:Object = new Object;
			obj.title = "GraduationHelper";
			obj.info = message;
			obj.btn1 = "确认";
			obj.btn2 = "取消"
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "操作警告";
			obj.animeText2 = "Warning";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.confirm(obj, func);
		}
		
		public static function SystemUpdate(func:Function, message:String)
		{
			var obj:Object = new Object;
			obj.title = "SystemUpdate";
			obj.info = message;
			obj.btn1 = "确认";
			obj.btn2 = "取消"
			obj.anime = "mb_blue_excalmatory";
			obj.animeText1 = "操作警告";
			obj.animeText2 = "Warning";
			obj.autoClose = false;
			obj.replayAnime = true;
			obj.showCloseButton = true;
			obj.color = "";
			obj.sound = "";
			Msg.confirm(obj, func);
		}
	}
}