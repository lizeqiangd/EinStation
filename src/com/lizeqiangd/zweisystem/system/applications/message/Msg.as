package com.lizeqiangd.zweisystem.system.applications.message
{
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Messbox
	/**
	 * 自定义,快捷调用信息窗口方法.
	 * 信息提示框是EinStation的核心类.开发者..就是我一个人呢......
	 * author:Lizeqiangd
	 * update
	 * 2014.04.04 : 更改定义.
	 */
	public class Msg
	{
		public static const msg_anime:String = "anime";
		public static const msg_animeText1:String = "animeText1";
		public static const msg_animeText2:String = "animeText2";
		public static const msg_title:String = "title";
		public static const msg_info:String = "info";
		public static const msg_color:String = "color";
		public static const msg_btn1:String = "btn1";
		public static const msg_btn2:String = "btn2";
		public static const msg_replayAnime:String = "replayAnime";
		public static const msg_autoClose:String = "autoClose";
		public static const msg_type:String = "type";
		
		/**
		 * 单纯显示信息,只有一个按钮.
		 * @param	o
		 * @param	func
		 */
		public static function show(o:Object, func:Function = null):void
		{
			var msgbox:Messbox = LayerManager.createPopUp(Messbox)
			o.type = "show"
			msgbox.dataProvider = o
			/*
			   var animeObj:Object = new Object;
			   animeObj.anime = o.anime;
			   animeObj.title1 = o.animeText1;
			   animeObj.title2 = o.animeText2;
			   msgbox.anime = animeObj;
			   msgbox.setApplicationTitle = o.title;
			   msgbox.info = o.info;
			   msgbox.color = o.color;
			   msgbox.btn1 = o.btn1;
			   msgbox.mc_btn2.visible = false;
			   msgbox.mc_btn1.x = 60;
			   msgbox.replayAnime = o.replayAnime ? true : false;
			   //SoundManager.play(o.sound);
			   msgbox.btn_close.visible = o.showCloseButton;
			   if (o.autoClose)
			   {
			   msgbox.timeToClose = true;
			   }
			 */
			if (!(func == null))
			{
				msgbox.func1 = func
			}
			
			msgbox.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT))
		}
		
		/**
		 * 询问类信息框 2个按钮
		 * @param	o
		 * @param	ok_handle
		 * @param	close_handle
		 */
		public static function confirm(o:Object, ok_handle:Function, close_handle:Function = null):void
		{
			var msgbox:Messbox = LayerManager.createPopUp(Messbox)
			o.type = "confirm"
			msgbox.dataProvider = o
			/*var animeObj:Object = new Object;
			   animeObj.anime = o.anime;
			   animeObj.title1 = o.animeText1;
			   animeObj.title2 = o.animeText2;
			   msgbox.setApplicationTitle = o.title;
			   msgbox.info = o.info;
			   msgbox.color = o.color;
			   msgbox.btn1 = o.btn1 ? o.btn1 : "确定";
			   msgbox.btn2 = o.btn2 ? o.btn2 : "取消";
			   msgbox.anime = animeObj;
			   msgbox.replayAnime = o.replayAnime ? true : false;
			   msgbox.btn_close.visible = o.showCloseButton;
			
			   if (o.autoClose)
			   {
			   msgbox.timeToClose = true;
			 }*/
			msgbox.func1 = ok_handle
			if (!(close_handle == null))
			{
				msgbox.func2 = close_handle
			}
			
			msgbox.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT))
			//SoundManager.play(o.sound);
		}
		
		/**
		 * 简单的提示一个信息,全部默认设置,只需要文字.
		 * @param	s
		 */
		public static function info(s:String):void
		{
			var msgbox:Messbox = LayerManager.createPopUp(Messbox)
			
			var o:Object = new Object
			o.type = "info"
			o.info = s
			msgbox.dataProvider = o
			/*	var animeObj:Object = new Object;
			   animeObj.anime = ; //_motion
			
			   msgbox.setApplicationTitle = "ZweiStation Messager";
			   msgbox.info = s;
			   msgbox.btn1 = "关闭";
			   msgbox.anime = animeObj;
			   msgbox.replayAnime = true;
			   msgbox.mc_btn2.visible = false;
			 msgbox.mc_btn1.x = 60;*/
			msgbox.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT))
			//SoundManager.play(o.sound);
		}
	}
}