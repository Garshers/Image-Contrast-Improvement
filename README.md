# Image Histogram Processing and Coefficient Calculation

This MATLAB script processes images by applying histogram stretching, histogram equalization, and clipped histogram stretching. It then calculates and displays several coefficients related to the image's pixel intensity distribution.

## Functions

### `histogram_operations()`

This function orchestrates the image processing and coefficient calculation. It performs the following steps:

1.  **Selects an Image:** Prompts the user to select a BMP or TIFF image file.
2.  **Reads the Image:** Loads the selected image into MATLAB.
3.  **Creates Output Folder:** Creates a folder named `latex_data_POC_lab5/Task1` to store processed images.
4.  **Saves Original Image:** Copies the original image to the output folder.
5.  **Converts to Grayscale:** Converts the image to grayscale if it is a color image.
6.  **Applies Histogram Stretching:**
    * Calls `histogram_stretch()` to stretch the image's histogram.
    * Calls `calculate_coefficients()` to compute coefficients for the stretched image.
    * Saves the stretched image as a PNG file.
    * Displays the calculated coefficients in the command window.
7.  **Applies Histogram Equalization:**
    * Calls `histeq()` to equalize the image's histogram.
    * Calls `calculate_coefficients()` to compute coefficients for the equalized image.
    * Saves the equalized image as a PNG file.
    * Displays the calculated coefficients in the command window.
8.  **Applies Clipped Histogram Stretching:**
    * Calls `histogram_stretch_with_clipping()` to stretch the histogram with clipping.
    * Calls `calculate_coefficients()` to compute coefficients for the clipped stretched image.
    * Saves the clipped stretched image as a PNG file.
    * Displays the calculated coefficients in the command window.

### `stretched_img = histogram_stretch(img)`

This function stretches the histogram of an input image.

1.  **Calculates Min/Max:** Determines the minimum and maximum pixel values in the image.
2.  **Stretches Histogram:** Linearly scales the pixel values to fill the full 0-255 range.

### `clipped_stretched_img = histogram_stretch_with_clipping(img, clip_percent)`

This function stretches the histogram after clipping a specified percentage of pixels from the tails of the histogram.

1.  **Calculates Histogram:** Computes the image's histogram.
2.  **Calculates Clip Count:** Determines the number of pixels to clip from each tail.
3.  **Finds Clip Values:** Finds the pixel values corresponding to the clipping points.
4.  **Clips Image:** Clips the pixel values outside the clipping range.
5.  **Stretches Clipped Image:** Calls `histogram_stretch()` to stretch the histogram of the clipped image.

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

## Usage

1.  Open MATLAB.
2.  Copy the script into a new MATLAB script file.
3.  Run the `histogram_operations()` function.
4.  Select an image file when prompted.
5.  The processed images and calculated coefficients will be saved in the `latex_data_POC_lab5/Task1` folder.
6.  The coefficients will also be displayed in the MATLAB command window.