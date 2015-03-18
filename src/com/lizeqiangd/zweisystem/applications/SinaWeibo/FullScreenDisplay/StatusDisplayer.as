package com.zweisystem.applications.SinaWeibo.FullScreenDisplay
{
	import flash.display.Sprite;
	import com.zweisystem.animations.texteffect.TextAnimation;
	public class StatusDisplayer extends Sprite 
	{
		private var _dataProvider:Object;
		private var _content:String = "";
		private var _statusePosterName:String = "";
		private var _statuseTime:String = "";
		private var _id:String = "";
		public function StatusDisplayer()
		{
			init();
		}
		public function set dataProvider(o:* )
		{
			_dataProvider = null;
			_dataProvider = new Object  ;
			_dataProvider = o;
			_id = o.id;
			_statusePosterName = o.user.screen_name;
			_content = o.text;
			_statuseTime = o.created_at;

		}
		public function init()
		{
			this.tx_name.text = _statusePosterName;
			this.tx_text.text = "                                           " + _content;
			this.tx_info.text = _statuseTime;
			anime();
		}
		public function anime()
		{
			TextAnimation.Changing(tx_name,TextAnimation.CHINESE+TextAnimation.ALPHABET,1,true);
			TextAnimation.Changing(tx_info,TextAnimation.ALPHABET+TextAnimation.NUMBER ,1,true);
			TextAnimation.Changing(tx_text,TextAnimation.CHINESE,1,false,43);
		}
	}

}