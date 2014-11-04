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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/net/sourceforge/zbar/SymbolSet.java
 */

package net.sourceforge.zbar;

/** Immutable container for decoded result symbols associated with an image
 * or a composite symbol.
 */
public class SymbolSet
    extends java.util.AbstractCollection<Symbol>
{
    /** C pointer to a zbar_symbol_set_t. */
    private long peer;

    static
    {
    	System.loadLibrary("iconv");
        System.loadLibrary("zbarjni");
        init();
    }
    private static native void init();

    /** SymbolSets are only created by other package methods. */
    SymbolSet (long peer)
    {
        this.peer = peer;
    }

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

    /** Release the associated peer instance.  */
    private native void destroy(long peer);

    /** Retrieve an iterator over the Symbol elements in this collection. */
    public java.util.Iterator<Symbol> iterator ()
    {
        long sym = firstSymbol(peer);
        if(sym == 0)
            return(new SymbolIterator(null));

        return(new SymbolIterator(new Symbol(sym)));
    }

    /** Retrieve the number of elements in the collection. */
    public native int size();

    /** Retrieve C pointer to first symbol in the set. */
    private native long firstSymbol(long peer);
}
