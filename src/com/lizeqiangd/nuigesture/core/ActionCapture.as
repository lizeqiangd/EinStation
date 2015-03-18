package com.lizeqiangd.nuigesture.core
{
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.lizeqiangd.nuigesture.NuiGesture;
	import com.lizeqiangd.nuigesture.NuiSettings;
	import com.lizeqiangd.nuigesture.data.action.ActionPoint;
	import com.lizeqiangd.nuigesture.manager.ActionArrayManager;
	
	/*
	 * 动作捕获类,原理是将用户每一个时间的数据记录并交给其他地方分析.
	 * update@20140309 修改为非静态类
	 */
	public class ActionCapture
	{
		//public static var aa:ActionCapture;
		private var actionCatchTimer:Timer;
		private var userLength:uint;
		private var kinect:Kinect;
		
		private var actionCatchCentrePoint:ActionPoint;
		private var actionCatchPoint:ActionPoint;
		private var inited:Boolean = false
		
		private var HD:HandDistand
		private var AAM:ActionArrayManager
		
		/*
		 * 初始化本类,并输入kinect的序号
		 */
		public function init(aam:ActionArrayManager, _kinect:Kinect)
		{
			if (inited)
			{
				inited = true
				kinect = _kinect
				actionCatchTimer = new Timer(NuiSettings.ActionCatchTime);
				userLength = 0;
				kinect.addEventListener(UserEvent.USERS_ADDED, userNumberChange);
				kinect.addEventListener(UserEvent.USERS_REMOVED, userNumberChange);
				trace("ActionCapture:initializing,ActionCatchTime:" + (NuiSettings.ActionCatchTime));
				startCatchAction();
			}
			else
			{
				trace("Nuigesture.ActionCapture:already inited.")
			}
		}
		
		/*
		 * 开始捕获(需要大量的计算量)
		 */
		public function startCatchAction()
		{
			NuiEventDispatcher
			switch (userLength)
			{
				case 0: 
					//trace("ActionCapture:没有找到user");
					stopCatchAction();
					return;
					break;
				case 1: 
					stopCatchAction();
					actionCatchTimer.addEventListener(TimerEvent.TIMER, actionTimerHandle);
					actionCatchTimer.start();
					trace("Nuigesture.ActionCapture:startCatchAction");
					break;
				case 2: 
					stopCatchAction();
					actionCatchTimer.addEventListener(TimerEvent.TIMER, actionTimerHandle);
					actionCatchTimer.start();
					trace("Nuigesture.ActionCapture:startCatchAction");
					break;
				default: 
					stopCatchAction();
					actionCatchTimer.addEventListener(TimerEvent.TIMER, actionTimerHandle);
					actionCatchTimer.start();
					trace("Nuigesture.ActionCapture:超过2个user");
			}
		}
		
		/*
		 * 通过让timer停止让捕获停止
		 * 目前建议要停止,请直接让整个部件停止运行.
		   public function stopCatchAction()
		   {
		
		   try
		   {
		   actionCatchTimer.stop();
		   actionCatchTimer.reset();
		   actionCatchTimer.removeEventListener(TimerEvent.TIMER, actionTimerHandle);
		   trace("Nuigesture.ActionCapture:stopCatchAction");
		   }
		   catch (e:*)
		   {
		   trace("Nuigesture.ActionCapture:startCatchAction unknown error");
		   }
		   }
		 */
		
		/*
		 * 当Timer到时的时候进行捕获人物数据,并将数据发送到ActionArrayManager中进行处理.
		 * 同样目前只支持1个用户的右手.
		 */
		private function actionTimerHandle(e:TimerEvent)
		{
			if (userLength == 1)
			{
				HD.user = kinect.users[0];
				//trace("**********");
				actionCatchCentrePoint = new ActionPoint(0, (kinect.users[0].leftShoulder.position.rgb.x + kinect.users[0].rightShoulder.position.rgb.x) / 2, (kinect.users[0].leftShoulder.position.rgb.y + kinect.users[0].rightShoulder.position.rgb.y) / 2, (kinect.users[0].leftShoulder.position.world.x + kinect.users[0].rightShoulder.position.world.x) / 2, (kinect.users[0].leftShoulder.position.world.y + kinect.users[0].rightShoulder.position.world.y) / 2, (kinect.users[0].leftShoulder.position.world.z + kinect.users[0].rightShoulder.position.world.z) / 2);
				//trace("中心："+actionCatchCentrePoint.toString ());
				actionCatchPoint = new ActionPoint(HD.leftHandDistand, kinect.users[0].leftHand.position.rgb.x, kinect.users[0].leftHand.position.rgb.y, kinect.users[0].leftHand.position.world.x, kinect.users[0].leftHand.position.world.y, kinect.users[0].leftHand.position.world.z);
				AAM.User1LeftHandActionArray.capture(actionCatchPoint, actionCatchCentrePoint);
				//trace("左手："+actionCatchPoint.toString ());
				actionCatchPoint = new ActionPoint(HD.rightHandDistand, kinect.users[0].rightHand.position.rgb.x, kinect.users[0].rightHand.position.rgb.y, kinect.users[0].rightHand.position.world.x, kinect.users[0].rightHand.position.world.y, kinect.users[0].rightHand.position.world.z);
				//trace("右手az："+actionCatchPoint.az);
				//trace("右手wz："+actionCatchPoint.worldZ);
				AAM.User1RightHandActionArray.capture(actionCatchPoint, actionCatchCentrePoint);
				
			}
			if (userLength == 2)
			{
				trace("ActionCapture:用户太多,请减少至一人。");
				return;				
			}		
		}
		
		/*
		 * 当用户数量改变的时候,触发的事件
		 */
		private function userNumberChange(e:UserEvent)
		{
			//stopCatchAction();
			userLength = kinect.users.length;
			trace("ActionCapture:用户数发生变化，当前为:" + userLength, userLength > 1 ? "现在只是可以识别第一个人" : "");
			startCatchAction();
		}
		
		/*
		 * 销毁本类
		 */
		public function dispose()
		{
			stopCatchAction();
			actionCatchTimer.removeEventListener(TimerEvent.TIMER, actionTimerHandle);
			kinect.removeEventListener(UserEvent.USERS_ADDED, userNumberChange);
			kinect.removeEventListener(UserEvent.USERS_REMOVED, userNumberChange);
			actionCatchCentrePoint = null;
			actionCatchPoint = null;
			actionCatchTimer = null;
			inited = false
		}
	}
}