package com.lizeqiangd.zweisystem.data.application
{
	
	/**
	 * 应用管理器，用于所有应用的快捷方式和名称的管理。
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * 2013.06.30 转而使用HostManager管理
	 * 2014.04.02 我觉得应该把所有应用程序都丢在网络数据库中.不知道这样想好不好.
	 * 2014.05.11 新的xml完成.
	 */
	public class ApplicationExplorer
	{
		private static var system:Vector.<Application>
		private static var test:Vector.<Application>
		private static var normal:Vector.<Application>
		private static var app:Application
		
		public static var tempApplicationVector:Vector.<Application>
		public static function init(applications:XML):void
		{
			system = new Vector.<Application>;
			test = new Vector.<Application>;
			normal = new Vector.<Application>;
			for (var i:int = 0; i < 50; i++)
			{
				if (!applications.app[i])
				{
					break
				}
				app = new Application;
				app.name = applications.app[i].name
				app.style = applications.app[i].style
				app.path = applications.app[i].path
				app.type = applications.app[i].type
				
				//app.Address = applications.application[i].address
				//app.ChineseName = String(applications.application[i].name.Chinese)
				//app.EnglishName = String(applications.application[i].name.English)
				//app.Color = applications.application[i].color
				if (app.type == 1)
				{
					system.push(app);
				}
				if (app.type == 2)
				{
					normal.push(app);
				}
				if (app.type == 3)
				{
					test.push(app);
				}
			}
		}
		
		public static function get SystemApplication():Vector.<Application>
		{
			return system
		}
		
		public static function get TestApplication():Vector.<Application>
		{
			return test
		}
		
		public static function get NormalApplication():Vector.<Application>
		{
			return normal
		}
	
	}

}