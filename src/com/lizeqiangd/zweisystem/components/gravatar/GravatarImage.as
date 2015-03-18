package com.lizeqiangd.zweisystem.components.gravatar
{
	import com.adobe.crypto.MD5;
	import com.lizeqiangd.zweisystem.components.encode.StringUtils;
	
	/**
	 * 用于显示Gravatar上面的头像用的类.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * update:2014.03.30
	 */
	public class GravatarImage
	{
		public static const typeDefault:String = "default"
		public static const typeIdenticon:String = "identicon"
		public static const typeMonsterid:String = "monsterid"
		public static const typeWavatar:String = "wavatar"
		public static const rateG:String = "g"
		public static const ratePG:String = "pg"
		public static const rateR:String = "r"
		public static const rateX:String = "x"
		public static const defalutImageUrl:String = "http://www.gravatar.com/avatar/00000000000000000000000000000000"
		
		/**
		 * 通过Email获取图片地址.一切默认.
		 * @param	email
		 * @return
		 */
		public static function getImage(email:String):String
		{
			return custom(email.toLowerCase());
		}
		
		/**
		 * 自定义模式
		 * @param	email  邮箱地址
		 * @param	size 显示的大小 默认是80
		 * @param	rate 显示的头像所属级别,默认是g
		 * @param	type  这是什么鬼???
		 * @return 返回图片地址.
		 */
		public static function custom(email:String, size:Number = 80, rate:String = "g", type:String = "default"):String
		{
			if (StringUtils.checkEmailString(email))
			{
				return "http://www.gravatar.com/avatar/" + MD5.hash(email).toString() + "?" + "size=" + size + "&amp;rating=" + rate + "&amp;d=" + type;
			}
			return defalutImageUrl
		}
	
	}

}