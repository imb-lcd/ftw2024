%% initialize environment
clc
clear
close all

crop_image_stack("s6","cy5")
crop_image_stack("s6","dic")

%% identify the index of row and column that is black after alignment
function crop_image_stack(well,signal)
fname = "..\img\"+well+"_"+signal+"_ff1_10_stitched_aligned.tif";
info = imfinfo(fname);
img = arrayfun(@(i)imread(fname,i,'info',info),1:length(info),'UniformOutput',0);

index_row_black = [];
index_col_black = [];
for i = 1:length(img)
    index_row_black = [index_row_black;...
        find(sum(img{i}==0,2)>size(img{1},2)/2)];

    index_col_black = [index_col_black,...
        find(sum(img{i}==0,1)>size(img{1},1)/2)];
end
index_row_black = unique(index_row_black);
index_col_black = unique(index_col_black);

for i = 1:length(img)
    img{i}(index_row_black,:) = [];
    img{i}(:,index_col_black) = [];

    px_side = min(size(img{1}));
    img{i} = img{i}(1:px_side,1:px_side);

    if i == 1
        imwrite(img{i},"..\img\"+well+"_"+signal+"_ff1_10_stitched_aligned_cropped.tif")
    else
        imwrite(img{i},"..\img\"+well+"_"+signal+"_ff1_10_stitched_aligned_cropped.tif",'WriteMode','append')
    end
end
end


