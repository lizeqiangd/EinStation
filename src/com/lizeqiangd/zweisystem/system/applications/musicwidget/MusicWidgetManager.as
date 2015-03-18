package com.lizeqiangd.zweisystem.system.applications.musicwidget
{
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	
	/**
	 * 背景音乐widget service管理器.是widget的
	 * @author lizeqiangd
	 */
	public class MusicWidgetManager
	{
		private static var musicwidget:MusicWidget
		private static var inited:Boolean = false
		
		public static function init()
		{
			if (inited)
			{
				return
			}
			musicwidget = LayerManager.createPopUp(MusicWidget)
			inited = true
		}
		/**
		 * 0为完全隐藏.
		 * @param	statue
		 */
		public static function hideWidget(statue:int)
		{
			musicwidget.applicationMessage({type: "hide", value: statue})
		}
		
		public static function get MusicWidgets():MusicWidget
		{
			return musicwidget
		}
	
	}

}