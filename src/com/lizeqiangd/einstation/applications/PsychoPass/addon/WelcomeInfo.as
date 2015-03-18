package com.zweisystem.applications.PsychoPass.addon
{
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class WelcomeInfo extends Sprite
	{

		public function WelcomeInfo()
		{
			lb_name.title = "NAME";
			lb_id.title = "ID";
			lb_locationCode.title = "AREA";
			lb_joinDate.title = "JOINDATE";
			tx_name.text = "";
			tx_id.text = "";
			tx_locationCode.text = "";
			tx_joinDate.text = "";
			tx_title.text = "Wait..";
		}
		private var txname:String = "";
		private var txid:String = "";
		private var txlocationCode:String = "";
		private var txjoinDate:String = "";
		public function init(e:Object)
		{
			txname = e.screen_name;
			txid = e.id;
			txlocationCode = e.city;
			txjoinDate = e.created_at;
			setTimeout(anime, 500);
		}

		public function anime()
		{
			tx_title.text = "Connected.";
			tx_name.text = txname;
			tx_id.text = txid;
			tx_locationCode.text = txlocationCode;
			tx_joinDate.text = txjoinDate;
			TextAnimation.Changing(tx_name, TextAnimation.ALPHABET, 1, true);
			TextAnimation.Typing(tx_joinDate)
			TextAnimation.Changing(tx_locationCode, TextAnimation.ALPHABET, 1, true);
			TextAnimation.Changing(tx_id, TextAnimation.ALPHABET, 1, true);
			TextAnimation.Changing(tx_title, TextAnimation.ALPHABET, 1, true);
		}

	}

}