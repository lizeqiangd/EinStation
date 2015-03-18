package com.zweisystem.applications.SinaWeibo.FullScreenDisplay
{
	import com.sina.microblog.data.*;
	import com.zweisystem.animations.texteffect.TextAnimation;
	import flash.display.Sprite;

	public class RepostDisplayer extends Sprite 
	{
		private var _dataProvider:Object;
		private var _retweetedContent:String = "该条微博为非转发微博";
		private var _retweetedPosterUser:String = "";
		private var _content:String = "";
		private var _statusePosterName:String = "";
		private var _statuseTime:String = "";
		private var _id:String = "";
		public function RepostDisplayer()
		{
			init();
		}
		public function set dataProvider(o:* )
		{
			try
			{
				_dataProvider = null;
				_dataProvider = new Object  ;
				_dataProvider = o;
				_id = o.id;
				_statusePosterName = o.user.screen_name;
				_content = o.text;
				_statuseTime = o.created_at;
				if (o.retweeted_status)
				{
					_retweetedPosterUser = o.retweeted_status.user.screen_name;
					_retweetedContent = o.retweeted_status.text;
				}
			}
			catch (e: * )
			{
				trace("没错 出现bug了");
			}
		}
		public function init()
		{
			this.tx_repostName.text = _retweetedPosterUser;
			this.tx_name.text = _statusePosterName;
			this.tx_text.text = "                                           " + _content;
			this.tx_repost.text = _retweetedContent;
			this.tx_info.text = _statuseTime;
			anime();
		}
		public function anime()
		{
			TextAnimation.Changing(tx_text,TextAnimation.CHINESE,1,true,43);
			TextAnimation.Changing(tx_repost,TextAnimation.CHINESE,1);
			TextAnimation.Changing(tx_name,TextAnimation.CHINESE+TextAnimation.ALPHABET,1,true);
			TextAnimation.Changing(tx_repostName,TextAnimation.CHINESE+TextAnimation.ALPHABET,1,true);
			TextAnimation.Changing(tx_info,TextAnimation.ALPHABET+TextAnimation.NUMBER ,1);


		}

	}

}