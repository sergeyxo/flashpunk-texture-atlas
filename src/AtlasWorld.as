package  
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.TextureAtlas;
	import net.flashpunk.World;
	
	/**
	 * A world created using texture atlases.
	 * @author Zachary Lewis
	 */
	public class AtlasWorld extends World 
	{
		[Embed(source = "../assets/gameatlas.xml", mimeType="application/octet-stream")]
		public static const ATLAS:Class;
		
		[Embed(source = "../assets/gameatlas.png")]
		public static const TEXTURE:Class;
		
		public var myAtlas:TextureAtlas;
		
		public var fireball:Image;
		public var coin:Image;
		public var player:Image;
		
		public function AtlasWorld() 
		{
		}
		
		override public function begin():void 
		{
			myAtlas = new TextureAtlas(TEXTURE, ATLAS);
			fireball = myAtlas.GetImage("item_fireball");
			coin = myAtlas.GetImage("item_coin");
			addGraphic(fireball);
			addGraphic(coin, 0, 36, 36);
			coin.alpha = 0.5;
			
			player = myAtlas.GetImage("player_walk_5");
			player.smooth = true;
			player.centerOrigin();
			addGraphic(player, 0, FP.halfWidth, FP.halfHeight);
			super.begin();
		}
		
		override public function update():void 
		{
			player.angle++;
			super.update();
		}
		
	}

}
