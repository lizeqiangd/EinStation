package com.lizeqiangd.zweisystem.system.applications.navigation
{
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class NavigationManager
	{
		private static var navigationbar:NavigationBar
		
		public static function init()
		{
			navigationbar = LayerManager.createPopUp(NavigationBar)
			StageProxy.addResizeFunction(onStageResize)
			onStageResize()
		}
		
		public static function enableNavigation(value:Boolean)
		{
			if (value)
			{
				AnimationManager.fade_in(navigationbar)
			}
			else
			{
				AnimationManager.fade_out(navigationbar)
			}
		}
		
		static private function onStageResize():void
		{
			PositionUtility.setDisplayPosition(navigationbar, "L")
			navigationbar.y = 0.8 * StageProxy.stageHeight
		}
	
	}

}