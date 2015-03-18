package com.lizeqiangd.zweisystem.applications.PsychoPass
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.ApplicationManager;
	import com.zweisystem.managers.PositionManager;
	import com.zweisystem.system.applications.background.BackgroundManager;
	import com.zweisystem.system.proxy.StageProxy;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout
	import com.zweisystem.abstracts.windows.FullWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	
	public class PsychoPassBackground extends FullWindows implements iApplication
	{
		private var wcVisible:Boolean = false
		
		public function PsychoPassBackground()
		{
			this.setBackgroundTitle = "EinStation Application - PsychoPassBackground -";
			this.setApplicationName = "PsychoPassBackground";
			this.setBackgroundControlType=BackgroundManager.blackWithoutText
			this.setAutoRemoveBackground = false
			tx_right.visible = false
			onStageResize()
			StageProxy.addResizeFunction(onStageResize);
			addEventListener(ApplicationEvent.INIT, init);
			ApplicationManager.open("SinaWeibo.MainController.SinaWeiboMainController");
			btn_close.alpha=0.1
		}
		
		public function init(e:ApplicationEvent)
		{
			tx_right.visible = true
			addUiListener();
			tx_right.title = "PSYCHO-PASS ©サイコパス製作委員会"
			setTimeout(hideWeibo, 200)
			setTimeout(openAnime, 1000)
			onStageResize()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function hideWeibo():void
		{
			ApplicationManager.Application("SinaWeiboMainController").applicationMessage({type: "hide"})
		}
		
		private function openAnime():void
		{
			
			ApplicationManager.open("PsychoPass.PsychoPassWelcomeAnimation")
		}
		
		private function addUiListener()
		{
			addEventListener(ApplicationEvent  .CLOSE, onApplicationClose);
			btn_close.addEventListener(MouseEvent.CLICK, closeWindwos);
			tx_right.addEventListener(MouseEvent.CLICK, visibleWC);
		}
		
		private function visibleWC(e:MouseEvent):void
		{
			wcVisible ? ApplicationManager.Application("SinaWeiboMainController").applicationMessage({type: "hide"}) : ApplicationManager.Application("SinaWeiboMainController").applicationMessage({type: "show"})
			wcVisible = !wcVisible
		}
		
		private function removeUiListener()
		{
			btn_close.removeEventListener(MouseEvent.CLICK, closeWindwos);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			tx_right.removeEventListener(UnitEvent.CLICK, visibleWC);
		}
		private function closeWindwos(e:MouseEvent ){
			this.CloseApplication()
		}
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeUiListener();		
		}
		
		private function onStageResize()
		{
			PositionManager.setDisplayPosition(tx_right, "BR")
			PositionManager.setDisplayPosition(btn_close, "BL")
			
		}
		public function dispose() {
			this.CloseApplication ()
			}
		public function applicationMessage(e:Object)
		{
			switch (e)
			{
				case "OpeningAnimeComplete": 
					ApplicationManager.open("PsychoPass.PsychoPassWelcome")
					break;
				default: 
					break;
			}
		}
	}

}