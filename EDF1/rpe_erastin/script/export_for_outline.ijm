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

close("*"); close("Results"); close("ROI Manager");

// export the images for outlining wave
folder = File.directory();
print(folder);
wells  = "11";
frames = "9-14";

makeRectangle(2080, 845, 750, 750); // center 2

open(folder+"../img/s"+wells+"_cy5_ff1_10_stitched_aligned_cropped.tif");
run("Duplicate...", "duplicate range="+frames);
run("Image Sequence... ", "dir="+folder+"../img/ format=TIFF name=cy5_t start=1 digits=2");
