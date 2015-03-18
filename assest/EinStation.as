package
{
	import com.lizeqiangd.zweisystem.system.platform.WebClient;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import com.junkbyte.console.Cc;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.applications.title.TitleManager;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.components.URLNavigator;
	import com.lizeqiangd.zweisystem.system.applications.navigation.NavigationManager;
	import com.lizeqiangd.zweisystem.system.applications.zweitehorizontwidget.ZweiteHorizontService;
	import com.lizeqiangd.zweisystem.system.applications.musicwidget.MusicWidgetManager;
	import com.lizeqiangd.zweisystem.applications.Weibo.WeiboManager;
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.manager.*;
	import flash.events.TimerEvent;
	import com.lizeqiangd.zweisystem.system.proxy.StageProxy;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	
	/**
	 * 删除platform类.
	 * 
	 */
	public class EinStation extends Sprite
	{		
		public static const _Tips:String = "您好，如果有幸被您看到了这行字，证明你对我的作品有兴趣。谢谢您，本文件没有加密也没有混淆。有空联系我的Email哦。";		
		public static const _CreatorEmail:String = "lizeqiangd@gmail.com";		
		public static const _Creator:String = "Lizeqiangd";		
		public static const _CreatorBlog:String = "http://acgs.me";		
		public static const version:String = "Version:3.1.0[20141207][网页版]";		
		public var mc_failed:MovieClip;		
		public var mc_test:MovieClip;		
		private var failedTimer:Timer;	
		
		public function EinStation()
		{			
			this.failedTimer = new Timer(10000, 1);
			StageProxy.init(this.stage/*, StageScaleMode.NO_SCALE, StageAlign.TOP_LEFT*/);
			StageProxy.enableRightClick(false);
			AddOnManager.initCc()
			SystemManager.init(this.loaderInfo);
			Cc.debug("EinStation initing: SystemManager inited");
			this.failedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.EinStationStartError);
			this.failedTimer.start();
			Cc.debug("EinStation initing:String Up.....");
			Cc.debug("EinStation running on PC:", SystemManager.isPCSystem);
			PositionUtility.center(Cc);
			this.loadConfig();
		}
		
		private function loadConfig():*
		{
			Cc.debug("EinStation initing: HostManager init, loading configs");
			var _loc1_:* = "xml/app3.xml";
			var _loc2_:* = "amfphp/index.php";
			if (HostManager.USER_IP == "localhost")
			{
				_loc1_ = "http://einstation.sinaapp.com/xml/app3.xml?" + Math.random();
				_loc2_ = "http://einstation.sinaapp.com/amfphp/index.php";
			}
			HostManager.init(_loc2_, _loc1_, this.loadConfigComplete);
		}
		
		private function loadConfigComplete():*
		{
			Cc.debug("EinStation initing: HostManager loading configs complete!");
			
			Cc.debug("EinStation initing: ZweiSystem Managers initing");
			LoginManager.init(true);
			Cc.debug("EinStation initing: LoginManager inited");
			MusicManager.init();
			Cc.debug("EinStation Plugin initing: MusicManager inited");
			LayerManager.init();
			Cc.debug("EinStation initing: LayerManager inited");
			AnimationManager.init();
			Cc.debug("EinStation initing: AnimationManager inited");
			ApplicationManager.init();
			Cc.debug("EinStation initing: ApplicationManager inited");
			
			Cc.debug("EinStation initing: all managers init complete!");
			this.removeChild(this.mc_test);
			this.mc_test = null;
			this.removeChild(this.mc_failed);
			//Cc.debug("EinStation:........Maskout the Stage........");
			Cc.error("**********EinStation initing complete!**********");
			Cc.debug("************************************************");
			this.initEinStation();
		}
		
		private function initEinStation():*
		{
			AnimationManager.MaskOutStage();
			Cc.visible = false;
			if (!HostManager.SYSTEM_AVAILABLE)
			{
				ApplicationManager.open("SystemOperation.LoginSystem.LoginSystem");
				Message.SystemUnavailable();
				TitleManager.init();
				TitleManager.MainTitle = "系统已经被锁定,请尝试登陆解锁.";
				Cc.debug("EinStation Plugin initing: TitleManager inited");
				BackgroundManager.init();
				Cc.debug("EinStation Plugin initing: BackgroundManager inited");
				this.EinStationStartComplete();
				return;
			}
			switch (SystemManager.getFlashVar("app"))
			{
				case "": 
				case "EinStatin": 
					this.EinStatinMode();
					break;
				case "PSYCHO-PASS": 
					Message.SystemUpdate(function():*
						{
							URLNavigator.open("http://einstation.sinaapp.com/2/?app=PSYCHO-PASS", true, "_self");
						}, "由于系统升级原因,你所需要的功能[" + SystemManager.getFlashVar("app") + "]已经迁移到新的地址,是否进入?");
					break;
				case "Debug": 
					this.DebugMode();
					break;
				default: 
					this.DebugMode();
					Message.SystemVarsError(SystemManager.getFlashVar("app"));
			}
			this.EinStationStartComplete();
		}
		
		private function DebugMode():void
		{
			TitleManager.init();
			TitleManager.loadTitleFormServer();
			Cc.debug("EinStation Plugin initing: TitleManager inited");
			NavigationManager.init();
			Cc.debug("EinStation Plugin initing: NavigationManager inited");
			BackgroundManager.init();
			Cc.debug("EinStation Plugin initing: BackgroundManager inited");
			ZweiteHorizontService.init(true);
			Cc.debug("EinStation Plugin initing: Remote inited");
			MusicWidgetManager.init();
			Cc.debug("EinStation Plugin initing: MusicWidgetManager inited");
			WeiboManager.init();
			Cc.debug("EinStation Plugin initing: WeiboManager inited");
			// ApplicationManager.open("com.lizeqiangd.zweisystem.applications.Weibo.MainController.WeiboMainController");
			//  ApplicationManager.open("com.lizeqiangd.zweisystem.applications.MessageChannel.ChatRoom.Standard.StandardChatRoom");
			ApplicationManager.open("com.lizeqiangd.zweisystem.applications.MessageChannel.Lobby.Standard.StandardLobby");
			//  ApplicationManager.open("com.lizeqiangd.zweisystem.applications.SystemOperation.TestBoard.TestBoard"); 
		}
		
		private function EinStatinMode():*
		{
			TitleManager.init();
			TitleManager.loadTitleFormServer();
			Cc.debug("EinStation Plugin initing: TitleManager inited");
			NavigationManager.init();
			Cc.debug("EinStation Plugin initing: NavigationManager inited");
			BackgroundManager.init();
			Cc.debug("EinStation Plugin initing: BackgroundManager inited");
			ZweiteHorizontService.init(true);
			Cc.debug("EinStation Plugin initing: Remote inited");
			MusicWidgetManager.init();
			Cc.debug("EinStation Plugin initing: MusicWidgetManager inited");
			WeiboManager.init();
			Cc.debug("EinStation Plugin initing: WeiboManager inited");
			
			SystemConfig.getSystemConfig("DefaultApplication", this.onDefaultApplicationLoadComplete);
			SystemConfig.getSystemConfig("DefaultApplication2", this.onDefaultApplication2LoadComplete);
			
			SystemConfig.getSystemConfig2("NicoNicoNi", this.onNiconiconi);
		}
		
		private function onDefaultApplicationLoadComplete(param1:Object):*
		{
			if (param1.value)
			{
				ApplicationManager.open(param1.value);
			}
		}
		
		private function onDefaultApplication2LoadComplete(param1:Object):*
		{
			if (param1.value)
			{
				ApplicationManager.open(param1.value);
			}
		}
		
		private function onNiconiconi(param1:Object):*
		{
			if (param1.enable)
			{
				Message.SystemConfirm("你准备好放弃治疗了吗?(注意音响大小)妮可妮可妮~妮可妮可妮~~妮可妮可妮~~~", function():*
					{
						TitleManager.MainTitle = param1.title;
						BackgroundManager.remote(param1.url,param1.description);
					});
			}
		}
		
		private function EinStationStartComplete():*
		{
			this.failedTimer.stop();
			this.failedTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.EinStationStartError);
			this.failedTimer = null;
			try
			{
				removeChild(this.mc_failed);
			}
			catch (e:*)
			{
			}
			this.mc_failed = null;
			StageProxy.updateStageSize();
		}
		
		private function EinStationStartError(param1:*):*
		{
			addChild(this.mc_failed);
			this.mc_failed.alpha = 1;
		}
	}
}
