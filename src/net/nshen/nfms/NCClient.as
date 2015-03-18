package net.nshen.nfms 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	/**
	 * ...
	 * @author nn 
	 * 
	 */
	public class NCClient extends Proxy implements IEventDispatcher
	{
		
		private var _disp:EventDispatcher = new EventDispatcher()
		private var _methodsObject:Object = {}
		
		private var _nc:NetConnection
		
		public function NCClient(p_nc:NetConnection) 
		{
			this._nc = p_nc
		}
		/*implements the IEventDispatcher*/
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
          _disp.addEventListener(type, listener, false, 0, true);
        }
        
        
         
        public function dispatchEvent(evt:Event):Boolean{
          
		    
		   if(_nc)
		   {
			  
			 _nc.call( evt.type , null, FMSEvent(evt).data );
			 return true
		   }
           throw new Error("set nc first!")
        }
    
        public function hasEventListener(type:String):Boolean{
          return _disp.hasEventListener(type);
        }
    
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
          _disp.removeEventListener(type, listener, useCapture);
        }
                   
        public function willTrigger(type:String):Boolean {
          return _disp.willTrigger(type);
        }
		
        //魔法所在
        override flash_proxy function getProperty(name:* ):* 	   
	    {                   
            var str:String = name.localName.toString()  //method name
            if(_methodsObject[str]==undefined)
            {
              _methodsObject[str]= function(...args):void
              {
 
                this._disp.dispatchEvent(new FMSEvent(str , args)  );
              }      
            }
       
            return _methodsObject[str]
        }		
		
		
		
		public function get nc():NetConnection { return _nc; }
		
		public function set nc(value:NetConnection):void 
		{
			_nc = value;
		}
	}
	
}