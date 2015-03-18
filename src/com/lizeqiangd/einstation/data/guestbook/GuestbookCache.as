package com.lizeqiangd.einstation.data.guestbook
{
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class GuestbookCache
	{
		private static var _comments:Vector.<CommentData>
		
		public static function cache(e:Object)
		{
			_comments = new Vector.<CommentData>
			for (var i:int = e.length-1; i > 0; i--)
			{
				var c:CommentData = new CommentData
				c.content = e[i].content+""
				c.id = e[i].id+""
				c.email = e[i].email+""
				c.name = e[i].name+""
				c.time = e[i].time+""
				c.reply  = e[i].reply
				c.isPrivate=false
				c.isPrivate = e[i].private=="1" ?  true: false;
				_comments.push(c)
			}
		}
		public static function get comments():Vector.<CommentData> {
			return _comments
		}
	
	}

}