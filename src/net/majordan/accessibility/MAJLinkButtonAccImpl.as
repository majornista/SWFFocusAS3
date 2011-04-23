package net.majordan.accessibility
{
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityImplementation;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import net.majordan.controls.AccLinkButton;
	
	/**
	 * 
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */ 
	public class MAJLinkButtonAccImpl extends MAJAccImpl 
	{
		//--------------------------------------------------------------------------
		//  Class constants
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private static const STATE_SYSTEM_PRESSED:uint = 0x00000008;

		/**
		 *  @private
		 */
		private static const EVENT_OBJECT_NAMECHANGE:uint = 0x800C;
		
		/**
		 *  @private
		 */
		private static const EVENT_OBJECT_STATECHANGE:uint = 0x800A;

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------


		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
	
		
		//----------------------------------
		//  eventsToHandle
		//----------------------------------

		/**
		 *  @private
		 *	Array of events that we should listen for from the master component.
		 */
		override protected function get eventsToHandle():Array
		{
			return super.eventsToHandle.concat([ "click", KeyboardEvent.KEY_DOWN ]);
		}


		//--------------------------------------------------------------------------
		//  Class methods
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 *  All subclasses must implement this function.
		 * 
		 *  @param component The InteractiveObject instance that this AccImpl instance
         *  is making accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */	
		public static function createAccessibilityImplementation(interactiveObject:InteractiveObject):void {
			interactiveObject.accessibilityImplementation = new MAJLinkButtonAccImpl(interactiveObject);
		}
	
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
	
        /**
         * @private
         *
         *  Creates a new Accessibility Implementation instance for the specified component.
		 *
		 *  @param sprite The Sprite instance that this AccImpl instance
         *  makes accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function MAJLinkButtonAccImpl(interactiveObject:InteractiveObject)
		{
			super(interactiveObject);
			
			role = 0x1E;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods: AccImpl
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  method for returning the name of the LinkButton
		 *  which is spoken out by the screen reader
		 *  The LinkButton should return the label inside as the name of the LinkButton.
		 *  The name returned here would take precedence over the name
		 *  specified in the accessibility panel.
		 *
		 *  @param childID uint
		 *
		 *  @return Name String
		 */
		override protected function getName(childID:uint):String
		{
			var numChildren:uint = DisplayObjectContainer( master ).numChildren;
			
			var label:String;
			
			for (var i:uint = 0; i < numChildren; i++)
			{
				var child:DisplayObject = DisplayObjectContainer(master).getChildAt(i);
				if (child is TextField)
				{
					label = TextField( child ).text;
					break;
				}
			}
			
			return (label != null && label != "") ? label : "";
		}
	
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: AccessibilityImplementation
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  IAccessible method for returning the state of the Button.
		 *  States are predefined for all the components in MSAA.
		 *  Values are assigned to each state.
		 *  Depending upon the button being pressed or released,
		 *  a value is returned.
		 *
		 *  @param childID uint
		 *
		 *  @return State uint
		 */
		override public function get_accState(childID:uint):uint
		{
			var accState:uint = getState(childID);

			return accState;
		}
		
		/**
		 *  @private
		 *  IAccessible method for returning the value of the Link.
		 *
		 *  @param childID uint
		 *
		 *  @return Value string
		 */
		override public function get_accValue(childID:uint):String
		{
			var numChildren:uint = DisplayObjectContainer(master).numChildren;
			
			var accValue:String;
			
			for (var i:uint = 0; i < numChildren; i++)
			{
				var child:DisplayObject = DisplayObjectContainer(master).getChildAt(i);
				
				if (child is TextField)
				{
					var xml:XML = new XML("<xml>" + TextField( child ).htmlText + "</xml>");
					
					accValue = xml..@HREF;
					
					if(accValue == ""){
						accValue = xml..@href;
					}
					
					break;
				}
			}
			try {
				if ((accValue == null || accValue == "") && Object(master).href != undefined)
				{
					accValue = Object(master).href;
				}
			} catch (err:Error)
			{
				
			}
						
			return accValue != null && accValue != "" ? accValue : "";
		}

		/**
		 *  @private
		 *  IAccessible method for returning the default action
		 *  of the LinkButton, which is Jump.
		 *
		 *  @param childID uint
		 *
		 *  @return DefaultAction String
		 */
		override public function get_accDefaultAction(childID:uint):String
		{
			return "Jump";
		}
		
		/**
		 *  @private
		 *  IAccessible method for performing the default action
		 *  associated with LinkButton, which is Jump.
		 *
		 *  @param childID uint
		 */
		override public function accDoDefaultAction(childID:uint):void
		{
			if ((master.mouseEnabled!==false || DisplayObjectContainer(master).mouseChildren) && master.tabEnabled!==false)
			{
				var event:KeyboardEvent = new KeyboardEvent(KeyboardEvent.KEY_DOWN);
				event.keyCode = Keyboard.SPACE;
				master.dispatchEvent(event);

				event = new KeyboardEvent(KeyboardEvent.KEY_UP);
				event.keyCode = Keyboard.SPACE;
				master.dispatchEvent(event);
			}
		}
				
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers: AccImpl
		//
		//--------------------------------------------------------------------------		
		
		/**
		 *  @private
		 *  Override the generic event handler.
		 *  All AccImpl must implement this
		 *  to listen for events from its master component. 
		 */
		override protected function eventHandler(event:Event):void
		{
			switch (event.type)
			{
				case "click":
				case KeyboardEvent.KEY_DOWN:
				{
					if (Accessibility.active)
					{
						Accessibility.sendEvent(master, 0, EVENT_OBJECT_STATECHANGE);
						Accessibility.updateProperties();
					}
					
					break;
				}
			}
		}
	}
}