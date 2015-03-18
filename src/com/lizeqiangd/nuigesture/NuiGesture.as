package com.lizeqiangd.nuigesture
{
	import com.lizeqiangd.nuigesture.core.ActionAnalysis;
	import com.lizeqiangd.nuigesture.core.ActionCapture;
	import com.lizeqiangd.nuigesture.core.NuiEventDispatcher;
	import com.lizeqiangd.nuigesture.manager.ActionArrayManager;
	import com.lizeqiangd.nuigesture.manager.ZoneManager;
	import flash.events.EventDispatcher;
	import flash.display.BitmapData;
	import flash.events.Event;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.events.*;
	
	/*
	 * NuiGesture 将 as3nui分析好的骨骼数据进行识别和分析导出用户的实际动作数据.
	 * 没有好好的优化,因此对cpu的影响较为严重,请慎用
	 * update@20140309 重新更改结构
	 * @author:Lizeqiangd
	 * @Email:lizeqiangd@gmail.com
	 * @HP:lizeqiangd.com
	 */
	public class NuiGesture
	{
		private var _device:Kinect;
		private var _eventDispatch:EventDispatcher
		private var _kinectSettings:KinectSettings;
		
		private var ZM:ZoneManager
		private var AAM:ActionArrayManager
		private var NED:NuiEventDispatcher
		private var AC:ActionCapture
		private var AA:ActionAnalysis
		
		/*
		 * 构造函数.同时将默认设置写入类中
		 */
		public function NuiGesture()
		{
			_kinectSettings = this.configWithKinectSettings
			ZM = new ZoneManager
			AAM = new ActionArrayManager
			NED = new NuiEventDispatcher
			AC = new ActionCapture
			AA = new ActionAnalysis
		}
		
		/*
		 * 添加事件到NuiEventDispatcher里面
		 */
		public function addEventListener(type:String, listener:Function, userCapture = false, priority = 0, userWeakReference = false)
		{
			NED.eventDispatcher.addEventListener(type, listener, userCapture, priority, userWeakReference);
		}
		
		/*
		 * 移除事件从NuiEventDispatcher里面
		 */
		public function removeEventListener(type:String, listener:Function, userCapture = false)
		{
			NED.eventDispatcher.removeEventListener(type, listener, userCapture);
		}
		
		/*
		 * 设置Kinect从as3nui的KinectSettings
		 * e:KinectSettings
		
		   public function configWithKinectSettings(e:KinectSettings)
		   {
		   _kinectSettings = e;
		   }
		 */
		
		/*
		 * 初始化NuiGesture.
		 * 先检测系统是否支持Kinect硬件.也就是ane的设置.事实上没有ane你连编译都不行.
		 * KinectID:uint 需要初始化的Kinect序号.
		 * KinectSetting:KinectSettings 初始化kinect用的设置(as3nui的方法)
		 *
		 * 注意初始化后kinect已经启动,但是NuiGesture中的任何组件都没有启动.
		 */
		public function initialize(KinectSetting:KinectSettings = null, KinectID:uint = 0):void
		{
			trace("NuiGesture:initializing....");
			if (!Kinect.isSupported())
			{
				trace("NuiGesture:Kinect not supported.");
				return;
			}
			if (KinectSetting)
			{
				this._kinectSettings = KinectSetting
			}
			_device = getKinects(KinectID);
		
		}
		
		/*
		 * 简易启动方法:初始化并直接开始捕获.
		 */
		public function NuiAutoStart()
		{
			initialize();
			NuiStart();
		}
		
		/*
		 * 初始化后不希望立刻开始,可以使用这个函数.
		 */
		public function NuiStart()
		{
			trace("NuiGesture:Starting....");
			_device.start(_kinectSettings);
			ZM.init()
			NED.init()
			AA.init(NED, ZM)
			AAM.init(AA)
			AC.init(AAM, this.getKinects())
			
			//	NuiEventHandle.init();
			//	ZoneManager.init();
			ActionArrayManager.init();
			ActionCapture.init();
			ActionArrayManager.configAnalysis(true);
		}
		
		/*
		 * 修改Kinect当前角度(涉及硬件,会导致全程序卡死)
		 * 角度范围(-15,30)
		 * angle,kinectId
		 */
		public function cameraElevationAngle(angel:int, kinectId:uint = 0)
		{
			angel > 30 ? 30 : angel;
			angel < -15 ? -15 : angel;
			getKinects(kinectId).cameraElevationAngle = angel;
		}
		
		/*
		 * 获取RGB数据 返回BitmapData
		 */
		public function getRgbCamera(kinectID:uint):BitmapData
		{
			return new BitmapData(1, 1);
		}
		
		/*
		 * 获取Depth数据 返回BitmapData
		 */
		public function getDepthCamera(kinectID:uint):BitmapData
		{
			return new BitmapData(1, 1);
		}
		
		/*
		 * 获取as3nui的Kinect
		 */
		public function getKinects(u:uint = 0):Kinect
		{
			return Kinect.getDevice(u);
		}
		
		/*
		 * 获取NuiGesture事件主调度的EventDispatcher
		 */
		public function get eventDispatch():EventDispatcher
		{
			return NED.eventDispatcher;
		}
		
		/*
		 * 获取默认的NuiGesture的KinectSettings设置对象.
		 */
		public function get defaultNuiGestureKinectSettings():KinectSettings
		{
			trace("NuiGesture:config defaultNuiGestureKinectSettings");
			_kinectSettings = new KinectSettings();
			_kinectSettings.chooseSkeletonsEnabled = false
			_kinectSettings.depthEnabled = false
			_kinectSettings.depthMirrored = false
			_kinectSettings.depthResolution = CameraResolution.RESOLUTION_320_240;
			_kinectSettings.depthShowUserColors = true;
			_kinectSettings.nearModeEnabled = false
			_kinectSettings.pointCloudDensity = 0
			_kinectSettings.pointCloudEnabled = false
			_kinectSettings.pointCloudIncludeRGB = false
			_kinectSettings.pointCloudMirrored = false
			_kinectSettings.pointCloudResolution = CameraResolution.RESOLUTION_320_240;
			_kinectSettings.rgbEnabled = true
			_kinectSettings.rgbMirrored = false
			_kinectSettings.rgbResolution = CameraResolution.RESOLUTION_320_240;
			_kinectSettings.seatedSkeletonEnabled = true
			_kinectSettings.skeletonEnabled = true
			_kinectSettings.skeletonMirrored = false
			_kinectSettings.userEnabled = false
			_kinectSettings.userMaskEnabled = false
			_kinectSettings.userMaskMirrored = false
			_kinectSettings.userMaskResolution = CameraResolution.RESOLUTION_320_240;
			_kinectSettings.userMirrored = false
			//_kinectSettings.depthEnabled = true;
			return _kinectSettings;
		}
		
		/*
		 * 销毁NuiGesture,同时销毁全部组件.
		 */
		public function dispose()
		{
			trace("NuiGesture:Disposing....");
			AC.dispose();
			AAM.dispose();
			AA.dispose();
			NED.dispose();
			ZM.dispose();
			_device.dispose();
		}
	}
}