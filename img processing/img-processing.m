

%---------P2---------------

% Read grayscale images
highfreq = im2double(im2gray(imread('HP.png')));
lowfreq = im2double(im2gray(imread('LP.png')));
imwrite(highfreq,'HP.png');
imwrite(lowfreq,'LP.png');

%Fourier Transform 
hpfou = (fftshift(abs(fft2(highfreq))));
lpfou = (fftshift(abs(fft2(lowfreq))));

hpfou = hpfou / 50; %adjusted brightness
lpfou = lpfou / 50;
figure; imshow(hpfou); title('HP Frequency Response');
figure; imshow(lpfou); title('LP Frequency Response');
imwrite(hpfou, 'HP-freq.png'); 
imwrite(lpfou, 'LP-freq.png');

%---------P3---------------

% Define Gaussian kernel with std = 2.5
gauskern = fspecial('gaussian', 33, 2.5);
figure; surf(gauskern); title('Gaussian Kernel');
saveas(gcf, 'gaus-surf.png');

% Define Sobel kernel in one direction 
sob_x =[-1 0 1; -2 0 2; -1 0 1];

% Define DoG kernel by convolving Gaussian with Sobel
dog_kernel= conv2(gauskern, sob_x); 
figure; surf(dog_kernel); title('DoG Kernel');
saveas(gcf, 'dog-surf.png');

% Apply Gaussian filter in spatial domain
gaushp = imfilter(highfreq, gauskern);
gauslp = imfilter(lowfreq, gauskern);
figure; imshow(gaushp); title('HP Gaussian Filtered');
figure; imshow(gauslp); title('LP Gaussian Filtered');
imwrite(gaushp, 'HP-filt.png'); %save the result 
imwrite(gauslp, 'LP-filt.png');

%Compute the frequency domain
HP_filt_freq = fftshift(abs(fft2(gaushp))) / 50;  
LP_filt_freq = fftshift(abs(fft2(gauslp))) / 50; 
figure; imshow(HP_filt_freq); title('HP Gaussian Frequency');
figure; imshow(LP_filt_freq); title('LP Gaussian Frequency');
imwrite(HP_filt_freq, 'HP-filt-freq.png'); 
imwrite(LP_filt_freq, 'LP-filt-freq.png');

%Apply fourier transform of the DoG kernels(500*500)
dog_fou = fft2(dog_kernel, 500, 500);
HP_dogfit_filt_freq = dog_fou .* fft2(highfreq); 
LP_dogfit_filt_freq = dog_fou .* fft2(lowfreq); 

%Compute the frequency domain
HP_dogfilt_freq = abs(fftshift(HP_dogfit_filt_freq)) / 50; 
LP_dogfilt_freq = abs(fftshift(LP_dogfit_filt_freq)) / 50;
figure; imshow(HP_dogfilt_freq); title('HP DoG Filtered Frequency');
figure; imshow(LP_dogfilt_freq); title('LP DoG Filtered Frequency');
imwrite(HP_dogfilt_freq, 'HP-dogfilt-freq.png'); 
imwrite(LP_dogfilt_freq, 'LP-dogfilt-freq.png');

%Convert back to spatial domain
HP_dogfilt = ifft2(HP_dogfit_filt_freq)*2; 
LP_dogfilt = ifft2(LP_dogfit_filt_freq)*2;
figure; imshow(HP_dogfilt); title('HP DoG Filtered');
figure; imshow(LP_dogfilt); title('LP DoG Filtered');
imwrite(HP_dogfilt, 'HP-dogfilt.png'); 
imwrite(LP_dogfilt, 'LP-dogfilt.png');



%---------P4---------------

% Subsample images half
sub2_hp = highfreq(1:2:end, 1:2:end); 
sub2_lp = lowfreq(1:2:end, 1:2:end); 
figure; imshow(sub2_hp); title('HP Subsampled 1:2');
figure; imshow(sub2_lp); title('LP Subsampled 1:2');
imwrite(sub2_hp, 'HP-sub2.png'); 
imwrite(sub2_lp, 'LP-sub2.png');

% Compute frequency domain 
LP_sub2_freq = abs(fftshift(fft2(sub2_lp, 500, 500))) / 50; 
HP_sub2_freq = abs(fftshift(fft2(sub2_hp, 500, 500))) / 50;
figure; imshow(HP_sub2_freq); title('HP Subsampled 1:2 Frequency Response');
figure; imshow(LP_sub2_freq); title('LP Subsampled 1:2 Frequency Response');
imwrite(LP_sub2_freq, 'LP-sub2-freq.png'); 
imwrite(HP_sub2_freq, 'HP-sub2-freq.png');


% Subsample images quarter
sub4_hp = highfreq(1:4:end, 1:4:end);
sub4_lp = lowfreq(1:4:end, 1:4:end);
figure; imshow(sub4_hp); title('HP Subsampled 1:4');
figure; imshow(sub4_lp); title('LP Subsampled 1:4');
imwrite(sub4_hp, 'HP-sub4.png'); 
imwrite(sub4_lp, 'LP-sub4.png');

