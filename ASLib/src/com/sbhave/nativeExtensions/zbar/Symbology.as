/*
 * Copyright (c) 2014 Saumitra R Bhave
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * File : /Users/saumib/projects/repos/qr-zbar-ane/ASLib/src/com/sbhave/nativeExtensions/zbar/Symbology.as
 */

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