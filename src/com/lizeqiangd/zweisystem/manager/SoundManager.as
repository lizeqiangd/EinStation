package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.data.media.Music;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	/**
	 * 音乐播放器,非常建议的音效播放器,用于加载音效.当然音乐以后也可以通过此类进行
	 * 20150612
	 * @author Lizeqiangd
	 */
	public class SoundManager
	{
		private static var instance:SoundManager
		
		public static function get getInstance():SoundManager
		{
			if (!instance)
				instance = new SoundManager
			return instance
		}
		
		public var sound_library:Vector.<Music>;
		
		public function SoundManager()
		{
			if (instance)
				throw new Error('please use getInstance to get this instance.', 1)
			
			sound_library = new Vector.<Music>;
		}
		
		public function addSoundToLibrary(sound_name:String, url:String):void
		{
			var ur:URLRequest = new URLRequest(url)
			var music:Music = new Music()
			music.Sounds = new Sound()
			music.Sounds.load(ur, new SoundLoaderContext(20000, false))			
			music.SoundName = sound_name
			sound_library.push(music)
		}
		
		public function PlaySound(music_name:String):SoundChannel
		{
			var m:Music = SearchSound(music_name)
			if (m)
			{
				m.SoundChannels = m.Sounds.play()
				return m.SoundChannels
			}
			return new SoundChannel
		}
		
		public function StopSound(music_name:String):void
		{
			var m:Music = SearchSound(music_name)
			if (m)
			{
				m.SoundChannels.stop()
			}
		
		}
		
		private function SearchSound(sound_name:String):Music
		{
			for (var i:int = 0; i < sound_library.length; i++)
			{
				if (sound_name == sound_library[i].SoundName)
				{
					return sound_library[i]
				}
			}
			return new Music()
		}
	}

}