% Compute frequency domain 
LP_sub4_freq = abs(fftshift(fft2(sub4_lp, 500, 500))) / 50; 
HP_sub4_freq = abs(fftshift(fft2(sub4_hp, 500, 500))) / 50;
figure; imshow(HP_sub4_freq); title('HP Subsampled 1:4 Frequency Response');
figure; imshow(LP_sub4_freq); title('LP Subsampled 1:4 Frequency Response');
imwrite(LP_sub4_freq, 'LP-sub4-freq.png'); 
imwrite(HP_sub4_freq, 'HP-sub4-freq.png');

% Apply antialiasing 
% Define 2 Gaussian filters for half and quarter
gaussian_kernel_sub2 = fspecial('gaussian', 30, 5); 
gaussian_kernel_sub4 = fspecial('gaussian', 15, 2.5);

% Apply Gaussian filters
HP_gaus_sub2 = imfilter(highfreq, gaussian_kernel_sub2); 
HP_gaus_sub4 = imfilter(highfreq, gaussian_kernel_sub4);

%Take sample
HP_sub2_aa = HP_gaus_sub2(1:2:end, 1:2:end); 
HP_sub4_aa = HP_gaus_sub2(1:4:end, 1:4:end);
figure; imshow(HP_sub2_aa); title('HP Subsampled 1:2 with AA');
figure; imshow(HP_sub4_aa); title('HP Subsampled 1:4 with AA');
imwrite(HP_sub2_aa, 'HP-sub2-aa.png'); 
imwrite(HP_sub4_aa, 'HP-sub4-aa.png');

% Frequency domain representation
HP_sub2_aa_freq = abs(fftshift(fft2(HP_sub2_aa, 500, 500))) / 50; 
HP_sub4_aa_freq = abs(fftshift(fft2(HP_sub4_aa, 500, 500))) / 50;
figure; imshow(HP_sub2_aa_freq); title('HP Subsampled 1:2 with AA - Frequency Domain');
figure; imshow(HP_sub4_aa_freq); title('HP Subsampled 1:4 with AA - Frequency Domain');
imwrite(HP_sub2_aa_freq, 'HP-sub2-aa-freq.png'); 
imwrite(HP_sub4_aa_freq, 'HP-sub4-aa-freq.png');


%---------P5---------------

% Canny edge detection on HP
[cannyedge_hp, Thresh_hp] = edge(highfreq, 'canny');

% Optimal
hp_edge_opt = edge(highfreq, 'canny', [0.08, 0.25]);
figure; imshow(hp_edge_opt); title('Canny Edge Optimal');
imwrite(hp_edge_opt, 'HP-canny-optimal.png');

% Low-Low
hp_edge_ll = edge(highfreq, 'canny', [0.05, 0.2]);
figure; imshow(hp_edge_ll); title('Canny Edge Low-Low');
imwrite(hp_edge_ll, 'HP-canny-lowlow.png');

% High-Low
hp_edge_hl = edge(highfreq, 'canny', [0.2, 0.3]);
figure; imshow(hp_edge_hl); title('Canny Edge High-Low');
imwrite(hp_edge_hl, 'HP-canny-highlow.png');

% Low-High
hp_edge_lh = edge(highfreq, 'canny', [0.1, 0.2]);
figure; imshow(hp_edge_lh); title('Canny Edge Low-High');
imwrite(hp_edge_lh, 'HP-canny-lowhigh.png');

% High-High
hp_edge_hh = edge(highfreq, 'canny', [0.08, 0.4]);
figure; imshow(hp_edge_hh); title('Canny Edge High-High');
imwrite(hp_edge_hh, 'HP-canny-highhigh.png');

% Canny edge detection on LP
[cannyedge_lp, Thresh_lp] = edge(lowfreq, 'canny');

% Optimal
lp_edge_opt = edge(lowfreq, 'canny', [0.01, 0.035]);
figure; imshow(lp_edge_opt); title('Canny Edge Optimal');
imwrite(lp_edge_opt, 'LP-canny-optimal.png');

% Low-Low
lp_edge_ll = edge(lowfreq, 'canny', [0.005, 0.02]);
figure; imshow(lp_edge_ll); title('Canny Edge Low-Low');
imwrite(lp_edge_ll, 'LP-canny-lowlow.png');

% High-Low
lp_edge_hl = edge(lowfreq, 'canny', [0.015, 0.03]);
figure; imshow(lp_edge_hl); title('Canny Edge High-Low');
imwrite(lp_edge_hl, 'LP-canny-highlow.png');

% Low-High
lp_edge_lh = edge(lowfreq, 'canny', [0.01, 0.02]);
figure; imshow(lp_edge_lh); title('Canny Edge Low-High');
imwrite(lp_edge_lh, 'LP-canny-lowhigh.png');

% High-High
lp_edge_hh = edge(lowfreq, 'canny', [0.01, 0.04]);
figure; imshow(lp_edge_hh); title('Canny Edge High-High');
imwrite(lp_edge_hh, 'LP-canny-highhigh.png');
