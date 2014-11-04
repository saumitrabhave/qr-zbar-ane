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
 * File : /Users/saumib/projects/repos/qr-zbar-ane/NativeAndroid/src/net/sourceforge/zbar/SymbolIterator.java
 */

package net.sourceforge.zbar;

/** Iterator over a SymbolSet.
 */
public class SymbolIterator
    implements java.util.Iterator<Symbol>
{
    /** Next symbol to be returned by the iterator. */
    private Symbol current;

    /** SymbolIterators are only created by internal interface methods. */
    SymbolIterator (Symbol first)
    {
        current = first;
    }

    /** Returns true if the iteration has more elements. */
    public boolean hasNext ()
    {
        return(current != null);
    }

    /** Retrieves the next element in the iteration. */
    public Symbol next ()
    {
        if(current == null)
            throw(new java.util.NoSuchElementException
                  ("access past end of SymbolIterator"));

        Symbol result = current;
        long sym = current.next();
        if(sym != 0)
            current = new Symbol(sym);
        else
            current = null;
        return(result);
    }

    /** Raises UnsupportedOperationException. */
    public void remove ()
    {
        throw(new UnsupportedOperationException
              ("SymbolIterator is immutable"));
    }
}
