package com.sbhave.nativeExtensions.zbar
{
	public final class Config
	{
		public function Config()
		{
			throw new Error("This class should not be instantiated.");
		}
		
		/*
		 * See:
		 * http://zbar.sourceforge.net/iphone/sdkdoc/ZBarImageScanner.html
		 * For details about these config parameters and whether they apply for indivisual symbologies or all at once
		 *
		 */
		
		/** Enable symbology/feature. */
		public static const  ENABLE:int = 0;
		
		/** Enable check digit when optional. */
		public static const ADD_CHECK:int = 1;
		
		/** Return check digit when present. */
		public static const EMIT_CHECK:int = 2;
		
		/** Enable full ASCII character set. */
		public static const ASCII:int = 3;
		
		/** Minimum data length for valid decode. */
		public static const MIN_LEN:int = 0x20;
		
		/** Maximum data length for valid decode. */
		public static const MAX_LEN:int = 0x21;
		
		/** Required video consistency frames. */
		public static const UNCERTAINTY:int = 0x40;
		
		/** Enable scanner to collect position data. */
		public static const POSITION:int = 0x80;
		
		/** Image scanner vertical scan density. */
		public static const X_DENSITY:int = 0x100;
		
		/** Image scanner horizontal scan density. */
		public static const Y_DENSITY:int = 0x101;
	}
}