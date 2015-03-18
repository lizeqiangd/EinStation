package com.lizeqiangd.zweisystem.applications.SinaWeibo.MainController
{
	import flash.display.Sprite;
	import com.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.ApplicationManager;
	import com.zweisystem.managers.LoginManager;
	import com.junkbyte.console.Cc;
	public class MainControlPanel extends Sprite 
	{
		private var _dataProvider:Object;
		private var im:ImageDisplay;

		public function init()
		{
			this.btn1.title = "发布微博";
			this.btn2.title = "显示信息";
			this.btn3.title = "手势控制";
			//this.btn3.enable = false;
			this.btn4.title = "自动更新";

			tx_follower.text = "";
			tx_friends.text = "";
			tx_count.text = "";
			tx_user.text = "";
			tx_administrator.text = "";
			im =new ImageDisplay ();
			addUiListener();
		}
		private function addUiListener()
		{
			btn1.addEventListener(UnitEvent.CLICK,onDisplayPublisher);
			btn2.addEventListener(UnitEvent.CLICK,onDisplayStatus);
			btn3.addEventListener(UnitEvent.CLICK,onDisplayInformation);
			btn4.addEventListener(UnitEvent.CLICK,onSettingAutoUpdate);
		}
		private function removeUiListener()
		{
			btn1.removeEventListener(UnitEvent.CLICK,onDisplayPublisher);
			btn2.removeEventListener(UnitEvent.CLICK,onDisplayStatus);
			btn3.removeEventListener(UnitEvent.CLICK,onDisplayInformation);
			btn4.removeEventListener(UnitEvent.CLICK,onSettingAutoUpdate);
		}
		private function onDisplayPublisher(e:UnitEvent )
		{
			ApplicationManager.open("SinaWeibo.Publisher.DefaultPublisher");
		}
		private function onDisplayStatus(e:UnitEvent )
		{
			ApplicationManager.open("SinaWeibo.FullScreenDisplay.FullScreenDisplay");
		}
		private function onDisplayInformation(e:UnitEvent )
		{
			ApplicationManager.open("SinaWeibo.FullScreenGesture.FullScreenGesture");

		}
		private function onSettingAutoUpdate(e:UnitEvent )
		{
			if (e.data)
			{
			}
			else
			{
			}
		}
		public function dispose()
		{
			removeUiListener();

			im.dispose();
		}
		public function set dataProvider(t:Object )
		{
			tx_administrator.text = "加载数据中";
			_dataProvider = new Object  ;
			_dataProvider = t;
			showInformationBoard();
		}
		private function showInformationBoard()
		{
			this.addChild(im);
			tx_follower.text = "粉丝数：" + _dataProvider.followers_count;
			tx_friends.text = "关注数：" + _dataProvider.friends_count;
			tx_count.text = "发布数：" + _dataProvider.statuses_count;
			tx_user.text = "用户名：" + _dataProvider.name;
			tx_administrator.text = " ";
			//Cc.info("SinaWeibo.profileImageUrl:"+_dataProvider.profile_image_url);
			if (LoginManager.isAdministrator)
			{
				tx_administrator.text = "管理员模式";
			}
			im.config(50,50);
			im.load(_dataProvider.profile_image_url);
			im.x = 110;
			im.y = 10;
		}
	}

}