package com.lizeqiangd.einstation.applications.GuestBook
{
	
	import com.lizeqiangd.einstation.data.guestbook.CommentData;
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import flash.events.MouseEvent;
	
	/**
	 * Active本类与commentbox耦合性极强..千万要注意.
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	
	public class Comment extends BaseActive implements iActive
	{
		public var replaybox:ReplyBox
		private var cb:CommentBox
		
		public function Comment()
		{
			super("Comment")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			tx_comment.text = ""
			replaybox.visible = false
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			replaybox.visible = false
			onUserChange()
			addUiListener()
			if (cb.comment.reply)
			{
				getAcitveManager.movein("Reply", LoginManager.isAdministrator ? "reply2" : "reply", "down")
				getAcitveManager.Active("Reply").activeMessage(cb.comment.reply)
			}
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			if (cb.comment.reply)
			{
				getAcitveManager.moveout("Reply", "down")
			}
			replaybox.visible = false
			removeUiListener()
		}
		
		private function addUiListener()
		{
			replaybox.addEventListener(UnitEvent.DELETE, onDelete)
			btn_close.addEventListener(MouseEvent.CLICK, onCloseClick)
			LoginManager.addLoginFunction(onUserChange)
		}
		
		private function onDelete(e:UnitEvent):void
		{
			host.applicationMessage({type: "deleteComment"})
			onCloseClick(null)
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			AnimationManager.fade_out(replaybox)
			host.applicationMessage( { type: "closeComment" } )
			
			cb.isSelected=false
			cb.onDataIn()
			cb.startAnime()
		}
		
		private function onUserChange():void
		{
			if (LoginManager.isAdministrator)
			{
				AnimationManager.fade(replaybox, 1)
			}
			else
			{
				AnimationManager.fade(replaybox, 0)
			}
		}
		
		private function removeUiListener()
		{
			LoginManager.removeLoginFunction(onUserChange)
			btn_close.removeEventListener(MouseEvent.CLICK, onCloseClick)
		}
		
		public function activeMessage(msg:Object)
		{
			cb = msg as CommentBox
			cb.isSelected=true
			cb.content = "Email:\n" + cb.comment.email
			tx_comment.text = cb.comment.content
			TextAnimation.Typing(tx_comment)
			replaybox.commentId = cb.comment.id
		
		}
		
		public function dispose()
		{
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}