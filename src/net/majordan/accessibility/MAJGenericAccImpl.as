package net.majordan.accessibility
{
	
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * The MAJGenericAccImpl class, also called the Generic Accessibility Implementation class,
	 * is used to make a DisplayObject accessible. This class enables communication
	 * between a component and a screen reader. Screen readers are used to translate
	 * screen content into synthesized speech or braille for visually impaired users.
	 * 
	 * <p>The MAJGenericAccImpl class supports system roles, object-based events, and states.</p>
	 * 
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	public class MAJGenericAccImpl extends AccessibilityProperties {
		
		/**
         *  @private (protected)
         *  A reference to the DisplayObject itself.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var master:DisplayObject;

		/**
		 *  @private
		 *  Method for creating the Accessibility class.
		 *  This method is called from DisplayObject. 
		 * 
		 *  @param component The DisplayObject instance that this AccImpl instance
         *  is making accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public static function createAccessibilityImplementation(displayObject:DisplayObject):void {
			displayObject.accessibilityProperties = new MAJGenericAccImpl(displayObject);
		}
		
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
	
		/**
         * @private
         *
		 *  Creates a new MAJGenericAccImpl instance for the specified DisplayObject.
		 *
		 *  @param master The DisplayObject instance that this AccImpl instance
         *  makes accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function MAJGenericAccImpl(displayObject:DisplayObject) {
			super();
			
			master = displayObject;
			
			if (displayObject.accessibilityProperties) {
				silent = displayObject.accessibilityProperties.silent;
				forceSimple = displayObject.accessibilityProperties.forceSimple;
				noAutoLabeling = displayObject.accessibilityProperties.noAutoLabeling;
				if (displayObject.accessibilityProperties.name) {
					name = displayObject.accessibilityProperties.name;
				}
				if (displayObject.accessibilityProperties.description) {
					description = displayObject.accessibilityProperties.description;
				}
				if (displayObject.accessibilityProperties.shortcut) {
					shortcut = displayObject.accessibilityProperties.shortcut;
				}
			}
		}

		//--------------------------------------------------------------------------
		//  Event handlers
		//--------------------------------------------------------------------------
	
		/**
         *  @private (protected)
		 *  Generic event handler.
		 *  All MAJGenericAccImpl subclasses must implement this
		 *  to listen for events from their master components. 
		 * 
         *  @param event The event object.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function eventHandler(event:Event):void {
		}
	}
}
