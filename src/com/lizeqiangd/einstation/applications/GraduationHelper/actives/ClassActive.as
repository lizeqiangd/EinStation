package com.lizeqiangd.einstation.applications.GraduationHelper.actives
{
	
	/**
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	import com.junkbyte.console.Cc;
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.applications.GraduationHelper.algorithm.GraduationHelpUtils;
	import com.zweisystem.events.ActiveEvent;
	import com.zweisystem.modules.datagird.DataGird;
	
	public class ClassActive extends BaseActive implements iActive
	{
		private var arr:Array
		private var dg_zhbx:DataGird
		private var dg_zybx:DataGird
		private var dg_zyxx:DataGird
		private var dg_ggxx:DataGird
		
		private var arr_zhbx:Array
		private var arr_zybx:Array
		private var arr_zyxx:Array
		private var arr_point:Array
		
		private var dp_zhbx:Array
		private var dp_zybx:Array
		private var dp_zyxx:Array
		private var dp_ggxx:Array
		
		public function ClassActive()
		{
			super("ClassActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			dg_zhbx = new DataGird
			dg_zybx = new DataGird
			dg_zyxx = new DataGird
			dg_ggxx = new DataGird
			dg_zhbx.config(this, "com.zweisystem.applications.GraduationHelper.datagird.rows_class", 19)
			addChild(dg_zhbx)
			dg_zhbx.x = 190 * 0
			dg_zhbx.y = 40
			dg_zybx.config(this, "com.zweisystem.applications.GraduationHelper.datagird.rows_class", 19)
			addChild(dg_zybx)
			dg_zybx.x = 190 * 1
			dg_zybx.y = 40
			dg_zyxx.config(this, "com.zweisystem.applications.GraduationHelper.datagird.rows_class", 19)
			addChild(dg_zyxx)
			dg_zyxx.x = 190 * 2
			dg_zyxx.y = 40
			dg_ggxx.config(this, "com.zweisystem.applications.GraduationHelper.datagird.rows_class", 19)
			addChild(dg_ggxx)
			dg_ggxx.x = 190 * 3
			dg_ggxx.y = 40
			
			row_zhbx.classType("zhbx")
			row_zhbx.titleMode()
			row_zhbx.tx_name.text = "综合必修"
			
			row_zybx.classType("zybx")
			row_zybx.titleMode()
			row_zybx.tx_name.text = "专业必修"
			
			row_zyxx.classType("zyxx")
			row_zyxx.titleMode()
			row_zyxx.tx_name.text = "专业选修"
			
			row_ggxx.classType("ggxx")
			row_ggxx.titleMode()
			row_ggxx.tx_name.text = "公共选修"
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			addUiListener()
			mian()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			removeUiListener()
		}
		
		private function mian()
		{
			dp_zhbx = []
			dp_zybx = []
			dp_zyxx = []
			dp_ggxx = []
			var k:int = 0
			var j:Boolean = false
			for (var i:int = 0; i < arr.length; i++)
			{
				j = false
				if (arr[i].available == true)
				{
					for (k = 0; k < arr_zhbx.length; k++)
					{
						if (arr[i].name == arr_zhbx[k])
						{
							j = true
							dp_zhbx.push({name: arr[i].name, point: arr[i].point, type: "zhbx"})
						}
					}
					for (k = 0; k < arr_zybx.length; k++)
					{
						if (arr[i].name == arr_zybx[k])
						{
							j = true
							dp_zybx.push({name: arr[i].name, point: arr[i].point, type: "zybx"})
						}
					}
					for (k = 0; k < arr_zyxx.length; k++)
					{
						if (arr[i].name == arr_zyxx[k])
						{
							j = true
							dp_zyxx.push({name: arr[i].name, point: arr[i].point, type: "zyxx"})
						}
					}
					if (!j)
					{
						dp_ggxx.push({name: arr[i].name, point: arr[i].point, type: "ggxx"})
					}
				}
			}
			
			Cc.log(dp_zhbx)
			Cc.log(dp_zybx)
			Cc.log(dp_zyxx)
			Cc.log(dp_ggxx)
			
			dg_zhbx.init(dp_zhbx)
			dg_zybx.init(dp_zybx)
			dg_zyxx.init(dp_zyxx)
			dg_ggxx.init(dp_ggxx)
			dg_zhbx.animation()
			dg_zybx.animation()
			dg_zyxx.animation()
			dg_ggxx.animation()
			var sum:Number  = 0
			for (k = 0; k < dp_zhbx.length; k++)
			{
				sum +=Number( dp_zhbx[k].point)
			}
			tx_zhbx.text = "综合必修:" + sum + "/" + arr_point[0]
			sum = 0
			for (k = 0; k < dp_zybx.length; k++)
			{
				sum += Number(dp_zybx[k].point)
			}
			tx_zybx.text = "专业必修:" + sum + "/" + arr_point[1]
			sum = 0
			for (k = 0; k < dp_zyxx.length; k++)
			{
				sum +=Number( dp_zyxx[k].point)
			}
			tx_zyxx.text = "专业选修:" + sum + "/" + arr_point[2]
			sum = 0
			for (k = 0; k < dp_ggxx.length; k++)
			{
				sum += Number(dp_ggxx[k].point)
			}
			tx_ggxx.text = "公共选修:" + sum + "/" + arr_point[3]
		}
		
		private function addUiListener()
		{
		
		}
		
		private function removeUiListener()
		{
		
		}
		
		public function activeMessage(msg:Object)
		{
			Cc.log("ClassActive.activeMessage")
			switch (msg.type)
			{
				case "copy": 
					var ghu:GraduationHelpUtils = new GraduationHelpUtils
					arr = ghu.CopyTextToClassArray(msg.copy)
					
					Cc.debug(arr)
					break;
				case "module": 
					arr_zhbx = String(msg.data.zhbx).split(" ")
					arr_zyxx = String(msg.data.zyxx).split(" ")
					arr_zybx = String(msg.data.zybx).split(" ")
					arr_point = String(msg.data.point).split(" ")
					break;
				default: 
					break;
			}
		}
		
		public function dispose()
		{
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}