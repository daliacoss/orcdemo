package com.cosstropolis.orcdemo
{
	import org.flixel.*;
	
	/*a movable sprite character class */
	public class Character extends FlxSprite
	{
		
		public var direction:FlxPoint = new FlxPoint(0, -1);
		protected var idle:Boolean = false;
		protected var deathTimer:Number = 0;
		protected var timeUntilDeath:Number = 0;
	
		public const FP_ZERO:FlxPoint = new FlxPoint(0, 0);
		
		public function Character(X:Number=0, Y:Number=0, MaxVelocityX:Number=0, MaxVelocityY:Number=0)
		{
			super(X, Y);
			this.maxVelocity.x = MaxVelocityX;
			this.maxVelocity.y = MaxVelocityY;

		}
		
		override public function update():void{
			walk(direction, (idle || !alive) ? FP_ZERO : maxVelocity);
		}
		
		/* move sprite by speed * direction vector */
		protected function walk(direction:FlxPoint, speed:FlxPoint):void{
			//scale direction values using -1 and 1 as min and max
			direction.x = (direction.x > 0) ? 1 : (direction.x < 0) ? -1 : 0;
			direction.y = (direction.y > 0) ? 1 : (direction.y < 0) ? -1 : 0;
			
			//FlxG origin is top left, so we invert the y
			velocity = new FlxPoint(direction.x * speed.x, direction.y * -speed.y);
		}
		
	}
}