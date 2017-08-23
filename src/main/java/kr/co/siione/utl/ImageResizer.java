package kr.co.siione.utl;
 
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
 
/**
 * This program demonstrates how to resize an image.
 *
 * @author www.codejava.net
 *
 */
public class ImageResizer {
 
    /**
     * Resizes an image to a absolute width and height (the image may not be
     * proportional)
     * @param inputImagePath Path of the original image
     * @param outputImagePath Path to save the resized image
     * @param scaledWidth absolute width in pixels
     * @param scaledHeight absolute height in pixels
     * @throws IOException
     */
    public static void resize(String inputImagePath,
            String outputImagePath, int scaledWidth, int scaledHeight)
            throws IOException {
        // reads input image
        File inputFile = new File(inputImagePath);
        BufferedImage inputImage = ImageIO.read(inputFile);
 
        // creates output image
        //BufferedImage outputImage = new BufferedImage(scaledWidth, scaledHeight, inputImage.getType());
        BufferedImage outputImage = new BufferedImage(scaledWidth, scaledHeight, BufferedImage.TYPE_INT_RGB);
        
        // scales the input image to the output image
        Graphics2D g2d = outputImage.createGraphics();
        //g2d.drawImage(inputImage, 0, 0, scaledWidth, scaledHeight, null);
        g2d.drawImage(inputImage.getScaledInstance(scaledWidth, scaledHeight, Image.SCALE_SMOOTH), 0, 0, scaledWidth, scaledHeight, null);
        g2d.dispose();
        
        // extracts extension of output file
        String formatName = outputImagePath.substring(outputImagePath.lastIndexOf(".") + 1);
 
        // writes to output file
        System.out.println(">>>>>formatName:"+formatName);
        ImageIO.write(outputImage, formatName, new File(outputImagePath));
    }
 
    /**
     * Resizes an image by a percentage of original size (proportional).
     * @param inputImagePath Path of the original image
     * @param outputImagePath Path to save the resized image
     * @param percent a double number specifies percentage of the output image
     * over the input image.
     * @throws IOException
     */
    public static void resize(String inputImagePath,
            String outputImagePath, double percent) throws IOException {
        File inputFile = new File(inputImagePath);
        BufferedImage inputImage = ImageIO.read(inputFile);
        int scaledWidth = (int) (inputImage.getWidth() * percent);
        int scaledHeight = (int) (inputImage.getHeight() * percent);
        resize(inputImagePath, outputImagePath, scaledWidth, scaledHeight);
    }
 
    /**
     * Test resizing images
     */
    public static void main(String[] args) {
        String inputImagePath = "D:/Down/@배경화면/배경화면01.JPG";
        String outputImagePath1 = "D:/Down/@배경화면/배경화면01_Fixed_3.jpg";
        String outputImagePath2 = "D:/Down/@배경화면/배경화면01_Smaller_3.jpg";
        String outputImagePath3 = "D:/Down/@배경화면/배경화면01_Bigger_3.jpg";
 
        try {
            // resize to a fixed width (not proportional)
            int scaledWidth = 1024/10;
            int scaledHeight = 768/10;
            ImageResizer.resize(inputImagePath, outputImagePath1, scaledWidth, scaledHeight);
 
            // resize smaller by 50%
            double percent = 0.5;
            ImageResizer.resize(inputImagePath, outputImagePath2, percent);
 
            // resize bigger by 50%
            percent = 1.5;
            ImageResizer.resize(inputImagePath, outputImagePath3, percent);
 
        } catch (IOException ex) {
            System.out.println("Error resizing the image.");
            ex.printStackTrace();
        }
    }
 
}