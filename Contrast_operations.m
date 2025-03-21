function histogram_operations()
    % select an img
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*'}, 'Select original image (BMP or TIFF)');
    if isequal(filename, 0)
        fprintf('User cancelled file selection.\n');
        return;
    end
    
    % Read the image from the selected file
    img = imread(fullfile(pathname, filename));
    
    % Create the output folder if it doesn't exist
    output_folder = fullfile(pathname, 'latex_data_POC_lab5', 'Task1');
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    copyfile(fullfile(pathname, filename), fullfile(output_folder, filename)); % save oryginal

    % Convert the image to grayscale if it is a color image
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    stretched_img = histogram_stretch(img);
    [k1, k2, k3, k4, min_ox, max_ox] = calculate_coefficients(stretched_img);
    stretched_filename = [filename(1:end-4) '_stretched' '.png'];
    imwrite(stretched_img, fullfile(output_folder, stretched_filename));
    fprintf('Coefficients for %s:\nk1 = %.4f\nk2 = %.4f\nk3 = %.4f\nk4 = %.4f\nmin(Ox) = %d\nmax(Ox) = %d\n\n', stretched_filename, k1, k2, k3, k4, min_ox, max_ox);
    
    equalized_img = histeq(img);
    [k1, k2, k3, k4, min_ox, max_ox] = calculate_coefficients(equalized_img);
    equalized_filename = [filename(1:end-4) '_equalized' '.png'];
    imwrite(equalized_img, fullfile(output_folder, equalized_filename));
    fprintf('Coefficients for %s:\nk1 = %.4f\nk2 = %.4f\nk3 = %.4f\nk4 = %.4f\nmin(Ox) = %d\nmax(Ox) = %d\n\n', equalized_filename, k1, k2, k3, k4, min_ox, max_ox);
    
    clipped_stretched_img = histogram_stretch_with_clipping(img, 0.02);
    [k1, k2, k3, k4, min_ox, max_ox] = calculate_coefficients(clipped_stretched_img);
    clipped_stretched_filename = [filename(1:end-4) '_clipped_stretched' '.png'];
    imwrite(clipped_stretched_img, fullfile(output_folder, clipped_stretched_filename));
    fprintf('Coefficients for %s:\nk1 = %.4f\nk2 = %.4f\nk3 = %.4f\nk4 = %.4f\nmin(Ox) = %d\nmax(Ox) = %d\n\n', clipped_stretched_filename, k1, k2, k3, k4, min_ox, max_ox);
end

function stretched_img = histogram_stretch(img)
    % Calculate the minimum and maximum pixel values
    min_val = double(min(img(:)));
    max_val = double(max(img(:)));
    
    % Perform histogram stretching
    stretched_img = uint8(255 * (double(img) - min_val) / (max_val - min_val));
end

function clipped_stretched_img = histogram_stretch_with_clipping(img, clip_percent)
    % Calculate the histogram of the image
    hist_counts = imhist(img);
    
    % Calculate the total number of pixels
    total_pixels = sum(hist_counts);
    
    % Calculate the number of pixels to clip on each side
    clip_count = round(total_pixels * clip_percent);
    
    % Find the lower and upper clipping values
    lower_clip = find(cumsum(hist_counts) >= clip_count, 1, 'first') - 1;
    upper_clip = find(cumsum(hist_counts) <= total_pixels - clip_count, 1, 'last') - 1;
    
    % Clip the image values
    clipped_img = img;
    clipped_img(clipped_img < lower_clip) = lower_clip;
    clipped_img(clipped_img > upper_clip) = upper_clip;
    
    % Perform histogram stretching on the clipped image
    clipped_stretched_img = histogram_stretch(clipped_img);
end

function [k1, k2, k3, k4, min_ox, max_ox] = calculate_coefficients(img)
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    img_double = double(img);
    

    [M, N] = size(img);
    
    % Calculate min(Ox) and max(Ox)
    min_ox = min(img_double(:));
    max_ox = max(img_double(:));
    
    % Calculate Michelson variables
    k1 = (max_ox - min_ox) / 255;
    mean_val = mean(img_double(:));
    k2 = (max_ox - min_ox) / mean_val;
    k3 = (max_ox - min_ox) / (min_ox + max_ox);
    k4 = (4 / (255^2 * M * N)) * sum((img_double(:) - mean_val).^2);
end