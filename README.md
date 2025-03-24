# Image Histogram Processing and Local Contrast Enhancement

This MATLAB script processes images by applying histogram stretching, histogram equalization, clipped histogram stretching and local contrast enhancement. It also calculates and displays several coefficients related to the image's pixel intensity distribution.

## Functions

### `histogram_operations()`

This function orchestrates the image processing and coefficient calculation for basic histogram manipulations. It performs the following steps:

1.  **Selects an Image:** Prompts the user to select a BMP or TIFF image file.
2.  **Reads the Image:** Loads the selected image into MATLAB.
3.  **Creates Output Folder:** Creates a folder named `latex_data_POC_lab5/Task1` to store processed images.
4.  **Converts to Grayscale:** Converts the image to grayscale if it is a color image.
5.  **Saves Original Image and Histogram:** Calls `format()` to save the original image, its histogram, and calculate coefficients.
6.  **Applies Histogram Stretching:**
    * Calls `histogram_stretch()` to stretch the image's histogram.
    * Calls `format()` to save the stretched image, its histogram, and calculate coefficients.
7.  **Applies Histogram Equalization:**
    * Calls `histeq()` to equalize the image's histogram.
    * Calls `format()` to save the equalized image, its histogram, and calculate coefficients.
8.  **Applies Clipped Histogram Stretching:**
    * Calls `histogram_stretch_with_clipping()` to stretch the histogram with clipping.
    * Calls `format()` to save the clipped stretched image, its histogram, and calculate coefficients.

### `stretched_img = histogram_stretch(img)`

This function stretches the histogram of an input image.

1.  **Calculates Min/Max:** Determines the minimum and maximum pixel values in the image.
2.  **Stretches Histogram:** Linearly scales the pixel values to fill the full 0-255 range.

### `clipped_stretched_img = histogram_stretch_with_clipping(img)`

This function stretches the histogram after applying histogram equalization.

1.  **Equalizes Image:** Calls `histeq()` to equalize the image's histogram.
2.  **Stretches Equalized Image:** Calls `histogram_stretch()` to stretch the histogram of the equalized image.

### `[k1, k2, k3, k4, min_ox, max_ox] = calculate_coefficients(img)`

This function calculates several coefficients related to the image's pixel intensity distribution.

1.  **Converts to Grayscale (if necessary):** Converts the image to grayscale if it is a color image.
2.  **Converts to Double:** Converts the image to double-precision floating-point for calculations.
3.  **Calculates Min/Max:** Determines the minimum and maximum pixel values.
4.  **Calculates Coefficients:**
    * `k1`: Michelson contrast, normalized to 0-255.
    * `k2`: Contrast relative to the mean pixel value.
    * `k3`: Contrast based on the ratio of difference to sum of min and max.
    * `k4`: Variance of pixel values, normalized.
    * `min_ox`: Minimum pixel value.
    * `max_ox`: Maximum pixel value.

### `generate_histograms(img, filename, output_folder)`

This function generates and saves the histogram of an image.

1.  **Generates Histogram:** Creates a histogram plot of the image.
2.  **Saves Histogram:** Saves the histogram plot as a PNG file.
3.  **Closes Figure:** Closes the histogram figure.

### `modify_image_pixels()`

This function modifies an image by setting one pixel to black and another to white.

1.  **Selects an Image:** Prompts the user to select an image file.
2.  **Reads the Image:** Loads the selected image into MATLAB.
3.  **Converts to Grayscale (if necessary):** Converts the image to grayscale if it is a color image.
4.  **Modifies Pixels:** Sets pixel (1, 1) to 0 (black) and pixel (1, 2) to 255 (white).
5.  **Saves Modified Image:** Saves the modified image as a new file.

### `format(img, output_folder, filename, prefix)`

This function saves an image, its histogram, and displays the calculated coefficients.

1.  **Calculates Coefficients:** Calls `calculate_coefficients()` to compute coefficients.
2.  **Modifies Filename:** Appends a prefix to the filename.
3.  **Saves Image:** Saves the image as a PNG file.
4.  **Generates and Saves Histogram:** Calls `generate_histograms()` to save the histogram.
5.  **Displays Coefficients:** Displays the calculated coefficients in the command window.

### `local_contrast_operation()`

This function applies local contrast enhancement to an image using histogram stretching and CLAHE.

1.  **Selects an Image:** Prompts the user to select an image file.
2.  **Reads the Image:** Loads the selected image into MATLAB.
3.  **Creates Output Folder:** Creates a folder named `latex_data_POC_lab5/Task2` to store processed images.
4.  **Converts to Grayscale (if necessary):** Converts the image to grayscale if it is a color image.
5.  **Divides Image into Blocks:** Splits the image into $n \times n$ blocks.
6.  **Processes Each Block:**
    * Applies `histogram_stretch_with_clipping()` to each block.
    * Assembles the processed blocks into a new image.
7.  **Saves Processed Image:** Calls `format()` to save the locally stretched image.
8.  **Applies CLAHE:**
    * Applies CLAHE with different parameters and saves the results.

## Usage

1.  Open MATLAB.
2.  Copy the script into a new MATLAB script file.
3.  Run the desired function (`histogram_operations()`, `modify_image_pixels()`, or `local_contrast_operation()`).
4.  Select an image file when prompted.
5.  The processed images and calculated coefficients will be saved in the specified output folders.
6.  The coefficients will also be displayed in the MATLAB command window.