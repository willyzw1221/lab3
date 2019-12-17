% Count_blue.m is divided into 3 steps
% Step 1 is to extract the blue part.(creatMaskB.m)
% Step 2 is to count the number of circles of each part.(shape_feature.m)
% Step 3 is to infer the number of blocks corresponding to 
%              the blue circle.

function num_blue = count_blue(I)
    num_blue = 0;
    [Abw, ~] = BLUE_MASK(I);
    Abw = enhanceSegments(Abw);
    [labeledMask, blobCount] = bwlabel(Abw);
    
    I = rgb2gray(I);
    filt = imfilter(I, fspecial('log', 18, 0.525));
    I = filt < 0;
    I = imopen(I, strel('disk', 2));
    I = imclose(I, strel('disk', 2));
    I = ~bwareaopen(~I, 300);
    I = imerode(I, strel('disk', 2));
    I = imdilate(I, strel('disk', 1));
    I = bwareaopen(I, 150);
    [I,~]= shape_feature(I,0.585);
    
    for i = 1:blobCount
        searchRegion = I & (labeledMask == i); 
        [~, c] = bwlabel(searchRegion);
        if c >= 3 && c <= 9
            num_blue = num_blue + 1;
        else
            if (c== 11 || c==10)
            num_blue = num_blue + 2;
            end
        end
    end
end
function bw = enhanceSegments(bwmask)
    smallestAcceptableArea = 750;
 bwmask = bwareaopen(bwmask, smallestAcceptableArea);
 bwmask = imclose(bwmask, strel('disk', 5));
 bwmask = imfill(logical(bwmask), 'holes');
    
    bw = watershedSegment(bwmask);
end
function bw = watershedSegment(bwmask)
    d = -bwdist(~bwmask);
    mask = imextendedmin(d, 6);
    d2 = imimposemin(d, mask);
    ld2 = watershed(d2);
    bwmask(ld2 == 0) = 0;
    
    bw = imerode(bwmask, strel('disk', 5));
end
