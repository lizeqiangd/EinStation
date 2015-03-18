package com.lizeqiangd.zweisystem.system.applications.navigation
{
	import com.greensock.TweenLite;
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 本应用是应用菜单的实例.由NavigationManager负责.
	 * 2014.05.11 更新按钮图标.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class NavigationBar extends BaseWindows //implements iApplication
	{
		private var mc_navi:Sprite
		private var status:uint = 0
		private var mc_menu:ApplicationMenu
		
		public function NavigationBar()
		{
			this.setDisplayLayer = "topLayer";
			this.setApplicationName = "NavigationBar";
			this.setApplicationVersion = "0.1"
			mc_navi = new Sprite
			mc_menu = new ApplicationMenu
			init(null)
		}
		
		public function init(e:ApplicationEvent)
		{
			mc_menu.alpha = 0
			mc_menu.visible = false
			mc_menu.y = 0
			mc_navi.graphics.beginFill(0x3399ff, 1)
			mc_navi.graphics.drawRect(0, 0, 1, 30)
			mc_navi.graphics.endFill()
			mc_navi.alpha = 0
			addChild(mc_navi)
			addChild(mc_menu)
			//mc_icon.mouseEnabled = false
			//mc_frame.mouseEnabled = false
			//mc_navi.mouseEnabled = false
			StageProxy.addResizeFunction(onStageResize)
			addApplicationListener()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function onStageResize():void
		{
			switch (status)
			{
				case 0: 
					break;
				case 1: 
					TweenLite.to(mc_navi, 1, {autoAlpha: 1, width: StageProxy.stageWidth / BaseWindows.getNowScale, overwrite: 3, onComplete: onPopupComlete})
					//TweenLite.to(mc_icon, 1, {x: StageProxy.stageWidth, overwrite: 3})
					//TweenLite.to(mc_frame, 1, {x: StageProxy.stageWidth, overwrite: 3})
					//TweenLite.to(mc_hotspot, 1, {x: StageProxy.stageWidth, overwrite: 3})
					TweenLite.to(mc_button, 1, {x: StageProxy.stageWidth / BaseWindows.getNowScale, overwrite: 3})
					break;
				case 2: 
					mc_menu.x = (StageProxy.stageWidth / 2 - mc_menu.width / 2) / BaseWindows.getNowScale
					//PositionUtility.widthCenter(mc_menu)
					mc_navi.width = StageProxy.stageWidth
					//mc_icon.x = StageProxy.stageWidth
					//mc_frame.x = StageProxy.stageWidth
					//mc_hotspot.x = StageProxy.stageWidth
					mc_button.x = StageProxy.stageWidth
					break;
			}
		
		}
		
		private function onNavigationBarOpen(e:MouseEvent):void
		{
			status = 1
			mc_navi.width = 2
			TweenLite.to(mc_navi, 1, {autoAlpha: 1, width: StageProxy.stageWidth / BaseWindows.getNowScale, overwrite: 3, onComplete: onPopupComlete})
			//TweenLite.to(mc_icon, 1, {x: mc_icon.x + StageProxy.stageWidth, overwrite: 3})
			//TweenLite.to(mc_frame, 1, {x: mc_frame.x + StageProxy.stageWidth, overwrite: 3})
			//TweenLite.to(mc_hotspot, 1, {x: mc_hotspot.x + StageProxy.stageWidth, overwrite: 3})
			TweenLite.to(mc_button, 1, {x: mc_button.x + StageProxy.stageWidth / BaseWindows.getNowScale, overwrite: 3})
			AnimationManager.MaskInStage(0.8)
			mc_navi.addEventListener(MouseEvent.CLICK, onNavigationBarClose)
		}
		
		private function onNavigationBarClose(e:MouseEvent)
		{
			status = 0
			TweenLite.to(mc_navi, 1, {autoAlpha: 0, overwrite: 3})
			//mc_icon.x = -20
			//mc_hotspot.x = -20
			//mc_frame.x = -20
			mc_button.x = -20
			//TweenLite.to(mc_icon, 1, {x: 0, overwrite: 3})
			//TweenLite.to(mc_frame, 1, {x: 0, overwrite: 3})
			//TweenLite.to(mc_hotspot, 1, {x: 0, overwrite: 3})
			TweenLite.to(mc_button, 1, {x: 0, overwrite: 3})
			AnimationManager.MaskOutStage()
			mc_navi.removeEventListener(MouseEvent.CLICK, onNavigationBarClose)
			AnimationManager.fade_out(mc_menu)
			mc_click.visible = true
		}
		
		private function onPopupComlete():void
		{
			status = 2
			onStageResize()
			AnimationManager.fade_in(mc_menu)
			mc_click.visible = false
		}
		
		private function addApplicationListener()
		{
			mc_menu.addEventListener(UnitEvent.SELECTED, onApplicationSelected)
			mc_click.addEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			//mc_icon.addEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			//mc_frame.addEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			//mc_hotspot.addEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener()
		{
			mc_click.removeEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			mc_navi.removeEventListener(MouseEvent.CLICK, onNavigationBarClose)
			//	mc_icon.removeEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			//	mc_frame.removeEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			//	mc_hotspot.removeEventListener(MouseEvent.CLICK, onNavigationBarOpen)
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationSelected(e:UnitEvent):void
		{
			onNavigationBarClose(null)
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			dispose()
		}
		
		public function dispose()
		{
			removeApplicationListener();
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e)
			{
				case "": 
					break;
				default: 
					break;
			}
		}
	}

}