﻿package net.majordan.accessibility
{
	import flash.accessibility.Accessibility;
	import flash.accessibility.AccessibilityImplementation;
	import flash.accessibility.AccessibilityProperties;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	
	/**
	 *  The MAJAccImpl class, also called the Accessibility Implementation class, is the base class 
	 *  for the implementation of accessibility in components. This class enables communication between
	 *  a component and a screen reader. Screen readers are used to translate
	 *  screen content into synthesized speech or braille for visually impaired users. 
	 * 
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */ 
	public class MAJAccImpl extends AccessibilityImplementation 
	{
		//--------------------------------------------------------------------------
		//  Class constants
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
         *  Default state for all the components.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_NORMAL:uint = 0x00000000;
	
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_FOCUSABLE:uint = 0x00100000;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_FOCUSED:uint = 0x00000004;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const STATE_SYSTEM_UNAVAILABLE:uint = 0x00000001;
		
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private static const EVENT_OBJECT_NAMECHANGE:uint = 0x800C;


		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
	
		/**
         *  @private (protected)
		 *  A reference to the InteractiveObject instance that this AccImpl instance
         *  is making accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var master:InteractiveObject;
		
		/**
		 *  @private (protected)
		 *  Accessibility Role of the component being made accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected var role:uint;


		//--------------------------------------------------------------------------
		//  Properties
		//--------------------------------------------------------------------------
	
		/**
         *  @private (protected)
         *  All subclasses must override this property by returning an array
         *  of strings that contains the events for which to listen.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function get eventsToHandle():Array {
			return [];
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
			interactiveObject.accessibilityImplementation = new MAJAccImpl(interactiveObject);
		}
	
		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
	
        /**
         * @private
         *
         *  Creates a new Accessibility Implementation instance for the specified component.
		 *
		 *  @param component The InteractiveObject instance that this AccImpl instance
         *  makes accessible.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		public function MAJAccImpl(interactiveObject:InteractiveObject) {
			super();
			stub = false;
			master = interactiveObject;
			
			MAJGenericAccImpl.createAccessibilityImplementation(master as DisplayObject);
			
			// Hookup events to listen for
			var events:Array = eventsToHandle;
			if (events) {
				var n:int = events.length;
				for (var i:int = 0; i < n; i++) {
					master.addEventListener(events[i], eventHandler);
				}
			}
		}

		
		//--------------------------------------------------------------------------
		//  Overridden methods: AccessibilityImplementation
		//--------------------------------------------------------------------------
	
		/**
		 *  @private
		 *  Returns the system role for the component.
		 *
		 *  @param childID The child id.
		 *
         *  @return Role associated with the component.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get_accRole(childID:uint):uint {
			return role;
		}
		
		/**
		 *  @private
		 *  Returns the name of the component.
		 *
		 *  @param childID The child id.
		 *
         *  @return Name of the component.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get_accName(childID:uint):String {
			var accName:String = "";
			if (childID == 0
					&& master.accessibilityProperties 
					&& master.accessibilityProperties.name 
					&& master.accessibilityProperties.name != "") {
				accName += master.accessibilityProperties.name + " ";
			}
			if ( accName.indexOf( getName(childID) ) != 0) {
				accName += getName(childID);
			}
			accName += getStatusName();
			return (accName != null && accName != "") ? accName : null;
		}


		//--------------------------------------------------------------------------
		//  Methods
		//--------------------------------------------------------------------------
	
		/**
         *  @private (protected)
		 *  Returns the name of the accessible component. All subclasses must 
         *  implement this instead of implementing get_accName.
		 * 
		 *  @param childID The child id.
		 * 
         *  @return Name.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function getName(childID:uint):String {
			return null;
		}
		
		/**
         *  @private (protected)
         *  Returns the state of the accessible component.
		 * 
		 *  @param childID The child id.
		 * 
         *  @return State.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function getState(childID:uint):uint {
			var accState:uint = STATE_SYSTEM_NORMAL;
			if (Object(master).hasOwnProperty("enabled") && Object(master).enabled==false) {
				accState |= STATE_SYSTEM_UNAVAILABLE;
			} else {
				accState |= STATE_SYSTEM_FOCUSABLE
				if (master.stage && master == master.stage.focus) {
					accState |= STATE_SYSTEM_FOCUSED;
				}
			}
			return accState;
		}
	
		/**
         *  @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function getStatusName():String {
			return "";
		}


		//--------------------------------------------------------------------------
		//  Event handlers
		//--------------------------------------------------------------------------
	
		/**
         *  @private (protected)
         *  Handles events from the master component.
		 *  All AccImpl subclasses must implement this
		 *  to listen for events from its master component. 
		 * 
         *  @param event The event object.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function eventHandler(event:Event):void
		{
		}
	}
}