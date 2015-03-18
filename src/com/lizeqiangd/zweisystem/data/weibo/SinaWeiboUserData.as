package com.lizeqiangd.zweisystem.data.weibo
{
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class SinaWeiboUserData
	{
		public var id:String 
		public var province:String 
		public var city:String 
		public var screen_name:String 
		public var location:String 
		public var created_at:String 
		public var gender:String 
		public var avatar_large:String 
		public var profile_image_url:String 
		public function SinaWeiboUserData(e:Object)
		{
			id=e.idstr
			province=e.province
			city=e.city
			screen_name=e.screen_name
			location=e.location
			created_at=e.created_at
			gender=e.gender
			avatar_large = e.avatar_large
			profile_image_url=e.profile_image_url
		}
	
	}

}