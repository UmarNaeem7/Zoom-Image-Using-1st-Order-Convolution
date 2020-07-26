function [f] = firstOrderConvolution(image, row, col, height, width)
%The function takes an image as an input. Row & col indicate the starting position of the image portion to be zoomed &
%height & width indicate how much this image portion to be zoomed has to be expanded
%by a factor of 2*(n-1)
%   Detailed explanation goes here
a = image;
[p, q, s] = size(a);
if s==1
    mask = [1/4 1/2 1/4;1/2 1 1/2;1/4 1/2 1/4];
    r = row;    c = col;
    m = 2*width+1;  n = 2*height+1;
    b = zeros(n, m);
    d = b;
    zoom = a(r:r+height-1, c:c+width-1);

    %place the extracted portion in mask properly
    b(2:2:end-1, 2:2:end-1) = zoom(1:end, 1:end);
    
    %apply convolution
    for i=1:n-2
        for j=1:m-2
            mul = b(i:i+2, j:j+2);
            temp = dot(mask, mul);
            %get scalar dot products
            sum = temp(1, 1) + temp(1, 2) + temp(1, 3);
            %place the scalars in new matrix
            d(i+1, j+1) = sum;
        end
    end
    
    %remove padding
    e = d(2:end-1, 2:end-1);
    
    %normalize image
    f = uint8(e);
    
    
    
else
    %create convolution mask for 1st order hold
    mask(:,:,1) = [1/4 1/2 1/4;1/2 1 1/2;1/4 1/2 1/4];
    mask(:,:,2) = [1/4 1/2 1/4;1/2 1 1/2;1/4 1/2 1/4];
    mask(:,:,3) = [1/4 1/2 1/4;1/2 1 1/2;1/4 1/2 1/4];
    
    %calculate row and col count of ending point of zoom from
    %width and height
    r = row;    c = col;
    m = 2*width+1;  n = 2*height+1;
    
    %initialize mask of right size
    b = zeros(n, m, 3);
    d = b;
    
    %extract portion of image to be zoomed
    zoom = a(r:r+height-1, c:c+width-1, :);
    
    %place the extracted portion in mask properly
    b(2:2:end-1, 2:2:end-1, :) = zoom(1:end, 1:end, :);
    
    %apply convolution
    for i=1:n-2
        for j=1:m-2
            mul = b(i:i+2, j:j+2, :);
            temp = dot(mask, mul);
            %get scalar dot products
            sum1 = temp(1, 1, 1) + temp(1, 2, 1) + temp(1, 3, 1);
            sum2 = temp(1, 1, 2) + temp(1, 2, 2) + temp(1, 3, 2);
            sum3 = temp(1, 1, 3) + temp(1, 2, 3) + temp(1, 3, 3);
            %place the scalars in new matrix
            d(i+1, j+1, 1) = sum1;
            d(i+1, j+1, 2) = sum2;
            d(i+1, j+1, 3) = sum3;
        end
    end
    
    %remove padding
    e = d(2:end-1, 2:end-1, :);
    
    %normalize image
    f = uint8(e);

    
end



end

