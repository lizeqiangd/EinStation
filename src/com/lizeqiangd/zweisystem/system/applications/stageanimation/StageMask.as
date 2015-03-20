package com.lizeqiangd.zweisystem.system.applications.stageanimation
{
	import com.lizeqiangd.zweisystem.abstract.windows.FullWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.AnimationEvent;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.Sprite;
	import flash.utils.setTimeout
	
	/**
	 * 全站遮罩是建立在动画层的,不会影响到顶层的内容.该类交给AnimationManager管理.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * update
	 * 2014.04.04 更新路径,增加注释.优化.
	 */
	public class StageMask extends FullWindows implements iApplication
	{
		public function StageMask()
		{
			this.setDisplayLayer = "animationLayer";
			this.setBackgroundTitle = "Einstation System Application - StageMask -";
			this.setApplicationName = "StageMask";
			this.setBackgroundControlType = "none"
			init(null)
		}
		
		public function init(e:ApplicationEvent):void
		{
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawRect(0, 0, 300, 300);
			this.graphics.endFill();
			this.alpha = 0
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			StageProxy.addResizeFunction(onStageResize);
			setTimeout(onStageResize, 50)
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
			;
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent):void
		{
			dispose()
		}
		
		public function dispose():void
		{
			removeApplicationListener();
			StageProxy.removeResizeFunction(onStageResize);
		}
		
		private function onStageResize():void
		{
			this.width = StageProxy.stageWidth;
			this.height = StageProxy.stageHeight;
			this.x = 0
			this.y = 0
		}
		
		public function applicationMessage(e:Object):void
		{
		
		}
	}

}