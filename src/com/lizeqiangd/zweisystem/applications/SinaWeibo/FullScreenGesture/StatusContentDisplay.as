package com.zweisystem.applications.SinaWeibo.FullScreenGesture
{

	import flash.display.MovieClip;
	import com.zweisystem.animations.texteffect.TextAnimation;

	public class StatusContentDisplay extends MovieClip
	{
		public function set dataProvider(e:Object )
		{
			tx_content.text = e.text;init()
		}
		public function init()
		{
		TextAnimation.Typing(tx_content)
		//	TextAnimation.Changing(tx_content,TextAnimation.CHINESE+TextAnimation.ALPHABET+TextAnimation.NUMBER,2);
		}
		public function dispose()
		{
		}
	}

}