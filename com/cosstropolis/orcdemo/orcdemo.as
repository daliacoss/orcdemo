package com.cosstropolis.orcdemo
{
	import flash.display.Sprite;
	import org.flixel.*;
	
	[SWF(width="512", height="384", backgroundColor="#202020")]
	[Frame(factoryClass="Preloader")]
	
	public class orcdemo extends FlxGame
	{
		public function orcdemo()
		{
			super(512, 384, PlayState);
		}
	}
}