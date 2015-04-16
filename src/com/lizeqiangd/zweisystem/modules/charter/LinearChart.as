package com.lizeqiangd.zweisystem.modules.charter 
{
	import com.lizeqiangd.zweisystem.modules.charter.core.BaseChart;
	
	/**
	 * 线形标图.
	 * @author Lizeqiangd
	 * 20150414 制作完成.
	 */
	public class LinearChart extends BaseChart
	{
		override public function createChartData():void
		{
			sp_data.graphics.clear()
			sp_data.graphics.lineStyle(1, data_color)
			var detalX:Number = getUiWidth / (_data.length - 1)
			sp_data.graphics.beginFill(data_color, data_alpha)
			sp_data.graphics.moveTo(0, getYNumberPosition(_data[i]))
			for (var i:int = 0; i < _data.length; i++)
			{
				sp_data.graphics.lineTo(detalX * (i), getYNumberPosition(_data[i]))				
			}
			sp_data.graphics.lineStyle(1, data_color, 0)
			sp_data.graphics.lineTo(getUiWidth, getUiHeight)
			sp_data.graphics.lineTo(0, getUiHeight)
			sp_data.graphics.lineTo(0, getYNumberPosition(_data[0]))
			sp_data.graphics.endFill()
		}
	}

}