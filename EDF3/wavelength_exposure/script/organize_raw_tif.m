%     Copyright (C) 2024  Chia-Chou Wu
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.

%% initialize environment
clc; clear; close all

%% intensity, 20X
expression = "s(?<well>\d+)t(?<frame>\d+)c(?<ch>\d+)*";

% before
list = dir("..\raw\intensity\20X\before\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");

tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];

[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);

[G,ID] = findgroups(tbl(:,[1 3]));
ID.fname = arrayfun(@(i)fullfile(list(1).folder,fname(G==i)),1:height(ID),'UniformOutput',0)';

% after
list = dir("..\raw\intensity\20X\after\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");
tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];
[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);
for i = 1:height(ID)
    ID.fname{i} = [ID.fname{i};fullfile(list(1).folder,fname(tbl.well==ID.well(i) & tbl.ch==ID.ch(i)))];
end

% output filename
ID.oname = "..\raw\Intensity20X_s"+(ID.well+1)+"_c"+(ID.ch+1)+"_ORG.tif";

% induction
list = dir("..\raw\intensity\induction_site\*.tif");
fname = string({list(:).name})';
expression = "s(?<well>\d+)c(?<ch>\d+)*";
tokenName = regexp(fname,expression,"names");
tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),2,[])'));
tbl.Properties.VariableNames = ["well" "ch"];
for i = 1:height(ID)
    index = find(tbl.well==ID.well(i) & tbl.ch==ID.ch(i));
    if ~isempty(index)
        ID.induction_in(i) = fullfile(list(1).folder,fname(index));
        ID.induction_out(i) = "..\raw\Intensity20X_s"+(str2double(ID.well(i))+1)+"_c"+(str2double(ID.ch(i))+1)+"_induction_ORG.tif";
    end
end

% save multipage pdf
% for i = 1:height(ID)
%     for j = 1:length(ID.fname{i})
%         img = imread(ID.fname{i}(j));
%         if j==1
%             imwrite(img,ID.oname(i))
%         else
%             imwrite(img,ID.oname(i),'WriteMode','append');
%         end
%     end
%     if ~ismissing(ID.induction_in(i))
%         img = imread(ID.induction_in(i));
%         imwrite(img,ID.induction_out(i))
%     end
% end

%% intensity, 10X
expression = "s(?<well>\d+)t(?<frame>\d+)c(?<ch>\d+)*";

% before
list = dir("..\raw\intensity\10X\before\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");
tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];
[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);
[G,ID] = findgroups(tbl(:,[1 3]));
ID.fname = arrayfun(@(i)fullfile(list(1).folder,fname(G==i)),1:height(ID),'UniformOutput',0)';

% after
list = dir("..\raw\intensity\10X\after\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");

tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];
[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);
for i = 1:height(ID)
    ID.fname{i} = [ID.fname{i};fullfile(list(1).folder,fname(tbl.well==ID.well(i) & tbl.ch==ID.ch(i)))];
end

% output filename
ID.oname = "..\raw\Intensity10X_s"+(ID.well+1)+"_c"+(ID.ch+1)+"_ORG.tif";

% save multipage pdf
% for i = 1:height(ID)
%     for j = 5:18%:length(ID.fname{i})
%         img = imread(ID.fname{i}(j));
%         if j==5
%             imwrite(img,ID.oname(i))
%         else
%             imwrite(img,ID.oname(i),'WriteMode','append');
%         end
%     end
% end

%% wavelength, 10X
expression = "s(?<well>\d+)t(?<frame>\d+)c(?<ch>\d+)*";

% before
list = dir("..\raw\wavelength\10X\before\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");
tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];
[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);
[G,ID] = findgroups(tbl(:,[1 3]));
ID.fname = arrayfun(@(i)fullfile(list(1).folder,fname(G==i)),1:height(ID),'UniformOutput',0)';

% after
list = dir("..\raw\wavelength\10X\after\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");

tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];
[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);
for i = 1:height(ID)
    ID.fname{i} = [ID.fname{i};fullfile(list(1).folder,fname(tbl.well==ID.well(i) & tbl.ch==ID.ch(i)))];
end

% output filename
ID.oname = "..\raw\Wavelength10X_s"+(ID.well+1)+"_c"+(ID.ch+1)+"_ORG.tif";

