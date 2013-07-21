package com.sbhave.nativeExtensions.zbar
{
	public final class Symbology
	{
		public function Symbology()
		{
			throw new Error("This class should not be instantiated.");
		}
		
		/** No symbol decoded. */
		public static const  ALL:int = 0;
		
		/** EAN-8. */
		public static const  EAN8:int = 8;
		
		/** UPC-E. */
		public static const  UPCE:int = 9;
		
		/** ISBN-10 (from EAN-13). */
		public static const  ISBN10:int = 10;
		
		/** UPC-A. */
		public static const  UPCA:int = 12;
		
		/** EAN-13. */
		public static const  EAN13:int = 13;
		
		/** ISBN-13 (from EAN-13). */
		public static const  ISBN13:int = 14;
		
		/** erleaved 2 of 5. */
		public static const  I25:int = 25;
		
		/** DataBar (RSS-14). */
		public static const  DATABAR:int = 34;
		
		/** DataBar Expanded. */
		public static const  DATABAR_EXP:int = 35;
		
		/** Codabar. */
		public static const  CODABAR:int = 38;
		
		/** Code 39. */
		public static const  CODE39:int= 39;
		
		/** PDF417. */
		public static const  PDF417:int = 57;
		
		/** QR Code. */
		public static const  QRCODE:int = 64;
		
		/** Code 93. */
		public static const  CODE93:int = 93;
		
		/** Code 128. */
		public static const  CODE128:int = 128;
	}
}