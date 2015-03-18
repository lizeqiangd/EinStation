package com.lizeqiangd.zweisystem.components.encode
{
	public class StringUtils
	{
		/**
		 * 检测字符串中是否存在传入的关键词 
		 * @param inputString 被检测的字符串
		 * @param keyWord 关键词
		 * @return 返回检测的结果,true表示为有
		 * 
		 */
		public static function checkKeyWord(inputString:String, keyWord:String):Boolean
		{
			var checker:RegExp = new RegExp(keyWord);
			return checker.test(inputString);
		}

		/**
		 * 检测Email地址字符串是否正确 
		 * @param EmailStr 被检测的Email地址字符串
		 * @return 返回检测的结果,true表示正确
		 * 
		 */
		public static function checkEmailString(EmailStr:String):Boolean
		{
			var checker:RegExp = /^[a-z0-9][-_\.a-z0-9]*\@([a-z0-9][-_a-z0-9]*\.)+[a-z]{2,6}$/;
			return checker.test(EmailStr);
		}

		/**
		 * 检测域名是否正确 
		 * @param domain 传入的域名
		 * @return 返回检测的结果,true表示正确
		 * 
		 */
		public static function checkDomain(domain:String):Boolean
		{
			var check_txt:String = domain;
			if (domain.slice(0,7) == "http://")
			{
				check_txt = domain.slice(7);
			}
			var checker:RegExp = /^[a-zA-Z]([-_a-zA-Z0-9]+\.)*[a-zA-Z]{2,6}$/;
			return checker.test(check_txt);
		}

		/**
		 * 检测URL地址的正确性 
		 * @param inputString 传入的URL字符串
		 * @return 返回检测的结果,true表示正确
		 * 
		 */
		public static function checkURL(inputString:String):Boolean
		{
			var checker:RegExp = /[a-zA-z]+\:\/\/[^\s]/;
			return checker.test(inputString);
		}

		/**
		 * 检测是否为通过HTTP协议访问的文件 
		 * @param inputString 文件的地址
		 * @return 返回检测的结果,true表示是HTTP文件
		 * 
		 */
		public static function checkHttpFile(inputString:String):Boolean
		{
			if (inputString.slice(0,7) == "http://")
			{
				return true;
			}
			return false;
		}

		/**
		 * 检测帐户的正确性 
		 * @param input_string 传入的帐户的字符串
		 * @return 返回检测的结果,true表示正确
		 * 
		 */
		public static function checkID(input_string:String):Boolean
		{
			var checker:RegExp = /^[a-zA-Z][a-zA-Z0-9_-]+/;
			return checker.test(input_string);
		}

		/**
		 * 检测数组中是否存在次字符串 
		 * @param KeyWord 字符串关键词
		 * @param TestArray 被检测的数组
		 * @return 返回检测的结果,true表示存在
		 * 
		 */
		public static function checkArray(KeyWord:String, TestArray:Array):Boolean
		{
			var checkResult:Boolean = false;
			for (var i:int = 0; i < TestArray.length; i++)
			{
				if (KeyWord == TestArray[i])
				{
					checkResult = true;
					break;
				}
			}
			return checkResult;
		}

		/**
		 * 获取文件的拓展命 
		 * @param fileName 文件的完整名称
		 * @return 返回文件的拓展名,当中包括"."符号
		 * 
		 */
		public static function getExtName(fileName:String):String
		{
			var CheckString:String = fileName;
			var returnExt:String = "";
			for (var i:int = 0; i<CheckString.length; i++)
			{
				if (CheckString.substr( -  i,1) == ".")
				{
					returnExt = CheckString.substr( -  i,i + 1);
					break;
				}
			}
			return returnExt;
		}

		/**
		 * 获取文件的名称,去除拓展名 
		 * @param fileName 文件的完整名称
		 * @return 返回文件的名称
		 * 
		 */
		public static function getFileName(fileName:String):String
		{
			var CheckString:String = fileName;
			var returnExt:String = "";
			for (var i:int = 0; i<CheckString.length; i++)
			{
				if (CheckString.substr( -  i,1) == ".")
				{
					returnExt = CheckString.substr(0, -  i);
					break;
				}
			}
			return returnExt;
		}

		/**
		 * 检测是否为图片 
		 * @param image_path 文件的地址
		 * @return 返回检测的地址,true表示为图片
		 * 
		 */
		public static function isImageFile(image_path:String):Boolean
		{
			switch (getExtName(image_path))
			{
				case ".jpg" :
					return true;
					break;
				case ".jpeg" :
					return true;
					break;
				case ".png" :
					return true;
					break;
				case ".gif" :
					return true;
					break;
				default :
					return false;
			}
		}

		/**
		 * 根据当前的URL地址,获得上一级的地址 
		 * @param url 当前的URL地址字符串
		 * @return 返回上一级的地址字符串
		 * 
		 */
		public static function getParentsPath(url:String):String
		{
			var CheckString:String = url;
			var return_path:String = "";
			for (var i:int = 0; i < CheckString.length; i++)
			{
				if (CheckString.substr( -  i,1) == "/")
				{
					return_path = CheckString.substr(0, -  i);
					break;
				}
			}
			return return_path;
		}

		/**
		 * 格式化Byte数据, 获得kb/mb/gb表示的数据大小表示形式 
		 * @param byte 传入的byte数据大小
		 * @return 返回格式化后的字符串
		 * 
		 */
		public static function formateBytes(byte:Number):String
		{
			var return_str:String = "";
			if (byte > 1000)
			{
				if (byte/1000 > 1000)
				{
					if (byte/1000000 > 1000)
					{
						return_str = formateNumber(String(int(byte/1000000)/1000));
						return return_str.slice(0,4) + " gb";
					}
					else
					{
						return_str = formateNumber(String(int(byte/1000)/1000));
						return return_str.slice(0,4) + " mb";
					}
				}
				else
				{
					return_str = formateNumber(String(byte/1000));
					return return_str.slice(0,4) + " kb";
				}
			}
			else
			{
				return_str = String(byte);
				return return_str.slice(0,4) + " byte";
			}
		}

		/**
		 * 返回格式化后的数字,保证只显示4个字符串
		 * @param str 格式化前的数字字符串
		 * @return 格式化后的数字字符串
		 * 
		 */
		public static function formateNumber(str:String):String
		{
			var return_str:String = str;
			if (return_str.charAt(3) == ".")
			{
				return_str = return_str.slice(0,3);
			}
			else
			{
				return_str = return_str.slice(0,4);
			}
			return return_str;
		}

		/**
		 * 裁剪掉字符串开头和结尾的空格 
		 * @param string 需要被裁剪的字符串
		 * @return 返回裁剪后的字符串
		 * 
		 */
		public static function trim(string:String):String
		{
			var reg:RegExp = /^\s*|\s*$/g;
			var str:String = string.replace(reg,"");
			return str;
		}
	}
}