package com.zweisystem.applications.SinaWeibo.FullScreenGesture
{
	import com.zweisystem.modules.imagedisplay.ImageDisplay;
	import flash.display.Sprite;
	import flash.events.Event;
	public class ImageWeiboDisplay extends Sprite 
	{
		private var im:ImageDisplay
		public var isLoaded:Boolean = false;
		public function ImageWeiboDisplay()
		{
			im = new ImageDisplay  ;
			addChildAt(im,0);
			im.addEventListener(Event.COMPLETE,onLoadComplete);
			im.configNone();
		}
		private function onLoadComplete(e:Event )
		{
			/*
			im.y =  -  im.content.height / 2 + 1;
			im.x = 0;
			mc_frame_down.y = im.content.height / 2;
			mc_frame_up.y =  -  im.content.height / 2;
			mc_frame_up.x = 0;
			mc_frame_down.x = 440;
			*/
			isLoaded = true;
			im.y = 1;
			im.x = 0;
			mc_frame_down.y = im.height;
			//mc_frame_up.y =  -  im.content.height / 2;
			mc_frame_up.x = 0;
			mc_frame_down.x = 440;
			dispatchEvent(e);
			//trace("结束load:",isLoaded);
		}
		public function set dataProvider(e:Object )
		{
			//trace("开始load:",isLoaded);
			isLoaded = false;
			im.dispose();
			/*
			removeChild(im);
			im = null;
			im = new Loader  ;
			addChildAt(im,0);
			*/
			if (e.retweeted_status)
			{
				e.retweeted_status.bmiddle_pic ? im.load(e.retweeted_status.bmiddle_pic):null;
			}
			else
			{
				e.bmiddle_pic ? im.load(e.bmiddle_pic):null;
			}
		}
		public function dispose()
		{

			im.dispose();
			im = null;
		}
	}

}