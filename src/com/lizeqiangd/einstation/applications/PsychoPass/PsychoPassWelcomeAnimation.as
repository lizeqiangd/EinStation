package com.lizeqiangd.zweisystem.applications.PsychoPass
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	;
	import com.zweisystem.managers.ApplicationManager;
	import com.zweisystem.managers.PositionManager;
	import flash.utils.setTimeout
	import com.zweisystem.abstracts.windows.AnimeWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	
	public class PsychoPassWelcomeAnimation extends AnimeWindows implements iApplication
	{
		public function PsychoPassWelcomeAnimation()
		{
			this.setDisplayLayer = "animationLayer";
			this.setOpeningAnimationType = "fade_in"
			this.setApplicationName = "PsychoPassWelcomeAnimation";
			addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{ //PositionManager.center(this)
			addUiListener();
			mc_anime.play();
			setTimeout(closeThis, 2300);
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function closeThis():void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		private function addUiListener()
		{
			addEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		private function removeUiListener()
		{
			removeEventListener(ApplicationEvent.INITED, init);
			removeEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			try
			{
				ApplicationManager.Application("PsychoPassBackground").applicationMessage("OpeningAnimeComplete")
			}
			catch (e:*)
			{
			}
			removeUiListener();
		}
		
		public function dispose()
		{
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