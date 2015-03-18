package com.zweisystem.applications.PasscardSystem
{
	import com.transmote.flar.marker.FLARMarker;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import org.libspark.flartoolkit.core.types.FLARDoublePoint2d;
    import com.zweisystem.applications.PasscardSystem.tp
	public class MarkerOutliner extends Sprite
	{
		private var slate_corners:Sprite;
		private var slate_vector3D:Shape;
		public var t1:tp;
		public var t2:tp;
		public var t3:tp;
		public var t4:tp;
		public var t5:tp;
		public function MarkerOutliner()
		{
			this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
			this.slate_corners = new Sprite  ;
			this.slate_vector3D = new Shape  ;
			this.addChild(this.slate_corners);
			this.addChild(this.slate_vector3D);
			t1 = new tp  ;
			t2 = new tp  ;
			t3 = new tp  ;
			t4 = new tp  ;
			t5 = new tp  ;
		}

		public function drawOutlines(marker:FLARMarker,thickness:Number,color:Number):void
		{
			this.drawCornersOutline(marker,thickness,color);
		}

		/**
		 * draw marker outline using the four corners of the detected marker.
		 */

		public function drawCornersOutline(marker:FLARMarker,thickness:Number,color:Number):void
		{

			slate_corners.removeChildren();
			this.slate_corners.graphics.lineStyle(thickness,color);
			var corners:Vector.<Point >  = marker.corners;
			var vertex:Point = corners[0];
			this.slate_corners.graphics.moveTo(vertex.x,vertex.y);
			for (var i:uint = 1; i < corners.length; i++)
			{
				vertex = corners[i];
				this.slate_corners.graphics.lineTo(vertex.x,vertex.y);
				var t:tp = this["t" + i];
				t.x = vertex.x;
				t.y = vertex.y;
				t.tx_x.text = "X:" + vertex.x;
				t.tx_y.text = "Y:" + vertex.y;
				t.tx_z.text = "点编号：" + String(i);
				addChild(t);
			}
			vertex = corners[0];
			this.slate_corners.graphics.lineTo(vertex.x,vertex.y);
			//var t:tp=new tp();
			t = this["t" + 4];
			t.x = vertex.x;
			t.y = vertex.y;
			t.tx_x.text = "X:" + vertex.x;
			t.tx_y.text = "Y:" + vertex.y;
			t.tx_z.text = "点编号：0";
			addChild(t);
			t = this["t" + 5];
			t.x = corners[0].x + corners[1].x + corners[2].x + corners[3].x / 4;
			t.y = corners[0].y + corners[1].y + corners[2].y + corners[3].y / 4;
			//addChild(t);
			t.tx_x.text = "w:" +String (corners[2].x - corners[3].x);
			t.tx_y.text = "h:" +String ( corners[0].y - corners[3].y);
			t.tx_z.text = "";

		}

		/**
		 * draw marker outline using x, y, and rotationZ from FLARMarker.vector3D.
		 */
		public function drawOutlineVector3D(marker:FLARMarker):void
		{
			var size:Number = 80;
			this.slate_vector3D.x = marker.vector3D.x + 0.5 * this.stage.stageWidth;
			this.slate_vector3D.y = marker.vector3D.y + 0.5 * this.stage.stageHeight;
			this.slate_vector3D.rotation = marker.vector3D.w;
			this.slate_vector3D.graphics.lineStyle(1,0x00FF00);
			this.slate_vector3D.graphics.drawRect(-0.5 * size,-0.5 * size,size,size);
			trace((((((((("(" + marker.vector3D.x) + ",") + marker.vector3D.y) + ",") + marker.vector3D.z) + ",") + marker.vector3D.w) + ")"));
		}

		private function onEnterFrame(evt:Event):void
		{
			this.slate_corners.graphics.clear();
			this.slate_vector3D.graphics.clear();
		}
	}
}