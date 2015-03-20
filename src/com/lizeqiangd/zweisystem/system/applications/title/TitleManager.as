package com.lizeqiangd.zweisystem.system.applications.title
{
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	
	/**
	 * 系统抬头文字的管理器.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * update
	 * 2014.04.04 增加注释
	 */
	public class TitleManager
	{
		private static var mainTitleBar:TitleBar
		private static var inited:Boolean = false
		
		///初始化该管理器.
		public static function init():void
		{
			if (inited)
			{
				return
			}
			inited = true
			mainTitleBar = LayerManager.createPopUp(TitleBar)
			onResize()
			//PositionManager.addPosObject(mainTitleBar, "TC")
			StageProxy.addResizeFunction(onResize)
		}
		
		///当舞台尺寸改变时候触发.以后可能多标题所以在这里管理.
		static private function onResize():void
		{
			if (inited)
			{
				PositionUtility.setDisplayPosition(mainTitleBar, "TC")
			}
		}
		
		///自动从服务器获取文字.
		static public function loadTitleFormServer():void
		{
			SystemConfig.getSystemConfig("TitleInformation", onLoadTitleInformationComplete)
			TitleManager.MainTitle = "从服务器获取信息中...."
		}
		
		static private function onLoadTitleInformationComplete(e:Object):void
		{
			TitleManager.MainTitle = e.value
		}
		
		///设置标题文字.
		public static function set MainTitle(s:String):void
		{
			if (inited)
			{
				mainTitleBar.applicationMessage(s)
				onResize()
			}
		
		}
		
		///建立副标题.不知道如何是好~~咕嘿嘿@20140404
		public static function createSubTitle():void
		{
			if (!inited)
			{
				return
			}
		}
	}

}