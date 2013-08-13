package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="800", height="600")]
	
	/**
	 * Entry point for texture atlas sample.
	 * @author Zachary Lewis
	 */
	public class Main extends Engine
	{
		public function Main()
		{
			super(800, 600, 60, true);
		}
		
		override public function init():void 
		{
			super.init();
			FP.world = new AtlasWorld();
		}
	}
	
}
