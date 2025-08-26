clc; clear; close all;
%% Capture Images from Webcam
cam = webcam;
disp('Get ready for reference image...');
pause;  % Wait for user input
ref_img_raw = snapshot(cam);
disp('Get ready for test image...');
pause;  % Wait for user input
test_img_raw = snapshot(cam);
clear cam;
%% Display Captured Input Images Together
figure('Name', 'Captured Input Images');
subplot(1,2,1), imshow(ref_img_raw), title('Reference Image');
subplot(1,2,2), imshow(test_img_raw), title('Test Image');
%% Preprocess Images
ref_img = rgb2gray(ref_img_raw);
test_img = rgb2gray(test_img_raw);
ref_img = imresize(ref_img, [256, 256]);
test_img = imresize(test_img, [256, 256]);
ref_img = wiener2(ref_img, [5 5]);
test_img = wiener2(test_img, [5 5]);
ref_img = adapthisteq(ref_img);
test_img = adapthisteq(test_img);
%% LBP Features
lbp_ref = extractLBPFeatures(ref_img);
lbp_test = extractLBPFeatures(test_img);
ncc_value = corr2(lbp_ref, lbp_test);
%% DFT Features
ref_dft = fft2(double(ref_img));
test_dft = fft2(double(test_img));
low_freq_ref = abs(ref_dft(1:32, 1:32));
low_freq_test = abs(test_dft(1:32, 1:32));
feature_ref = low_freq_ref(:) / max(low_freq_ref(:));
feature_test = low_freq_test(:) / max(low_freq_test(:));
ncc_dft = corr2(feature_ref, feature_test);
%% SSIM Calculation
window = fspecial('gaussian', [11 11], 1.5);
C1 = (0.01 * 255)^2;
C2 = (0.03 * 255)^2;
mu1 = imfilter(double(ref_img), window, 'replicate');
mu2 = imfilter(double(test_img), window, 'replicate');
sigma1_sq = imfilter(double(ref_img).^2, window, 'replicate') - mu1.^2;
sigma2_sq = imfilter(double(test_img).^2, window, 'replicate') - mu2.^2;
sigma12 = imfilter(double(ref_img) .* double(test_img), window, 'replicate') - mu1 .* mu2;
ssim_map = ((2 * mu1 .* mu2 + C1) .* (2 * sigma12 + C2)) ./ ...
         ((mu1.^2 + mu2.^2 + C1) .* (sigma1_sq + sigma2_sq + C2));
    
ssim_value = mean(ssim_map(:));
%% Final Match Score
match_score = (0.4 * ssim_value) + (0.3 * ncc_value) + (0.3 * ncc_dft);
disp(['SSIM Score: ', num2str(ssim_value * 100), '%']);
disp(['NCC Score (LBP): ', num2str(ncc_value * 100), '%']);
disp(['NCC Score (DFT): ', num2str(ncc_dft * 100), '%']);
disp(['Final Match Score: ', num2str(match_score * 100), '%']);
if match_score > 0.70
   disp('✅ Faces Match!');
else
   disp('❌ Faces Do Not Match.');
end
%% Visualization
figure('Name', 'Face Comparison');
subplot(2,3,1), imshow(ref_img, []), title('Reference Face');
subplot(2,3,2), imshow(test_img, []), title('Test Face');
subplot(2,3,3), imshow(log(1 + abs(ref_dft)), []), title('DFT Spectrum (Reference)');
subplot(2,3,4), imshow(log(1 + abs(test_dft)), []), title('DFT Spectrum (Test)');
