package com.lizeqiangd.zweisystem.system.applications.stageanimation
{
	import com.lizeqiangd.zweisystem.abstract.windows.FullWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.AnimationEvent;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
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
		
		private var ssn:SystemStatusNotification
		
		public function StageMask()
		{
			this.setDisplayLayer = "animationLayer";
			this.setBackgroundTitle = "Einstation System Application - StageMask -";
			this.setApplicationName = "StageMask";
			ssn = new SystemStatusNotification()
			ssn.config(getUiWidth, getUiHeight, this)
			onStageResize()
			init(null)
		}
		
		public function init(e:ApplicationEvent):void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			StageProxy.addResizeFunction(onStageResize);
			setTimeout(onStageResize, 1000)
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
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
			configBaseUi(StageProxy.stageWidth, StageProxy.stageHeight)
			ssn.resize(getUiWidth, getUiHeight)
		}
		
		public function applicationMessage(e:Object):void
		{
			if (e.close) {
				ssn.clean()
				return
			}			
			ssn.anime(e.anime?e.anime:"", e.text?e.text:"");
			return
		}
	}

}