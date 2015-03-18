package com.lizeqiangd.zweisystem.abstract.anime
{
	import com.lizeqiangd.zweisystem.events.AnimationEvent
	import flash.display.MovieClip;
	
	/**
	 * 基础动画事件的基类.目前毫无没用.
	 */
	public class AnimeBase extends MovieClip
	{
		public var midFrame:int = 0
		
		/*
		 *
		 */
		public function AnimeBase()
		{
			super();
			gotoAndStop(2)
			this.addFrameScript(this.totalFrames, animeStop())
			//addStopToFinal()
			dispatchEvent(AnimationEvent.INITED)
		}
		
		/*
		 *
		 */
		private function addStopToFinal()
		{
		
		}
		
		/*
		 *
		 */
		public function animeStop()
		{
			stop()
			dispatchEvent(AnimationEvent.STOP)
		}
		
		/*
		 *
		 */
		public function animeInit()
		{
		}
		//public function dispatchEvent(){}
	}
}