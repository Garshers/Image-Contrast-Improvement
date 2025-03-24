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

    % Convert the image to grayscale if it is a color image
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    img = img + 0;

    % Saving images and counting coefficients
    format(img, output_folder, filename, '');

    stretched_img = histogram_stretch(img);
    format(stretched_img, output_folder, filename, '_stretched');

    equalized_img = histeq(img);
    format(equalized_img, output_folder, filename, '_equalized');

    clipped_stretched_img = histogram_stretch_with_clipping(img);
    format(clipped_stretched_img, output_folder, filename, '_clipped_stretched');
end

function stretched_img = histogram_stretch(img)
    % Calculate the minimum and maximum pixel values
    min_val = double(min(img(:)));
    max_val = double(max(img(:)));
    
    % Perform histogram stretching
    stretched_img = uint8(255 * (double(img) - min_val) / (max_val - min_val));
end

function clipped_stretched_img = histogram_stretch_with_clipping(img)
    % Clip the image values
    clipped_img = histeq(img);
    
    % Histogram stretching on the clipped image
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

function generate_histograms(img, filename, output_folder)
    figure;
    imhist(img);
    title(['Histogram: ' filename]);
    saveas(gcf, fullfile(output_folder, [filename(1:end-4) '_hist.png']));
    close(gcf);
end

function modify_image_pixels() % Change one pixel to black and one to white
    % Select an image file
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*.png;*.jpg'}, 'Select image file');
    if isequal(filename, 0)
        disp('User canceled file selection.');
        return;
    end
    
    % Read the image
    img = imread(fullfile(pathname, filename));
    
    % Convert the image to grayscale if it is a color image
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    img = img + 0;
    
    img(1, 1) = 0;
    img(1, 2) = 255;
    
    % Save the modified image
    [~, name, ext] = fileparts(filename);
    new_filename = [name, '_modified', ext];
    imwrite(img, fullfile(pathname, new_filename));
    disp(['Modified image saved as: ', new_filename]);
end

function format(img, output_folder, filename, prefix)
    [k1, k2, k3, k4, min_ox, max_ox] = calculate_coefficients(img);
    filename = [filename(1:end-4) prefix '.png'];
    imwrite(img, fullfile(output_folder, filename)); % save img
    generate_histograms(img, filename, output_folder); % save histogram
    fprintf('Coefficients for %s:\nk1 = %.4f\nk2 = %.4f\nk3 = %.4f\nk4 = %.4f\nmin(Ox) = %d\nmax(Ox) = %d\n\n', filename, k1, k2, k3, k4, min_ox, max_ox);
end

function local_contrast_operation()
    % Select an image
    [filename, pathname] = uigetfile({'*.bmp;*.tiff;*'}, 'Select original image (BMP or TIFF)');
    if isequal(filename, 0)
        fprintf('User cancelled file selection.\n');
        return;
    end

    % Read the image from the selected file
    img = imread(fullfile(pathname, filename));

    % Create the output folder if it doesn't exist
    output_folder = fullfile(pathname, 'latex_data_POC_lab5', 'Task2');
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    % Convert to grayscale if it's a color image
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    img = img + 0;

    % Calculate block dimensions
    n = 4;
    [height, width] = size(img);
    n_height = floor(height / n);
    n_width = floor(width / n);

    % Iterate over blocks
    for i = 1:n
        for j = 1:n
            % Calculate block coordinates
            row_start = (i - 1) * n_height + 1;
            row_end = min(i * n_height, height); % Prevent out-of-bounds access
            col_start = (j - 1) * n_width + 1;
            col_end = min(j * n_width, width); % Prevent out-of-bounds access

            % Extract block
            block = img(row_start:row_end, col_start:col_end);

            % Process block
            processed_block = histogram_stretch_with_clipping(block);

            % Assambly
            end_img(row_start:row_end, col_start:col_end) = processed_block;
        end
    end

    % Format given image
    format(end_img, output_folder, filename, '_local_clipped_stretched');

    % CLAHE Algorythm
    clahe_image = adapthisteq(img,'clipLimit',0.02,'Distribution','rayleigh');
    format(clahe_image, output_folder, filename, '_CLACHE_p1');

    clahe_image = adapthisteq(img,'NumTiles',[8 8],'ClipLimit',0.05);
    format(clahe_image, output_folder, filename, '_CLACHE_p2');
end

%modify_image_pixels();
%histogram_operations();
local_contrast_operation();