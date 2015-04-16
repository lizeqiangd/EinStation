package
{
	import com.lizeqiangd.zweisystem.modules.charter.core.BaseChart;
	import com.lizeqiangd.zweisystem.modules.charter.LinearChart;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class Test extends Sprite
	{
		private var basechart:BaseChart
		
		public function Test()
		{
			basechart = new LinearChart
			addChild(basechart)
			basechart.x = basechart.y = 20
			basechart.config(800, 400)
			basechart.createFrame()
			setInterval(randomNumber, 1000)
			stage.addEventListener(MouseEvent.CLICK, randomNumber)
			arr = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
		}
		
		private var arr:Array
		private function randomNumber(e:MouseEvent = null):void
		{
			
			arr.push(Math.random() * 100)
			if (arr.length > 20)
			{
				arr.shift()
			}
			basechart.data = arr
		}
	
	}

}