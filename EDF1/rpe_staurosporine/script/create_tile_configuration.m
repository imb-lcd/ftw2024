%% initialize
clc
clear
close all

%%
tile_configuration_all("s6","cy5")
tile_configuration_all("s6","dic")

%%
function tile_configuration_all(well,signal)

% load the tile configuration of the specific frame
fid  = fopen("..\img\"+well+"\for_stitch\TileConfiguration.registered.txt");
y = 0;
tline = fgetl(fid);
content(1) = string(tline);
while ischar(tline)
    tline = fgetl(fid);
    content = [content;string(tline)];
end
fclose(fid);

% get the name of the image stack
list_new = dir("..\img\"+well+"\*"+signal+"_m*_ff1_10.tif");
list_old = dir("..\img\"+well+"\for_stitch\tile*.tif");

if any([isempty(list_new) isempty(list_old)])
    error("Files are not found.")
end

% replace the content of the configuration with the setting of image stack
% change dim from 2 to 3
content(2) = strrep(content(2),'2','3');

% add the thrid coordinate
nImg = length(content)-5;
content(5:4+nImg) = arrayfun(@(i)insertBefore(content(i+4),")",", 0.0"),(1:nImg)');

% replace file name
for i = 1:length(list_old)
    tmp = strfind(content(5:4+nImg),list_old(i).name);
    index = find(cellfun('length',tmp));
    content(4+index) = strrep(content(4+index),list_old(i).name,list_new(i).name);
end

% save the configuration for image stack
fileID = fopen("..\img\"+well+"\TileConfiguration.registered."+signal+".txt",'w');
fprintf(fileID,'%s\n',content(1:end-1));
fclose(fileID);

end