/*
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
*/

run("Close All");
working_folder = File.directory()+"..";
print(folder);

open(folder+"/img/MAX_Composite.tif");
open(folder+"/img/mask.tif");
run("Rotate... ", "angle=-17 grid=1 interpolation=Bilinear enlarge");
imageCalculator("AND create stack", "MAX_Composite.tif","mask.tif");
makeRectangle(948, 1380, 8628, 4836); // limbC_new2
run("Crop");
setSlice(1);
setMinAndMax(33,94);
setSlice(2);
setMinAndMax(5,60);
run("RGB Color");

