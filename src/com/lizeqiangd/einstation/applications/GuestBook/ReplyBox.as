package com.lizeqiangd.einstation.applications.GuestBook
{
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.config.ESAmfphp;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author lizeqiangd
	 */
	public class ReplyBox extends Sprite
	{
		private var _commentId:String;
		public var tx_reply:TextField
		
		public function ReplyBox()
		{
			tx_reply.text = ""
			btn_reply.addEventListener(UnitEvent.CLICK, onReply)
			btn_delete.addEventListener(UnitEvent.CLICK, onDelete)
		}
		
		private function onDelete(e:UnitEvent):void
		{
			Message.GuestbooxCommentDelete("你确定要删除这个留言吗?", onDeleteComfirm)
		}
		
		private function onDeleteComfirm()
		{
			btn_delete.title = "删除中"
			btn_reply.title = "删除中"
			btn_delete.enable = false
			btn_reply.enable = false
			var o:Array = new Array
			o["username"] = LoginManager.getUsername
			o["password"] = LoginManager.getPassword
			o["deleteId"] = _commentId
			AMFPHP.callResult(ESAmfphp.Guestbook_deleteComment, onDeleteResult, o);
		}
		
		private function onDeleteResult(e:Object):void
		{
			btn_delete.title = "删除完成"
			btn_reply.title = "删除中"
			Message.GuestbooxCommentDeleteOk()
			this.dispatchEvent(new UnitEvent(UnitEvent.DELETE))
			//Message.AMFPHPMessage(e.state+"  "+e.message)
		}
		
		public function set commentId(e:String)
		{
			_commentId = e
			btn_reply.enable = true
			btn_reply.title = "回复"
			btn_delete.title = "删除"
			btn_delete.enable = true
		}
		
		private function onReply(e:UnitEvent)
		{
			var o:Array = new Array
			o["username"] = LoginManager.getUsername
			o["password"] = LoginManager.getPassword
			o["commentId"] = _commentId
			o["reply"] = tx_reply.text
			AMFPHP.callResult(ESAmfphp.Guestbook_replyComment, onComplete, o)
			btn_reply.enable = false
			btn_reply.title = "发送中"
		}
		
		private function onComplete(e:Object):void
		{
			btn_reply.title = "发送完成"			
			Message.AMFPHPMessage(e.state+"  "+e.message)
		}	
	}

}