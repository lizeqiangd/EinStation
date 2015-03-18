package com.lizeqiangd.zweisystem.system.applications.background
{
	import com.lizeqiangd.zweisystem.data.image.Image;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.manager.HostManager;
	import flash.events.Event;
	
	/**
	 * 作为系统应用:背景图片 的管理器.
	 * 可以用于调用背景load图等各种行为.全部操作行为均在此完成.
	 * 2014.03.31 读取图片的方法由外部来控制.
	 * 2014.06.07 更新视频模式.
	 */
	public class BackgroundManager
	{
		private static var background:BackGround
		
		public static const recover:String = "recover";
		public static const blackWithoutText:String = "blackWithoutText";
		public static const black:String = "black";
		public static const whiteWithoutText:String = "whiteWithoutText";
		public static const white:String = "white";
		public static const none:String = "none"
		
		private static var inited:Boolean = false
		
		public static function init()
		{
			if (inited)
			{
				return
			}
			background = LayerManager.createPopUp(BackGround)
			var o:Object = {image: HostManager.BACKGROUND_IMAGE, type: "remote"}
			background.applicationMessage(o)
			inited = true
		}
		/**
		 * 为背景增加侦听事件方法.
		 * 目前用于自动播放动画效果
		 * @param	event
		 * @param	listener
		 */
		public static function addEventListener(event:String , listener:Function)
		{
			background.addEventListener(event, listener, false, 0, true)
		}
		/**
		 * 为背景增加移除事件方法.
		 * @param	event
		 * @param	listener
		 */
		public static function removeEventListener(event:String, listener:Function)
		{
			background.removeEventListener(event, listener)
		}
		
		/**
		 * 外部要遥控背景图片的时候使用.
		 * @param	url
		 * @param	description
		 */
		public static function remote(url:String, description:String = "")
		{
			if (!inited)
			{
				return
			}
			var i:Image = new Image
			i.url = url
			i.description = description
			var o:Object = {image: i, type: "remote"}
			background.applicationMessage(o)
		}
		
		/**
		 * 外部遥控背景图片显示模式时候用
		 * "recover","blackWithoutText","black","whiteWithoutText","white","none"
		 * @param	s
		 */
		public static function control(s:String)
		{
			if (!inited)
			{
				return
			}
			trace("BackgroundManager :Control type:" + s)
			background.applicationMessage({type: s})
		
		}
		/**
		 * 外部锁死信息.
		 * @param	information
		 * @param	isLocked
		 */
		public static function infomation(information:String , isLocked:Boolean = false) {
			background.applicationMessage({type:"infolock",info:information,lock:isLocked})
		}
	
	}
}