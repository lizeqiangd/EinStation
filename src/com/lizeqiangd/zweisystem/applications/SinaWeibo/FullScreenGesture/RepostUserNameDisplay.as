package com.zweisystem.applications.SinaWeibo.FullScreenGesture
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.managers.AnimationManager;

	public class RepostUserNameDisplay extends MovieClip
	{

		public var tx_username:TextField;
		public var mc_icon:UserIconDisplay;
		public var mc_frame:MovieClip;
		public function set dataProvider(e:Object )
		{

			tx_username.text = e.user.screen_name;
			mc_frame.width = tx_username.textWidth// - 40;
			mc_icon.load(e.user.avatar_large);
			mc_icon.visible = false;init()
		}
		public function init()
		{
			AnimationManager.fade_in(mc_icon);
		TextAnimation.Typing(tx_username)
		}
		public function dispose()
		{
			mc_icon.dispose();
		}
	}

}