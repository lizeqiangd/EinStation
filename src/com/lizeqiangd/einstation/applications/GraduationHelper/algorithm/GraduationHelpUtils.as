package com.zweisystem.applications.GraduationHelper.algorithm 
{
	/**
	 * ...
	 * @author lizeqiangd
	 */
	public class GraduationHelpUtils 
	{
		public function CopyTextToClassArray(string:String ):Array
		{	var fin_arr:Array = []
			var str:String = string
			var strs:Array = []			
			//tx.text = str.slice(str.search("备注") + 5, str.search("所选学分") - 4)+"\n"
			for (var o:int = 1; str.search("备注") > 0; o++)
			{
				trace("当前导入学期学期：", o)
				strs.push(str.slice(str.search("备注") + 5, str.search("所选学分") - 4))
				str = str.slice(str.search("所选学分") + 1)
			}
			var k:int = 1
			
			for (var j:int = 0; j < strs.length; j++)
			{
				var arr:Array = strs[j].split("  ")
				k = 1
				for (var i:int = 0; i < arr.length - 9; i += 10)
				{
					k++
					var d:Object = new Object
					d.name = arr[i + 3]
					d.point = arr[i + 5]
					d.available = arr[i + 7] == "F" ? false : true
					//trace(arr[i + 3], arr[i + 5], arr[i + 7] == "F" ? "无效" : "有效")
					//trace(arr[i + 10],k, arr[i + 10] == k.toString())
					if (!(arr[i + 10] == k))
					{
						i++
					}
					fin_arr.push(d)
				}
			}
			
		//	for (var f:int = 0; f < fin_arr.length; f++) {
		//		trace(fin_arr[f].name,fin_arr[f].point,fin_arr[f].available)
			//}
			return fin_arr
			
		}
	}

}