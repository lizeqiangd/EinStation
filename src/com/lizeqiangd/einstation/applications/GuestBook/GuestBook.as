package com.lizeqiangd.einstation.applications.GuestBook
{
	
	import com.greensock.TweenLite;
	import com.lizeqiangd.einstation.data.guestbook.GuestbookCache;
	import com.lizeqiangd.zweisystem.abstract.active.ActiveManager;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.numericstepper.ns_general;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import com.lizeqiangd.zweisystem.system.config.ESAmfphp;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * GuestBook 3.0系统 新界面..用了一晚上时间去修改..
	 * 2014.05.16 完成新界面.好看不少 动画效果多多多
	 * @author lizeqiangd
	 */
	
	public class GuestBook extends TitleWindows implements iApplication
	{
		private var am:ActiveManager
		private var ssn:SystemStatusNotification
		private var temp_commentbox_index:int
		private var temp_commentbox:CommentBox
		
		public var ns_list:ns_general
		public var CommentBox1:CommentBox
		public var CommentBox2:CommentBox
		public var CommentBox3:CommentBox
		public var CommentBox4:CommentBox
		
		public function GuestBook()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - GuestBook -";
			this.setApplicationName = "GuestBook";
			this.setApplicationVersion = "3.0"
			this.addEventListener(ApplicationEvent.INIT, init);
			ssn = new SystemStatusNotification
			ssn.init(300, 480)
			ssn.y = 20
			addChild(ssn)
			setChildIndex(active_Comment, numChildren - 1)
			setChildIndex(active_Publish, numChildren - 1)
			setChildIndex(active_Reply, numChildren - 1)
			am = new ActiveManager(this)
			am.registerPointByActive(active_Comment, "comment")
			am.registerPointByActive(active_Publish, "publish")
			am.registerPointByActive(active_Reply, "reply")
			am.registerPointByXY(10, 360, "reply2")
		}
		
		public function init(e:ApplicationEvent)
		{
			
			onReflush()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function onReflush(e:MouseEvent = null):void
		{
			ssn.anime("state.ssn_loading", "读取信息中")
			AMFPHP.callResult(ESAmfphp.Guestbook_getAllComment, onLoadingListComplete)
		}
		
		private function onLoadingListComplete(e:Object):void
		{
			GuestbookCache.cache(e)
			ns_list.init(4, GuestbookCache.comments.length)
			ssn.clean()
		
		}
		
		private function addApplicationListener()
		{
			btn_publish.addEventListener(UnitEvent.CLICK, onPublishClick)
			btn_reflush.addEventListener(MouseEvent.CLICK, onReflush)
			ns_list.addEventListener(UnitEvent.CHANGE, onNSChange)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			CommentBox1.addEventListener(UnitEvent.CLICK, onCommentBoxClick);
			CommentBox2.addEventListener(UnitEvent.CLICK, onCommentBoxClick);
			CommentBox3.addEventListener(UnitEvent.CLICK, onCommentBoxClick);
			CommentBox4.addEventListener(UnitEvent.CLICK, onCommentBoxClick)
		}
		
		private function onCommentBoxClick(e:UnitEvent):void
		{
			if (temp_commentbox == e.data)
			{
				return
			}
			ssn.anime("", "")
			temp_commentbox_index = getChildIndex(e.data)
			temp_commentbox = e.data
			setChildIndex(e.data, numChildren - 1)
			am.movein("Comment", "comment", "left")
			TweenLite.to(e.data, 1, {y: 50})
			am.Active("Comment").activeMessage(e.data)
		}
		
		private function onPublishClick(e:UnitEvent):void
		{
			ssn.anime("", "")
			am.movein("Publish", "publish", "down")
		}
		
		private function recoverCommentBox()
		{
			setChildIndex(temp_commentbox, temp_commentbox_index)
			switch (temp_commentbox)
			{
				case CommentBox1: 
					TweenLite.to(CommentBox1, 0.8, {y: 30})
					break;
				case CommentBox2: 
					TweenLite.to(CommentBox2, 0.8, {y: 140})
					break;
				case CommentBox3: 
					TweenLite.to(CommentBox3, 0.8, {y: 250})
					break;
				case CommentBox4: 
					TweenLite.to(CommentBox4, 0.8, {y: 360})
					break;
				default: 
			}
			temp_commentbox = null
		}
		
		private function onNSChange(e:Event):void
		{
			CommentBox2.visible = false
			CommentBox3.visible = false
			CommentBox4.visible = false
			var comment_left:int = GuestbookCache.comments.length - ns_list.getNow
			comment_left > 5 ? comment_left = 5 : 0;
			switch (comment_left)
			{
				case 5: 
					CommentBox4.visible = true
					CommentBox4.dataProvider = GuestbookCache.comments[ns_list.getNow + 3]
				case 4: 
					CommentBox3.visible = true
					CommentBox3.dataProvider = GuestbookCache.comments[ns_list.getNow + 2]
				case 3: 
					CommentBox2.visible = true
					CommentBox2.dataProvider = GuestbookCache.comments[ns_list.getNow + 1]
				case 2: 
					CommentBox1.dataProvider = GuestbookCache.comments[ns_list.getNow]
					break;
				default: 
			}
		
		}
		
		private function removeApplicationListener()
		{
			btn_publish.removeEventListener(UnitEvent.CLICK, onPublishClick)
			btn_reflush.removeEventListener(MouseEvent.CLICK, onReflush)
			ns_list.removeEventListener(UnitEvent.CHANGE, onNSChange)
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			CommentBox1.removeEventListener(UnitEvent.CLICK, onCommentBoxClick);
			CommentBox2.removeEventListener(UnitEvent.CLICK, onCommentBoxClick);
			CommentBox3.removeEventListener(UnitEvent.CLICK, onCommentBoxClick);
			CommentBox4.removeEventListener(UnitEvent.CLICK, onCommentBoxClick)
			this.removeEventListener(ApplicationEvent.INIT, init);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeApplicationListener();
		
		}
		
		public function dispose()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e.type)
			{
				case "closeComment": 
					am.moveout("Comment", "right")
					ssn.clean()
					recoverCommentBox()
					break;
				case "deleteComment": 
					onReflush()
					break
				case "closePublish": 
					onReflush()
					break
				default: 
					break;
			}
		}
	}

}