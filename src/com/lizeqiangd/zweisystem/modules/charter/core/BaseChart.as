package com.lizeqiangd.zweisystem.modules.charter.core
{
	import com.lizeqiangd.zweisystem.interfaces.baseunit.BaseUI;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * 所有图表类的基类.
	 * @author Lizeqiangd
	 * 20150414 基本完成.
	 */
	public class BaseChart extends BaseUI
	{
		protected var sp_Xaxis:Sprite
		protected var sp_Yaxis:Sprite
		protected var sp_data:Sprite
		protected var _data:Array
		protected var _min:Number
		protected var _max:Number
		protected var _chart_max:Number
		protected var _chart_min:Number
		
		/**
		 * 样式
		 */
		protected var data_color:uint
		protected var data_alpha:Number = 0.5
		protected var y_axis_color:uint
		protected var x_axis_color:uint
		protected var y_line_number:uint = 4
		protected var x_axis_alpha:Number = 0.2
		protected var y_axis_alpha:Number = 0.2
		public var setXAxisText:Boolean = false
		public var setYAxisText:Boolean = true
		///为了坐标轴美观,因此要缩放一定比例最大值和最小值,用于保证所有数据都在图内,而不是边上.
		protected var detalNumber:Number = 1.05
		
		public function BaseChart()
		{
			sp_data = new Sprite
			sp_Xaxis = new Sprite
			sp_Yaxis = new Sprite
			data_color = getFrameColor
			y_axis_color = getFrameColor
			x_axis_color = getFrameColor
			addChild(sp_data)
			addChild(sp_Xaxis)
			addChild(sp_Yaxis)
			
			this.mouseChildren		=false
		}
		
		public function config(_w:Number, _h:Number):void
		{
			configBaseUi(_w, _h)
		}
		
		public function createYAxis():void
		{
			sp_Yaxis.removeChildren();
			sp_Yaxis.graphics.clear()
			sp_Yaxis.graphics.lineStyle(1, y_axis_color, y_axis_alpha)
			for (var i:int = 0; i < y_line_number; i++)
			{
				sp_Yaxis.graphics.moveTo(0, getUiHeight / (y_line_number + 1) * (i + 1))
				sp_Yaxis.graphics.lineTo(getUiWidth, getUiHeight / (y_line_number + 1) * (i + 1))
				var line_number:Number = _chart_max - (_chart_max - _chart_min) / (y_line_number + 1) * (i + 1)
				if (setYAxisText)
				{
					var tf:TextField = createTextfield(line_number)
					tf.y = getUiHeight / (y_line_number + 1) * (i + 1) - 20
					sp_Yaxis.addChild(tf)
				}
			}
		}
		
		public function createXAxis():void
		{
			sp_Xaxis.removeChildren();
			sp_Xaxis.graphics.clear()
			sp_Xaxis.graphics.lineStyle(1, x_axis_color, x_axis_alpha)
			for (var i:int = 0; i < _data.length - 2; i++)
			{
				sp_Xaxis.graphics.moveTo(getUiWidth / (_data.length - 2 + 1) * (i + 1), 0)
				sp_Xaxis.graphics.lineTo(getUiWidth / (_data.length - 2 + 1) * (i + 1), getUiHeight)
				
				if (setXAxisText)
				{
					var line_number:Number = _chart_max - (_chart_max - _chart_min) / (_data.length - 2 + 1) * (i + 1)
					var tf:TextField = createTextfield(i + 1)
					tf.y = getUiHeight - tf.textHeight
					tf.x = getUiWidth / (_data.length - 2 + 1) * (i + 1)
					sp_Xaxis.addChild(tf)
				}
			}
			if (setXAxisText)
			{
				var tf2:TextField = createTextfield(0)
				tf2.y = getUiHeight - 20
				tf2.x = 0
				sp_Xaxis.addChild(tf2)
			}
		}
		
		public function update():void
		{
			_min = _data[0]
			_max = _data[0]
			for (var u:int = 0; u < _data.length; u++)
			{
				_data[u] < _min ? _min = _data[u] : null
				_data[u] > _max ? _max = _data[u] : null
			}
			_chart_max = _max * detalNumber
			_chart_min = _max - _chart_max + _min
			
			if (y_line_number > 0)
			{
				createYAxis()
			}
			if (_data.length - 2 > 0)
			{
				createXAxis()
			}
			createChartData()
		}
		
		public function createChartData():void
		{
			//wait for overrided
		}
		
		/**
		 * 根据数字得到y轴高度.(会从底部开始计算)
		 * @param	e
		 * @return
		 */
		protected function getYNumberPosition(e:Number):Number
		{
			return getUiHeight - (e - _chart_min) / (_chart_max - _chart_min) * getUiHeight
		}
		
		/**
		 * 创建用于坐标轴显示的文本框.
		 * @param	num
		 * @return
		 */
		protected function createTextfield(num:Number = 0):TextField
		{
			var tf:TextField = new TextField
			tf.height = 20
			tf.mouseEnabled = false
			tf.defaultTextFormat = new TextFormat('微软雅黑', 15, 0x6699ff, null, null, null, null, null, 'center')
			tf.text = String(num + '')
			//if (tf.text.search('.') + 2 < tf.text.length)
			//{
				//tf.text = tf.text.slice(0, tf.text.search('.') + 4)
			//}
			tf.cacheAsBitmap = true
			tf.width = tf.textWidth + 5
			return tf
		}
		
		/**
		 * 设置图表
		 */
		public function set data(e:Array):void
		{
			this._data = e			
			update()
		}
		
		///设置坐标样式.
		public function set setDataColor(e:uint):void
		{
			data_color = e
		}
		
		public function set setDataAlpha(e:Number):void
		{
			data_alpha = e
		}
		
		public function set setYAxisColor(e:uint):void
		{
			y_axis_color = e
		}
		
		public function set setXAxisColor(e:uint):void
		{
			x_axis_color = e
		}
		
		public function set setYLineNum(e:uint):void
		{
			y_line_number = e
		}
		
		public function set setXAxisAlpha(e:Number):void
		{
			x_axis_alpha = e
		}
		
		public function set setYAxisAlpha(e:Number):void
		{
			y_axis_alpha = e
		}
		
		/**
		 * 返回最大值
		 */
		public function get getMax():Number
		{
			return _max
		}
		
		/**
		 * 返回最小值
		 */
		public function get getMin():Number
		{
			return _min
		}
	}

}