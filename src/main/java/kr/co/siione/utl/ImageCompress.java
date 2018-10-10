package kr.co.siione.utl;
 
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.util.Iterator;
import javax.imageio.*;
import javax.imageio.stream.*;
import java.io.IOException;

/**
 * This program demonstrates how to resize an image.
 *
 * @author www.codejava.net
 *
 */
public class ImageCompress {
	public static void toJpg(byte [] bytes, String outFile, int percent) {
		try {	
		  //read image file
			BufferedImage bufferedImage = ImageIO.read(new ByteArrayInputStream(bytes));

		  // create a blank, RGB, same width and height, and a white background
		  BufferedImage newBufferedImage = new BufferedImage(bufferedImage.getWidth(),
				bufferedImage.getHeight(), BufferedImage.TYPE_INT_RGB);
		  newBufferedImage.createGraphics().drawImage(bufferedImage, 0, 0, Color.white, null);

		  // write to jpeg file
		  //ImageIO.write(newBufferedImage, "jpg", new File(tempFile));

		  
		  // 압축
	    	Iterator iter = ImageIO.getImageWritersByFormatName("jpeg");
	    	ImageWriter writer = (ImageWriter)iter.next();
	    	
	    	ImageWriteParam iwp = writer.getDefaultWriteParam();
	    	iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
	    	iwp.setCompressionQuality(percent / 100.0f);   // an integer between 0 and 1
	    	// 1 specifies minimum compression and maximum quality

	    	File file = new File(outFile);
	    	FileImageOutputStream output = new FileImageOutputStream(file);
	    	writer.setOutput(output);
	    	
	        IIOImage image = new IIOImage(newBufferedImage, null, null);
	    	writer.write(null, image, iwp);
	    	writer.dispose();		  
		  
		  System.out.println("Done");
				
		} catch (IOException e) {
		  e.printStackTrace();
		}
	}
	
    public static void compress(String inputImagePath,
            String outputImagePath)
            throws IOException {
    	Iterator iter = ImageIO.getImageWritersByFormatName("jpeg");
    	ImageWriter writer = (ImageWriter)iter.next();
    	
    	ImageWriteParam iwp = writer.getDefaultWriteParam();
    	iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
    	iwp.setCompressionQuality(0.2f);   // an integer between 0 and 1
    	// 1 specifies minimum compression and maximum quality

    	// reads input image
        File inputFile = new File(inputImagePath);
    	BufferedImage inputImage = ImageIO.read(inputFile);

    	File file = new File(outputImagePath);
    	FileImageOutputStream output = new FileImageOutputStream(file);
    	writer.setOutput(output);
    	
        IIOImage image = new IIOImage(inputImage, null, null);
    	writer.write(null, image, iwp);
    	writer.dispose();		  
	  
    }
}