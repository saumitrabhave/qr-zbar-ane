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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/ASLib/src/com/sbhave/nativeExtensions/zbar/Config.as
 */

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