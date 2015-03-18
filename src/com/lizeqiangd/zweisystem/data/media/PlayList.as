package com.lizeqiangd.zweisystem.data.media
{
	public class PlayList
	{
		public var name:String = "";
		public var type:String = "";
		public var creator:String = "";
		//public var createDate:String="";
		public var coverUrl:String = "";
		public var id:int = 0;
		public var content:Array;
		public function PlayList()
		{
			content = new Array () ;
		}
	}
}