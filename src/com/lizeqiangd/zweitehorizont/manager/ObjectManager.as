package com.lizeqiangd.zweitehorizont.manager
{
	import com.lizeqiangd.zweitehorizont.abstracts.BaseObject;
	import com.lizeqiangd.zweitehorizont.data.object.User;
	import com.lizeqiangd.zweitehorizont.events.ObjectEvent;
	import com.lizeqiangd.zweitehorizont.net.FMSProxy;
	import com.lizeqiangd.zweitehorizont.system.ConversionData;
	import com.lizeqiangd.zweitehorizont.system.ZweiteHorizontConfig;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.nshen.nfms.FMSEvent;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	
	   Object
	   |-sid;（全局唯一独立id，服务器重启置零）
	   |-Shape;
	   |-Type;（点，圆，多边形）
	   |-Radius;（圆半径，点为0，圆即圆半径，多边形为外接圆半径）
	   |-CircumcircleCentrePoint;（外接圆圆心坐标）
	   |-PolygonPoints;（点圆为null，多边形独有）（多边形的点依次连接成为多边形)
	   |-Information;
	   |-CreatorUid;（创建者）
	   |-CreateDate;（创建时间）
	   |-Handler;
	   |-HandlerType;（掌控者类型，分为静态，自动步进，AI和玩家）
	   |-HandlerUID;（掌控者识别ID）
	   |-Location;
	   |-CentrePoint;（中心点坐标）(主坐标记录)
	   |-Content;（包含该物件的全部用于游戏的参数）
	   |-ItemId;(记录项目ID，事先进行准备的配置文件）
	   |-[具体参数]
	 */
	public class ObjectManager
	{
		private var fp:FMSProxy
		private var object_pool:Vector.<BaseObject>
		private var eventDispatch:EventDispatcher
		
		private var location_update_timer:Timer
		//private var autoUpdateObject
		private var inited:Boolean = false
		
		public function ObjectManager()
		{
			eventDispatch = new EventDispatcher
			object_pool = new Vector.<BaseObject>
			
			location_update_timer = new Timer(1000)
		}
		
		public function init(e:FMSProxy):void
		{
			if (inited)
			{
				return
			}
			inited = true
			fp = e
			fp.addConnectionEventListener("connected", onConnected)
			fp.addEventListener(ZweiteHorizontConfig.ObjectManagerRequestObjectPool, onRequestObjectPool)
			fp.addEventListener(ZweiteHorizontConfig.ObjectManagerRequestLocationUpdate, onUpdateObjectsLocation)
			fp.addEventListener(ZweiteHorizontConfig.ObjectManagerNotifyUserUpdateObject, onUpdateObject)
			fp.addEventListener(ZweiteHorizontConfig.ObjectManagerNotifyUserRemoveObject, onRemovedObject)
			
			location_update_timer.addEventListener(TimerEvent.TIMER, onAutoUpdateLocation)
		
		}
		
		//自动获取信息定时器
		private function onAutoUpdateLocation(e:TimerEvent):void
		{
			requestObjectLocation()
		}
		
		//开始自动更新坐标信息
		public function startAutoUpdateLocation(timestep:uint = 1000):void
		{
			location_update_timer.stop()
			location_update_timer.delay = 1000
			location_update_timer.start()
		}
		
		//获取当前状态
		public function get isAutoUpdateLocation():Boolean
		{
			return location_update_timer.running
		}
		
		//停止自动更新坐标信息
		public function stopAutoUpdateLocation():void
		{
			location_update_timer.stop()
		}
		
		//获取所有物件信息后调度
		private function onRequestObjectPool(e:FMSEvent):void
		{
			object_pool = new Vector.<BaseObject>
			for (var i:int = 0; i < e.data2.length; i++)
			{
				object_pool.push(ConversionData.ObjectToBaseObject(e.data2[i]))
			}
			eventDispatch.dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_POOL_UPDATE))
		}
		
		//获取所有坐标信息后调度
		private function onUpdateObjectsLocation(e:FMSEvent):void
		{
			var i:uint = 0
			var k:uint = 0
			loop1: for (i = 0; i < e.data2.length; i++)
			{
				loop2: for (k = 0; i < object_pool.length; k++)
				{
					if (object_pool[k].sid == e.data2[i].sid)
					{
						object_pool[k].location.x = e.data2[i].location.x
						object_pool[k].location.y = e.data2[i].location.y
						k = 0
						break loop2;
					}
				}
			}
			eventDispatch.dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_LOCATION_UPDATE))
		}
		
		//有物件更新或创建时调度
		private function onUpdateObject(e:FMSEvent):void
		{
			for (var i:int = 0; i < object_pool.length; i++)
			{
				if (object_pool[i].oid == e.data2.oid)
				{
					ConversionData.ObjectOverlayBaseObject(e.data2, object_pool[i])
					eventDispatch.dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_UPDATE, i))
					return
				}
			}
			object_pool.push(ConversionData.ObjectToBaseObject(e.data2))
			eventDispatch.dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_UPDATE, i + 1))
		
		}
		
		//有物件删除时调度
		private function onRemovedObject(e:FMSEvent):void
		{
			for (var i:int = 0; i < object_pool.length; i++)
			{
				if (object_pool[i].oid == e.data2)
				{
					object_pool.splice(i, 1)
				}
			}
			//比i高的减1  和i相等的自删
			eventDispatch.dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_REMOVED, i))
		
		}
		
		//物件管理器的侦听器
		public function addObjectEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, userWeakReference:Boolean = false):void
		{
			eventDispatch.addEventListener(type, listener, useCapture, priority, userWeakReference)
		}
		
		public function removeObjectEventListener(type:String, listener:Function):void
		{
			eventDispatch.removeEventListener(type, listener)
		}
		
		//连接成功后立刻获取当前物件池内所有数据（以后会更改）
		private function onConnected(e:Event):void
		{
			requestObjectPool()
			//trace("onObjectConnected")
		}
		
		//将一个物件创建到服务器上
		public function createObject(e:BaseObject):void
		{
			/*	var object:Object ={
			   oid:e.oid,
			   shape:{
			   type:e.shape.type,
			   radius:e.shape.radius
			   },
			   information:{
			   item_id:e.information.item_id,
			   creator_uid:e.information.creator_uid,
			   create_date:e.information.create_date
			   },
			   handler:{
			   handler_type:e.handler.handler_type,
			   handler_uid:e.handler.handler_uid
			   },
			   content:e.content,
			   location:{
			   x:e.location.x,
			   y:e.location.y
			   }
			 }*/
			//ZweiteHorizontConfig.ObjectManagerRequestLocationUpdate
			fp.dispatch(ZweiteHorizontConfig.ObjectManagerCreateObject, e)
		}
		
		//获取所有物件信息
		public function requestObjectPool():void
		{
			fp.dispatch(ZweiteHorizontConfig.ObjectManagerRequestObjectPool)
		}
		
		//获取所有物件坐标信息
		public function requestObjectLocation():void
		{
			fp.dispatch(ZweiteHorizontConfig.ObjectManagerRequestLocationUpdate)
		}
		
		//更新一个物件的信息
		public function updateObject(e:BaseObject):void
		{
			fp.dispatch(ZweiteHorizontConfig.ObjectManagerUpdateObjectInformation, e)
		
		}
		
		//更新一个物件的坐标
		public function updateObjectLoaction(e:BaseObject):void
		{
			fp.dispatch(ZweiteHorizontConfig.ObjectManagerUpdateObjectLocation, {oid: e.oid, location: {x: e.location.x, y: e.location.y}})
		}
		
		//将一个物件从服务器上删除
		public function removeObject(oid:uint):void
		{
			fp.dispatch(ZweiteHorizontConfig.ObjectManagerRemoveObject, {ObjectId: oid})
		
		}
		
		//获取物件列表
		public function get ObjectPool():Vector.<BaseObject>
		{
			return object_pool
		}
		
		//搜索物件系统
		public function SearchObject(SearchType:String, SearchContent:*):*
		{
			var totalLength:uint = object_pool.length
			var i:uint
			switch (SearchType)
			{
				case "ioid": 
					for (i = 0; i < totalLength; i++)
					{
						if (object_pool[i].oid == SearchContent)
						{
							return i
						}
					}
					break;
				case "oid": 
					for (i = 0; i < totalLength; i++)
					{
						if (object_pool[i].oid == SearchContent)
						{
							return object_pool[i]
						}
					}
					break;
				case "isid": 
					for (i = 0; i < totalLength; i++)
					{
						if (object_pool[i].sid == SearchContent)
						{
							return i
						}
					}
					break;
				case "sid": 
					for (i = 0; i < totalLength; i++)
					{
						if (object_pool[i].sid == SearchContent)
						{
							return object_pool[i]
						}
					}
					break;
			}
		}
	}

}