% save multipage pdf
% for i = 1:height(ID)
%     for j = 5:20%:length(ID.fname{i})
%         img = imread(ID.fname{i}(j));
%         if j==5
%             imwrite(img,ID.oname(i))
%         else
%             imwrite(img,ID.oname(i),'WriteMode','append');
%         end
%     end
% end

%% wavelength, 20X
expression = "s(?<well>\d+)t(?<frame>\d+)c(?<ch>\d+)*";

% before
list = dir("..\raw\wavelength\20X\before\*.tif");
fname = string({list(:).name})';
tokenName = regexp(fname,expression,"names");

tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];

[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);

list2 = dir("..\raw\wavelength\20X\before_DAPI\*.tif");
fname2 = string({list2(:).name})';
expression = "s(?<well>\d+)c(?<ch>\d+)*";
tokenName2 = regexp(fname2,expression,"names");

tbl2 = array2table(str2double(reshape(struct2array([tokenName2{:}]),2,[])'));
tbl2.Properties.VariableNames = ["well" "ch"];

[tbl2,index2] = sortrows(tbl2,["well","ch"]);
fname2 = fname2(index2);
tbl2.frame = ones(height(tbl2),1);
tbl2 = tbl2(:,[1 3 2]);
tbl2.well = tbl2.well+72;

tbl = [tbl;tbl2];
fname = [fullfile(list(1).folder,fname);fullfile(list2(1).folder,fname2)];
idx_discard = tbl.frame==0;
tbl(idx_discard,:) = [];
fname(idx_discard) = [];

[G,ID] = findgroups(tbl(:,[1 3]));
ID.fname = arrayfun(@(i)fname(G==i),1:height(ID),'UniformOutput',0)';

% after
list = dir("..\raw\wavelength\20X\after\*.tif");
fname = string({list(:).name})';
expression = "s(?<well>\d+)t(?<frame>\d+)c(?<ch>\d+)*";
tokenName = regexp(fname,expression,"names");
tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),3,[])'));
tbl.Properties.VariableNames = ["well" "frame" "ch"];
[tbl,index] = sortrows(tbl,["well","ch","frame"]);
fname = fname(index);
for i = 1:height(ID)
    ID.fname{i} = [ID.fname{i};fullfile(list(1).folder,fname(tbl.well==ID.well(i) & tbl.ch==ID.ch(i)))];
end

% output filename
ID.oname = "..\raw\Wavelength20X_s"+(ID.well+1)+"_c"+(ID.ch+1)+"_ORG.tif";

% induction
light = ["cy5" "mcherry" "tritc" "yfp" "fitc" "cfp" "dapi"];
induction = [];
for i = 1:length(light)
    list = dir("..\raw\wavelength\induction_site\"+light(i)+"\*.tif");
    fname = string({list(:).name})';
    expression = "s(?<well>\d+)c(?<ch>\d+)*";
    tokenName = regexp(fname,expression,"names");
    tbl = array2table(str2double(reshape(struct2array([tokenName{:}]),2,[])'));
    tbl.Properties.VariableNames = ["well" "ch"];
    tbl.fname = fullfile(list(1).folder,fname);
    tbl = sortrows(tbl,"well");
    induction = [induction;tbl];
end
wells = reshape(1:84,12,[])';
wells(2,:) = fliplr(wells(2,:));
wells(4,:) = fliplr(wells(4,:));
wells(6,:) = fliplr(wells(6,:));
wells = wells';
wells = wells(:);
induction.global_well = wells-1;

for i = 1:height(ID)
    index = find(induction.global_well==ID.well(i) & induction.ch==ID.ch(i));
    if ~isempty(index)
        ID.induction_in(i) = induction.fname(index);
        ID.induction_out(i) = "..\raw\Wavelength20X_s"+(ID.well(i)+1)+"_c"+(ID.ch(i)+1)+"_induction_ORG.tif";
    end
end

% save multipage pdf
for i = 1:height(ID)
    for j = 1:length(ID.fname{i})
        img = imread(ID.fname{i}(j));
        if j==1
            imwrite(img,ID.oname(i))
        else
            imwrite(img,ID.oname(i),'WriteMode','append');
        end
    end
    if ~ismissing(ID.induction_in(i))
        img = imread(ID.induction_in(i));
        imwrite(img,ID.induction_out(i))
    end
end