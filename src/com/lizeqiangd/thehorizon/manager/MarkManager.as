package com.thehorizocom.thehorizonn.mcocom.thehorizonm.thehorizoncom.zweitehorizontacom.zweitehorizontnager
{
	import com.thehorizon.TheHorizon;
	import com.thehorizon.abstracts.BaseMark;
	import com.thehorizon.Unknown;
	import com.thehorizon.PositionUtils;
	import com.zweitehorizont.BaseObject;
	import com.zweitehorizont.ObjectEvent;
	import com.zweitehorizont.ObjectManager;
	import com.zweitehorizont.ZweiteHorizont;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class MarkManager
	{
		private var MarkPool:Vector.<BaseMark>
		private var LayerManagers:LayerManager
		
		public function MarkManager()
		{
		}
		
		public function init(layermanager:LayerManager):void
		{
			LayerManagers = layermanager
			MarkPool = new Vector.<BaseMark>
			ZweiteHorizont.ObjectManagers.addObjectEventListener(ObjectEvent.OBJECT_LOCATION_UPDATE, onObjectLocationUpdate)
			ZweiteHorizont.ObjectManagers.addObjectEventListener(ObjectEvent.OBJECT_POOL_UPDATE, onObjectPoolUpdate)
			ZweiteHorizont.ObjectManagers.addObjectEventListener(ObjectEvent.OBJECT_UPDATE, onObjectUpdate)
			ZweiteHorizont.ObjectManagers.addObjectEventListener(ObjectEvent.OBJECT_REMOVED, onObjectRemoved)
		
		}
		
		private function onObjectPoolUpdate(e:ObjectEvent):void
		{
			var i:int = 0
			for (i = 0; i < MarkPool.length; i++)
			{
				MarkPool[i].dispose()
				MarkPool.splice(i, 1)
			}
			for (i = 0; i < ZweiteHorizont.ObjectManagers.ObjectPool.length; i++)
			{
				//需要根据ItemId决定不同的Object
				trace("item_id:" + ZweiteHorizont.ObjectManagers.ObjectPool[i].information.item_id)
				var debugMark:Unknown = new Unknown
				debugMark.setMarkName = "测试坐标"
				debugMark.setBaseObject = ZweiteHorizont.ObjectManagers.ObjectPool[i]
				debugMark.setLayerManager = LayerManagers
				MarkPool.push(debugMark)
			}
			//trace("MarkManager:onObjectPoolUpdate")
			updateMarksLocations()
		}
		
		private function updateMarksLocations():void
		{
			var i:int = 0
			for (i = 0; i < MarkPool.length; i++)
			{
				var point:Point = PositionUtils.LatLngNumberToPoint(MarkPool[i].getBaseObject.location.lat, MarkPool[i].getBaseObject.location.lng)
				//var point:Point = PositionUtils.LatLngNumberToPoint( MarkPool[i].getBaseObject.location.lng,MarkPool[i].getBaseObject.location.lat)
				MarkPool[i].setNextLocationPoint = point
					//trace("x:" + point.x+" y:"+point.y)	
			}
		}
		
		private function onObjectLocationUpdate(e:ObjectEvent):void
		{
			//trace("MarkManager:onObjectLocationUpdate")
			updateMarksLocations()
		}
		
		private function onObjectRemoved(e:ObjectEvent):void
		{
			trace("MarkManager:onObjectRemoved")
		}
		
		private function onObjectUpdate(e:ObjectEvent):void
		{
			trace("MarkManager:onObjectUpdate")
		}
		
		public function get MarkPools():Vector.<BaseMark>
		{
			return MarkPool
		}
	}

}