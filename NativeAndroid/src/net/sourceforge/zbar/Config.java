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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/net/sourceforge/zbar/Config.java
 */

package net.sourceforge.zbar;

/** Decoder configuration options.
 */
public class Config
{
    /** Enable symbology/feature. */
    public static final int ENABLE = 0;
    /** Enable check digit when optional. */
    public static final int ADD_CHECK = 1;
    /** Return check digit when present. */
    public static final int EMIT_CHECK = 2;
    /** Enable full ASCII character set. */
    public static final int ASCII = 3;

    /** Minimum data length for valid decode. */
    public static final int MIN_LEN = 0x20;
    /** Maximum data length for valid decode. */
    public static final int MAX_LEN = 0x21;

    /** Required video consistency frames. */
    public static final int UNCERTAINTY = 0x40;

    /** Enable scanner to collect position data. */
    public static final int POSITION = 0x80;

    /** Image scanner vertical scan density. */
    public static final int X_DENSITY = 0x100;
    /** Image scanner horizontal scan density. */
    public static final int Y_DENSITY = 0x101;
}
