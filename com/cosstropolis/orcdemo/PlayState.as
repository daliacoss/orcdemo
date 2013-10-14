package com.cosstropolis.orcdemo
{
	import flash.ui.Mouse;
	
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source="assets/tileset_summer.png")] private var tileSetSummer:Class;
		[Embed(source="assets/level1_layer1.csv", mimeType="application/octet-stream")] private var level1CSV:Class;
		
		public var orc:Orc = new Orc(0, 0);
		public var tower:Tower = new Tower(orc);
		public var level1Map:FlxTilemap = new FlxTilemap();
		
		var debug:FlxText;
		
		override public function create():void{
			Mouse.show();
			FlxG.bgColor = 0xffaaaaee;
			
			level1Map.loadMap(new level1CSV, tileSetSummer, 32, 32);
			add(level1Map);
			
			add(orc);
			
			tower.x = FlxG.width/2 - tower.width/2;
			tower.y = FlxG.height/2 - tower.height/2;
			add(tower);
			
			debug = new FlxText(FlxG.width/2 - 50, 50, 100);
			debug.alignment = "center";
			add(debug);
		}
		
		override public function update():void{
			Mouse.show();
			if (!orc.exists) FlxG.resetState();
			
			//i always forget this part
			super.update();
		}
	}
}