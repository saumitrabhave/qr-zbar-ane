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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/net/sourceforge/zbar/ImageScanner.java
 */

package net.sourceforge.zbar;

/** Read barcodes from 2-D images.
 */
public class ImageScanner
{
    /** C pointer to a zbar_image_scanner_t. */
    private long peer;

    static
    {
    	System.loadLibrary("iconv");
        System.loadLibrary("zbarjni");
        init();
    }
    private static native void init();

    public ImageScanner ()
    {
        peer = create();
    }

    /** Create an associated peer instance. */
    private native long create();

    protected void finalize ()
    {
        destroy();
    }

    /** Clean up native data associated with an instance. */
    public synchronized void destroy ()
    {
        if(peer != 0) {
            destroy(peer);
            peer = 0;
        }
    }

    /** Destroy the associated peer instance.  */
    private native void destroy(long peer);

    /** Set config for indicated symbology (0 for all) to specified value.
     */
    public native void setConfig(int symbology, int config, int value)
        throws IllegalArgumentException;

    /** Parse configuration string and apply to image scanner. */
    public native void parseConfig(String config);

    /** Enable or disable the inter-image result cache (default disabled).
     * Mostly useful for scanning video frames, the cache filters duplicate
     * results from consecutive images, while adding some consistency
     * checking and hysteresis to the results.  Invoking this method also
     * clears the cache.
     */
    public native void enableCache(boolean enable);

    /** Retrieve decode results for last scanned image.
     * @returns the SymbolSet result container
     */
    public SymbolSet getResults ()
    {
        return(new SymbolSet(getResults(peer)));
    }

    private native long getResults(long peer);

    /** Scan for symbols in provided Image.
     * The image format must currently be "Y800" or "GRAY".
     * @returns the number of symbols successfully decoded from the image.
     */
    public native int scanImage(Image image);
}
