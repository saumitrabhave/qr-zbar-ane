package com.sbhave.nativeExtension.ui;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.view.SurfaceView;

import com.adobe.fre.FREContext;
import com.sbhave.nativeExtension.QRExtensionContext;

public class DrawView extends SurfaceView {

	private Paint linePaint = new Paint();
	private QRExtensionContext freCtx = null;
	private final static int LINE_SIZE = 20;
	
	public DrawView(Context context, FREContext ctx) {
		super(context);
		
		freCtx = (QRExtensionContext)ctx;
		
		// Create out paint to use for drawing
		linePaint.setColor(freCtx.getTargetColor());
		linePaint.setStrokeWidth(4);
		linePaint.setStyle(Style.FILL_AND_STROKE);
		
		// This call is necessary, or else the 
		// draw method will not be called. 
		setWillNotDraw(false);
	}
	
	public void setTargetColor(int color){
		linePaint.setColor(color);
	}

	@Override
	protected void onDraw(Canvas canvas){
		// A Simple Text Render to test the display
		
		int tlX = this.getWidth()/2 - freCtx.getTargetSize();
		int tlY = this.getHeight()/2 - freCtx.getTargetSize();
		int trX = this.getWidth()/2 + freCtx.getTargetSize();
		int trY = this.getHeight()/2 - freCtx.getTargetSize();
		int blX = this.getWidth()/2 - freCtx.getTargetSize();
		int blY = this.getHeight()/2 + freCtx.getTargetSize();
		int brX = this.getWidth()/2 + freCtx.getTargetSize();
		int brY = this.getHeight()/2 + freCtx.getTargetSize();
		
		canvas.drawPoint(tlX, tlY, linePaint);
		canvas.drawLine(tlX, tlY, tlX, tlY + LINE_SIZE, linePaint);
		canvas.drawLine(tlX, tlY, tlX + LINE_SIZE, tlY, linePaint);
		
		canvas.drawPoint(trX, trY, linePaint);
		canvas.drawLine(trX, trY, trX, trY + LINE_SIZE, linePaint);
		canvas.drawLine(trX, trY, trX - LINE_SIZE, trY, linePaint);
		
		canvas.drawPoint(blX, blY, linePaint);
		canvas.drawLine(blX, blY, blX, blY - LINE_SIZE, linePaint);
		canvas.drawLine(blX, blY, blX + LINE_SIZE, blY, linePaint);
		
		canvas.drawPoint(brX, brY, linePaint);
		canvas.drawLine(brX, brY, brX, brY - LINE_SIZE, linePaint);
		canvas.drawLine(brX, brY, brX - LINE_SIZE, brY, linePaint);
		
	}

}
