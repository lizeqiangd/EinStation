package com.lizeqiangd.einstation.applications.GuestBook
{
	import com.lizeqiangd.einstation.data.guestbook.CommentData;
	import com.lizeqiangd.zweisystem.components.gravatar.GravatarImage;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * 留言板的模块 CommentBox
	 * 2014.05.16
	 * @author lizeqiangd
	 */
	public class CommentBox extends Sprite
	{
		public var tx_content:TextField
		public var tx_date:TextField
		public var tx_name:TextField
		
		public var im:ImageDisplay
		public var comment:CommentData
		public var isSelected:Boolean = false
		
		public function CommentBox()
		{
			tx_content.text = ""
			tx_date.text = ""
			tx_name.text = ""
			im = new ImageDisplay()
			im.configProportionalOutside(80, 100, true)
			addChildAt(im, 0)
			addEventListener(MouseEvent.CLICK, onClickHandle, false, 0, true)
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			if (this.comment.isPrivate && !LoginManager.isAdministrator)
			{
				return
			}
			this.dispatchEvent(new UnitEvent(UnitEvent.CLICK, this))
		}
		
		public function set content(e:String)
		{
			tx_content.text = e
			TextAnimation.Typing(tx_content)
		}
		
		public function set dataProvider(e:CommentData)
		{
			this.comment = e
			if (this.comment.email == EinStation._CreatorEmail)
			{
				AnimationManager.changeColor(mc_frame, "lightblue")
				AnimationManager.changeColor(tx_name, "lightblue")
				AnimationManager.changeColor(tx_date, "lightblue")
				AnimationManager.changeColor(tx_content, "lightblue")
			}
			else
			{
				AnimationManager.changeColor(mc_frame, "orange")
				AnimationManager.changeColor(tx_name, "orange")
				AnimationManager.changeColor(tx_date, "orange")
				AnimationManager.changeColor(tx_content, "orange")
			}
			btn_reply.visible = this.comment.reply ? true : false
			onDataIn()
			startAnime()
		}
		
		public function startAnime():void
		{
			TextAnimation.Typing(tx_content)
			TextAnimation.Changing(tx_date, TextAnimation.NUMBER)
			TextAnimation.Changing(tx_name, TextAnimation.CHINESE + TextAnimation.ALPHABET)
		}
		
		public function onDataIn()
		{
			tx_content.text = comment.isPrivate ? "-------Administrator only-------" : comment.content
			tx_date.text = comment.time
			tx_name.text = comment.name
			im.load(GravatarImage.getImage(comment.email))
		}
	}
}