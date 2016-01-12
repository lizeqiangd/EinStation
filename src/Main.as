package
{
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.net.PHPAPI;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Msg;
	import com.lizeqiangd.zweisystem.components.debug.db;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.manager.AddOnManager;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.manager.ConfigManager;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.manager.QuoteManager;
	import com.lizeqiangd.zweisystem.manager.SystemManager;
	import com.lizeqiangd.zweitehorizont.events.ZweiteHorizontServerEvent;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizontServer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class Main extends Sprite
	{
		public static const _Tips:String = "您好，如果有幸被您看到了这行字，证明你对我的作品有兴趣。谢谢您，本文件没有加密也没有混淆。有空联系我的Email哦。";
		public static const _CreatorEmail:String = "lizeqiangd@gmail.com";
		public static const _Creator:String = "Lizeqiangd";
		public static const _CreatorBlog:String = "http://acgs.me";
		public static const version:String = "Version:4.3[20160111]";
		
		private var tf:la_general;
		
		public function Main()
		{
			if (stage)
				initComponents();
			else
				addEventListener(Event.ADDED_TO_STAGE, initComponents);
			
			CONFIG::DEBUGMODE
			{
				trace('debug mode on')
			}
		}
		
		/**
		 * 所有需要的组件加载
		 * @param	e
		 */
		private function initComponents(e:Event = null):void
		{
			tf = new la_general
			this.addChild(tf)
			tf.text = '系统加载中,请等待.'
			//初始化舞台
			removeEventListener(Event.ADDED_TO_STAGE, init);
			StageProxy.init(this.stage)
			//初始化console
			db.initConsole(this.stage)
			db.hideConsole();
			//文字动画库
			TextAnimation.init(this.stage)
			//相对位置库
			PositionUtility.center(db);
			//全局api地址.			
			PHPAPI.getInstance.setGatewayUrl('http://utils.lizeqiangd.com/EinStation/gateway.php')
			//加载配置信息.		
			loadConfig();
		}
		
		/**
		 * 配置文件加载.
		 * 1.本地写死
		 * 2.json文件
		 * 3.保存在服务上用api调用.
		 */
		private function loadConfig():void
		{
			var config_data:Object = {};
			//ConfigManager.setConfigByJSON('http://utils.lizeqiangd.com/EinStation/gateway.php', initManagers)
			ConfigManager.setConfigByObject(config_data, initManagers);
		}
		
		private function initManagers():void
		{
			//加载用于跳转的信息.有什么方便的方法呢/
			SystemManager.init(this.loaderInfo);
			LayerManager.init();
			AddOnManager.initLoaderMax();
			AddOnManager.initTweenPlugin();
			AnimationManager.init();
			ApplicationManager.init();
			QuoteManager.init();
			BackgroundManager.init();
			
			//AnimationManager.GlobalAnimation('', '系统加载完成,启动中....');
			
			removeChild(tf);
			tf = null;
			setTimeout(onInitCompleted, 2000);
		}
		
		private function onInitCompleted():void
		{
			AnimationManager.GlobalAnimationClose();
			StageProxy.enableRightClick(false);
		
			Msg.info('EinStation4 inited.')
		}
	
	}

}