% Count_red.m is divided into 3 steps
% Step 1 is to extract the red part.(creatMaskR.m)
% Step 2 is to blur operations on each part.(bwareaopen(I, 1000))
% Step 3 is to find the part like a cube.(shape_feature.m)
% Acknowledge: My code have modified from built-in MATLAB function.

function num_red= count_red(I)
[~, I] = RED_MASK(I);
I = rgb2gray(I);
filt = imfilter(I, fspecial('log',6, 0.525));
I = filt < 0;
I = bwareaopen(I, 1000);
I = imopen(I, strel('disk', 1));
I = imclose(I, strel('disk', 1));
I = ~bwareaopen(~I, 300);
I = imdilate(I, strel('disk', 25));
I = imerode(I, strel('disk', 2));
I = bwareaopen(I, 100);

[~,num_red]= shape_feature(I,0.75);
