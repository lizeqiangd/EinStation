package
{
	import com.lizeqiangd.einstation.applications.WorkAssistant.ServerMonitor;
	import com.lizeqiangd.zweisystem.abstract.active.BaseActive;
	import com.lizeqiangd.zweisystem.animations.messbox.mb_blue_excalmatory;
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
	import com.lizeqiangd.zweisystem.manager.MusicManager;
	import com.lizeqiangd.zweisystem.manager.QuoteManager;
	import com.lizeqiangd.zweisystem.manager.SystemManager;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Msg;
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
		public static const version:String = "Version:4.0[20150318]";
		
		public function Main()
		{
			if (stage)
				initComponents();
			else
				addEventListener(Event.ADDED_TO_STAGE, initComponents);
		}
		
		/**
		 * 所有需要的组件加载
		 * @param	e
		 */
		private function initComponents(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			StageProxy.init(this.stage)
			db.initConsole(this.stage)
			db.hideConsole();
			TextAnimation.init(this.stage)
			PositionUtility.center(db);
			loadConfig();
		}
		
		/**
		 * 配置文件加载.
		 * 1.本地写死
		 * 2.xml或者json文件
		 * 3.保存在服务上用api调用.
		 */
		private function loadConfig():void
		{
			ConfigManager.setConfigByLocal(initManagers)
		}
		
		private function initManagers():void
		{
			SystemManager.init(this.loaderInfo);
			LayerManager.init()
			MusicManager.init();
			AddOnManager.initLoaderMax()
			AddOnManager.initTweenPlugin()
			AnimationManager.init()
			new QuoteManager()
			ApplicationManager.init()
			//BackgroundManager.init();
			setTimeout(onInitCompleted,1000)
			
		}		
		private function onInitCompleted():void 
		{
			//ApplicationManager.open('com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionnaireGenerator')
			ApplicationManager.open('com.lizeqiangd.einstation.applications.WorkAssistant.WorkAssistant')
			
			AnimationManager.MaskOutStage()
			
			//Msg.info('testtewsettetwetwerwerwerwerwerwersdfasfdgbsdghsdh')
			
			//var active:ServerMonitor = new ServerMonitor
						//addChild(active)
			//var test:BaseActive = new BaseActive
			//test.setFrameColor=(0xff0000)
			//addChild(test)
			//test.config(400, 200)
			//test.createFrame()
			//
			//var test2:BaseActive = new BaseActive
			////test2.setFrameColor=(0xffff00)
			//addChild(test2)
			//test2.x=420
			//test2.config(200, 200)
			//test2.createFrame()
		}
		//
		//Cc.debug("EinStation initing: ApplicationManager inited");
		//
		//Cc.debug("EinStation initing: all managers init complete!");
		//this.removeChild(this.mc_test);
		//this.mc_test = null;
		//this.removeChild(this.mc_failed);
		////Cc.debug("EinStation:........Maskout the Stage........");
		//Cc.error("**********EinStation initing complete!**********");
		//Cc.debug("************************************************");
		//this.initEinStation();
		//}
		//
		//private function initEinStation():*
		//{
		//AnimationManager.MaskOutStage();
		//Cc.visible = false;
		//if (!HostManager.SYSTEM_AVAILABLE)
		//{
		//ApplicationManager.open("SystemOperation.LoginSystem.LoginSystem");
		//Message.SystemUnavailable();
		//TitleManager.init();
		//TitleManager.MainTitle = "系统已经被锁定,请尝试登陆解锁.";
		//Cc.debug("EinStation Plugin initing: TitleManager inited");
		//BackgroundManager.init();
		//Cc.debug("EinStation Plugin initing: BackgroundManager inited");
		//this.EinStationStartComplete();
		//return;
		//}
		//switch (SystemManager.getFlashVar("app"))
		//{
		//case "": 
		//case "EinStatin": 
		//this.EinStatinMode();
		//break;
		//case "PSYCHO-PASS": 
		//Message.SystemUpdate(function():*
		//{
		//URLNavigator.open("http://einstation.sinaapp.com/2/?app=PSYCHO-PASS", true, "_self");
		//}, "由于系统升级原因,你所需要的功能[" + SystemManager.getFlashVar("app") + "]已经迁移到新的地址,是否进入?");
		//break;
		//case "Debug": 
		//this.DebugMode();
		//break;
		//default: 
		//this.DebugMode();
		//Message.SystemVarsError(SystemManager.getFlashVar("app"));
		//}
		//this.EinStationStartComplete();
		//}
		//
		//private function DebugMode():void
		//{
		//TitleManager.init();
		//TitleManager.loadTitleFormServer();
		//Cc.debug("EinStation Plugin initing: TitleManager inited");
		//NavigationManager.init();
		//Cc.debug("EinStation Plugin initing: NavigationManager inited");
		//BackgroundManager.init();
		//Cc.debug("EinStation Plugin initing: BackgroundManager inited");
		//ZweiteHorizontService.init(true);
		//Cc.debug("EinStation Plugin initing: Remote inited");
		//MusicWidgetManager.init();
		//Cc.debug("EinStation Plugin initing: MusicWidgetManager inited");
		//WeiboManager.init();
		//Cc.debug("EinStation Plugin initing: WeiboManager inited");
		//// ApplicationManager.open("com.lizeqiangd.zweisystem.applications.Weibo.MainController.WeiboMainController");
		////  ApplicationManager.open("com.lizeqiangd.zweisystem.applications.MessageChannel.ChatRoom.Standard.StandardChatRoom");
		//ApplicationManager.open("com.lizeqiangd.zweisystem.applications.MessageChannel.Lobby.Standard.StandardLobby");
		////  ApplicationManager.open("com.lizeqiangd.zweisystem.applications.SystemOperation.TestBoard.TestBoard"); 
		//}
		//
		//private function EinStatinMode():*
		//{
		//TitleManager.init();
		//TitleManager.loadTitleFormServer();
		//Cc.debug("EinStation Plugin initing: TitleManager inited");
		//NavigationManager.init();
		//Cc.debug("EinStation Plugin initing: NavigationManager inited");
		//BackgroundManager.init();
		//Cc.debug("EinStation Plugin initing: BackgroundManager inited");
		//ZweiteHorizontService.init(true);
		//Cc.debug("EinStation Plugin initing: Remote inited");
		//MusicWidgetManager.init();
		//Cc.debug("EinStation Plugin initing: MusicWidgetManager inited");
		//WeiboManager.init();
		//Cc.debug("EinStation Plugin initing: WeiboManager inited");
		//
		//SystemConfig.getSystemConfig("DefaultApplication", this.onDefaultApplicationLoadComplete);
		//SystemConfig.getSystemConfig("DefaultApplication2", this.onDefaultApplication2LoadComplete);
		//
		//SystemConfig.getSystemConfig2("NicoNicoNi", this.onNiconiconi);
		//}
		//
		//private function onDefaultApplicationLoadComplete(param1:Object):*
		//{
		//if (param1.value)
		//{
		//ApplicationManager.open(param1.value);
		//}
		//}
		//
		//private function onDefaultApplication2LoadComplete(param1:Object):*
		//{
		//if (param1.value)
		//{
		//ApplicationManager.open(param1.value);
		//}
		//}
		//
		//private function onNiconiconi(param1:Object):*
		//{
		//if (param1.enable)
		//{
		//Message.SystemConfirm("你准备好放弃治疗了吗?(注意音响大小)妮可妮可妮~妮可妮可妮~~妮可妮可妮~~~", function():*
		//{
		//TitleManager.MainTitle = param1.title;
		//BackgroundManager.remote(param1.url,param1.description);
		//});
		//}
		//}
		//
		//private function EinStationStartComplete():*
		//{
		//this.failedTimer.stop();
		//this.failedTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.EinStationStartError);
		//this.failedTimer = null;
		//try
		//{
		//removeChild(this.mc_failed);
		//}
		//catch (e:*)
		//{
		//}
		//this.mc_failed = null;
		//StageProxy.updateStageSize();
		//}
		//
		//private function EinStationStartError(param1:*):*
		//{
		//addChild(this.mc_failed);
		//this.mc_failed.alpha = 1;
		//}
	
	}

}