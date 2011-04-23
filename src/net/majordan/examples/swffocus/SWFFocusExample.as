package net.majordan.examples.swffocus
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.majordan.controls.AccLinkButton;
	import net.majordan.swffocus.SWFFocus;
	
	public class SWFFocusExample extends Sprite 
	{
		private const LINK_BUTTON_LABEL:String = '<a href="http://www.adobe.com/accessibility/products/flash/">Adobe Flash CS4 Professional accessibility</a>';
		private const BLOG_BUTTON_LABEL:String = '<a href="http://blogs.adobe.com/accessibility/">Adobe Accessibility blog</a>';
		private const SOURCE_BUTTON_LABEL:String = '<a href="SWFFocusExample.zip">SWFFocusExample Source Code</a>';
		
		private var linkButton_mc:AccLinkButton;
		private var blogButton_mc:AccLinkButton;
		private var sourceButton_mc:AccLinkButton;
		
		public function SWFFocusExample():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			configUI();
			
			SWFFocus.init(stage);
		}
		
		private function configUI():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			linkButton_mc = new AccLinkButton();
			linkButton_mc.label = LINK_BUTTON_LABEL;
			
			blogButton_mc =  new AccLinkButton();
			blogButton_mc.label = BLOG_BUTTON_LABEL;
			
			sourceButton_mc = new AccLinkButton();
			sourceButton_mc.label = SOURCE_BUTTON_LABEL;
			
			// Be sure to assign tab-indexes to your keyboard-focusable items.
			// SWFFocus listens for the keyboard focus change when the tabIndex 
			// value for the focused item loops from the last to the first or 
			// from the first to the last and then shifts focus back to the 
			// HTML page.
			linkButton_mc.tabIndex = 1;
			blogButton_mc.tabIndex = 2;
			sourceButton_mc.tabIndex = 3;
			
			addChild(linkButton_mc);
			addChild(blogButton_mc);
			addChild(sourceButton_mc);
			
			onResize();
			addEventListener(Event.ENTER_FRAME, onResize);
		}
		
		private function onResize(e:Event = null):void 
		{
			if (e && e.type == Event.ENTER_FRAME) {
				removeEventListener(Event.ENTER_FRAME, onResize);
				stage.addEventListener(Event.RESIZE, onResize);
			}
 			blogButton_mc.x = (stage.stageWidth-blogButton_mc.width)/2;
			blogButton_mc.y = (stage.stageHeight-blogButton_mc.height)/2;
			
			linkButton_mc.x = (stage.stageWidth-linkButton_mc.width)/2;
			linkButton_mc.y = (blogButton_mc.y - linkButton_mc.height) - 5;
			
			sourceButton_mc.x = (stage.stageWidth-sourceButton_mc.width)/2;
			sourceButton_mc.y = (blogButton_mc.y + blogButton_mc.height) + 5;	
		}
	}
}