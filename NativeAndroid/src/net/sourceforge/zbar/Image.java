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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/net/sourceforge/zbar/Image.java
 */

package net.sourceforge.zbar;

/** stores image data samples along with associated format and size
 * metadata.
 */
public class Image
{
    /** C pointer to a zbar_symbol_t. */
    private long peer;
    private Object data;

    static
    {
    	System.loadLibrary("iconv");
        System.loadLibrary("zbarjni");
        init();
    }
    private static native void init();

    public Image ()
    {
        peer = create();
    }

    public Image (int width, int height)
    {
        this();
        setSize(width, height);
    }

    public Image (int width, int height, String format)
    {
        this();
        setSize(width, height);
        setFormat(format);
    }

    public Image (String format)
    {
        this();
        setFormat(format);
    }

    Image (long peer)
    {
        this.peer = peer;
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

    /** Image format conversion.
     * @returns a @em new image with the sample data from the original
     * image converted to the requested format fourcc.  the original
     * image is unaffected.
     */
    public Image convert (String format)
    {
        long newpeer = convert(peer, format);
        if(newpeer == 0)
            return(null);
        return(new Image(newpeer));
    }

    private native long convert(long peer, String format);

    /** Retrieve the image format fourcc. */
    public native String getFormat();

    /** Specify the fourcc image format code for image sample data. */
    public native void setFormat(String format);

    /** Retrieve a "sequence" (page/frame) number associated with this
     * image.
     */
    public native int getSequence();

    /** Associate a "sequence" (page/frame) number with this image. */
    public native void setSequence(int seq);

    /** Retrieve the width of the image. */
    public native int getWidth();

    /** Retrieve the height of the image. */
    public native int getHeight();

    /** Retrieve the size of the image. */
    public native int[] getSize();

    /** Specify the pixel size of the image. */
    public native void setSize(int width, int height);

    /** Specify the pixel size of the image. */
    public native void setSize(int[] size);

    /** Retrieve the crop region of the image. */
    public native int[] getCrop();

    /** Specify the crop region of the image. */
    public native void setCrop(int x, int y, int width, int height);

    /** Specify the crop region of the image. */
    public native void setCrop(int[] crop);

    /** Retrieve the image sample data. */
    public native byte[] getData();

    /** Specify image sample data. */
    public native void setData(byte[] data);

    /** Specify image sample data. */
    public native void setData(int[] data);

    /** Retrieve the decoded results associated with this image. */
    public SymbolSet getSymbols ()
    {
        return(new SymbolSet(getSymbols(peer)));
    }

    private native long getSymbols(long peer);

}
