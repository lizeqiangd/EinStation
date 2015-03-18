package com.lizeqiangd.zweisystem.data.media
{
	
	public class Music
	{
		public var name:String = "";
		public var artist:String = "";
		public var album:String = "";
		public var coverUrl:String = "";
		public var musicUrl:String = "";
		public var id:int = 0;
		
		public function Music(_name:String = "", _musicUrl:String = "", _artist:String = "", _album:String = "", _coverUrl:String = "", _id:int = 0)
		{
			name = _name
			artist = _artist
			coverUrl = _coverUrl
			album = _album
			musicUrl = _musicUrl
			id = _id		
		}
	}
}