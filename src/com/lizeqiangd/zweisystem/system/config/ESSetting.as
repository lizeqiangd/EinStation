package com.lizeqiangd.zweisystem.system.config
{
	
	/**
	 * 全系统具体数值设定全部在这里
	 * @author lizeqiangd
	 */
	public class ESSetting
	{
		///for video display
		public static const VideoDisplayDefaultBufferTime:Number = 1
		
		///for weibo application [EinStation]
		public static const SinaWeiboConsumerKey:String = "284059874";
		public static const SinaWeiboConsumerSecret:String = "c05b51e964706373ccbab293626e2382";
		public static const SinaWeiboProxyPHP:String = "proxy/proxy.php";
		
		///for anime windows
		public static const AnimeWindowsDefaultOpeningAnimation:String = "fade_in"
		public static const AnimeWindowsDefaultClosingAnimation:String = "fade_out_and_blur"
		
		///for system config sharedobject app name
		public static const SystemConfigApplicationName:String = "com.lizeqiangd.zweisystem"
		
		///for animation manager
		public static const AnimationManagerTime:Number = 0.7
		
		///for postion utility
		public static const PositionUtilityOffsetY:uint = 0
		public static const PositionUtilityOffsetX:uint = 0
		
		///for BaseWindows scale		
		public static const BaseWindowsRetinaScaleLimit:Number = 140
		public static const BaseWindowsRetinaScale:Number = 2
		public static const BaseWindowsDefaultScale:Number = 1
		
		///for BaseUiControlMode
		public static const BaseButtonClickMovieClipName:String = "mc_button"
		public static const BaseButtonControlMouseMode:String = "mouse"
		public static const BaseButtonControlTouchMode:String = "touch"
		
		///for layer manager
		public static const LayerManagerBackground:String = "backgroundLayer"
		public static const LayerManagerApplication:String = "applicationLayer";
		public static const LayerManagerFloat:String = "floatLayer";
		public static const LayerManagerAnimation:String = "animationLayer";
		public static const LayerManagerMessage:String = "messageLayer";
		public static const LayerManagerTop:String = "topLayer";
		
		///for host manager
		public static const HostManagerAmfphpLoadTime:uint = 600
		
		///for login manager 
		public static const LoginManagerLocalDataName:String = "LoginManagerData"
		
		///for NavigationApplicationMenu		
		public static const NavigationApplicationMenuIconDistance:int = 10
		public static const NavigationApplicationMenuIconHeightCount:int = 3
		public static const NavigationApplicationMenuOpenApplicationDelay:int = 1200
	}

}