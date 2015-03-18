package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.components.CompareClass;
	import com.lizeqiangd.zweisystem.components.debug.db;
	//import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.FullWindows;
	import com.lizeqiangd.zweisystem.data.application.ApplicationConfig;
	import com.lizeqiangd.zweisystem.system.applications.assest.AssestApplication;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	public class ApplicationManager
	{
		/**
		 * 本管理器只管理应用不负责显示。因此非窗口化的应用请使用LayerManager打开并管理。
		 * 所有程序都是iApplication的实现
		 * @author:Lizeqiangd
		 * 2012.12.16:更改为iApplication，支持是否多重开启
		 * 2013.01.27:检测FullWindows
		 * 2013.01.29:全面改为LayerManager,简化AssestApplication初始化过程,减少应用没有被管理器管理的泄露问题。
		 * 2013.02.10:获得FullWindows的管理权，简化代码。
		 * 2014.04.05:更改逻辑增加注释.
		 * 2014.05.10:不需要前置应用地址,因为大家都不同.
		 */
		private static var applications:Vector.<ApplicationConfig>;
		private static var inited:Boolean = false
		private static var isFullWindowApplicationExisted:Boolean = false
		
		public static function init()
		{
			if (inited)
			{
				return
			}
			inited = true
			applications = new Vector.<ApplicationConfig>;
		}
		
		/**
		 * 打开外部swf文件.目前有疑问的方法..用途太少....
		 * @param	app_url
		 * @param	app_name
		 * @param	app_title
		 * @return
		 */
		public static function openAssestApplication(app_url:String, app_name:String, app_title:String = ""):iApplication
		{
			/*
			   if (!inited)
			   {
			   db.log("ApplicationManager.openAssestApplication:not init")
			   return null
			   }
			
			   if (!findApplicationMutiExistEnableByName(app_name))
			   {
			   db.log("ApplicationManager.openAssestApplication:AssestApplications exist:", app_name)
			   Message.ApplicationExisted(app_name)
			   return null;
			   }
			   var o:AssestApplication = LayerManager.createPopUp(AssestApplication)
			   EventDispatcher(o).addEventListener(ApplicationEvent.CLOSE, deleteApplication, false, 0, true);
			   o.load(app_url, app_name, app_title);
			   var application_config:ApplicationConfig = new ApplicationConfig
			   application_config.content = iApplication(o);
			   application_config.address = app_url;
			   application_config.appname = app_name;
			   application_config.self = o;
			   applications.push(application_config);
			   return iApplication(o);
			 */
			return null
		}
		
		/**
		 * 打开一个程序,需要应用程序路径,可以选择绝对路径,也可以快捷方式打开.
		 * @param	ApplicatoinAddress
		 * @param	Absolute
		 * @return
		 */
		public static function open(ApplicatoinAddress:String):iApplication
		{
			if (!inited)
			{
				db.log("ApplicationManager.open:not init")
				return null
			}
			//ApplicatoinAddress = Absolute ? ApplicatoinAddress : ApplicationManager.ApplicationPrefix + ApplicatoinAddress;
			if (!findApplicationMutiExistEnableByAddress(ApplicatoinAddress))
			{
				//trace("程序：" + ApplicatoinAddress + "不允许多重存在");
				db.log("ApplicationManager.open:Application address existed.[" + ApplicatoinAddress + "]")
				//findApplicationMutiExistEnableByAddress(app_Address);
				//Message.ApplicationExisted(ApplicatoinAddress)
				return null;
			}
			
			try
			{
				//trace("广播：ApplicationManager正在打开:" + ApplicatoinAddress);
				var ClassReference:Class = getDefinitionByName(ApplicatoinAddress) as Class;
				//检测是否为全屏程序
				if (CompareClass.isSuperClass(ClassReference, FullWindows) && (isFullWindowApplicationExisted))
				{
					//Message.ApplicationFullWindowsExisted(ClassReference)
					db.log("ApplicationManager.open:FullWindowApplication existed.[" + ApplicatoinAddress + "],can not open another one.")
					return null
				}
				db.log("ApplicationManager.open: opining[" + ClassReference + "]");
				var o:* = ClassReference(LayerManager.createPopUp(ClassReference));
			}
			catch (e:*)
			{
				trace(e);
				trace("广播：ApplicationManager打开[" + ApplicatoinAddress + "]失败");
				db.log("ApplicationManager opining[" + ApplicatoinAddress + "]Fault!,Error:" + e);
				//Message.ApplicationOpenFailed(ApplicatoinAddress);
				return null;
			}
			if (o)
			{
				if (CompareClass.isSuperClass(ClassReference, FullWindows))
				{
					isFullWindowApplicationExisted = true
				}
				
				EventDispatcher(o).addEventListener(ApplicationEvent.CLOSE, deleteApplication, false, 0, true);
				var application_config:ApplicationConfig = new ApplicationConfig
				application_config.content = iApplication(o);
				application_config.address = ApplicatoinAddress;
				application_config.appname = BaseWindows(o).getApplicationName;
				application_config.self = o;
				applications.push(application_config);
				return iApplication(o);
			}
			else
			{
				trace("2次失败！！！！！！！！！！！！！！！！！！！！！！！！！！！！");
				trace("广播：ApplicationManager打开[" + ApplicatoinAddress + "]失败");
				db.log("ApplicationManager: opining[" + ApplicatoinAddress + "]Fault!");
				return null
			}
		}
		
		/**
		 * 通过应用程序名字获取应用程序本身的实例.反馈iApplication接口的程序.
		 * @param	ApplicationName
		 * @return
		 */
		public static function Application(ApplicationName:String):iApplication
		{
			if (!inited)
			{
				db.log("ApplicationManager.open:not init")
				return null
			}
			for (var i:int = 0; i < applications.length; i++)
			{
				if (applications[i].appname == ApplicationName)
				{
					return applications[i].content;
				}
			}
			db.log("ApplicationManager.open: can't find appname:" + ApplicationName);
			return null;
		}
		
		/**
		 * 通过应用路径搜索应用本身
		 * @param	ApplicationName
		 * @return
		 */
		public static function ApplicationByPath(ApplicationPath:String):iApplication
		{
			if (!inited)
			{
				db.log("ApplicationManager.open:not init")
				return null
			}
			for (var i:int = 0; i < applications.length; i++)
			{
				if (applications[i].address == ApplicationPath)
				{
					return applications[i].content;
				}
			}
			db.log("ApplicationManager.open: can't find app path:" + ApplicationPath);
			return null;
		}
		
		///删除应用从管理器中,同时移除侦听器.如果是全屏程序则处理全屏细节.
		private static function deleteApplication(e:ApplicationEvent)
		{
			for (var i:int = 0; i < applications.length; i++)
			{
				if (BaseWindows(applications[i].content).getApplicationName == e.target.getApplicationName)
				{
					e.target.removeEventListener(ApplicationEvent.CLOSE, deleteApplication);
					if (CompareClass.isSuperClass(e.target, FullWindows))
					{
						isFullWindowApplicationExisted = false
					}
					applications.splice(i, 1);
					return;
				}
			}
		}
		
		///获取应用程序管理器的Array.(很少用的方法..根本就是没用嘛)
		public static function get getApplicationArray():Vector.<ApplicationConfig>
		{
			return applications
		}
		
		///通过程序地址寻找 程序是否允许多重存在.
		private static function findApplicationMutiExistEnableByAddress(ApplicationAddress:String):Boolean
		{
			for (var i:int = 0; i < applications.length; i++)
			{
				if (applications[i].address == ApplicationAddress)
				{
					return BaseWindows(applications[i].content).getMutiExistEnable;
				}
			}
			return true;
		}
		
		///通过程序名 寻找程序是否允许多重存在.
		private static function findApplicationMutiExistEnableByName(ApplicationName:String):Boolean
		{
			for (var i:int = 0; i < applications.length; i++)
			{
				if (applications[i].appname == ApplicationName)
				{
					return BaseWindows(applications[i].content).getMutiExistEnable;
				}
			}
			return true;
		}
	}
}