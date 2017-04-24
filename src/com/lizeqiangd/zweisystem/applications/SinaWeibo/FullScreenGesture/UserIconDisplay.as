package com.lizeqiangd.zweisystem.applications.SinaWeibo.FullScreenGesture
{
	import com.zweisystem.modules.imagedisplay.ImageDisplay;
	import flash.display.MovieClip;
	import flash.events.Event;
	public class UserIconDisplay extends MovieClip
	{

		private var im:ImageDisplay
		public function UserIconDisplay()
		{
			im = new ImageDisplay  ;
			im.addEventListener(Event.COMPLETE,onLoadComplete);
			addChildAt(im,0);
			im.config(180,180);
		}
		private function onLoadComplete(e:Event)
		{

		}
		public function load(e:String )
		{
			im.load(e);
		}
		public function dispose()
		{
			im.dispose();
			im.removeEventListener(Event.COMPLETE,onLoadComplete);
			im = null;
		}
	}

}