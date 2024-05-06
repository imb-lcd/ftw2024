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

close("*");
open("E:/20230223_Hannah_movie_confocal/result/20231231/New wave/source.tif");
makeRectangle(1931, 3300, 753, 1217);
run("Duplicate...", "duplicate");
run("Split Channels");
selectImage("C1-source-1.tif");
setMinAndMax(4,20);
run("Median...", "radius=2 stack");
run("Duplicate...", "duplicate range=14-23");
run("Gaussian Blur...", "sigma=10 stack");
run("Analyze Particles...", "size=26000-Infinity show=Masks display clear add stack");

close("*");
open("E:/20230223_Hannah_movie_confocal/result/20231231/New wave/2023-02-10-chick limb live-01-xy2-t1.czi");
run("Duplicate...", "duplicate range=4-19");
run("Z Project...", "projection=[Max Intensity]");
setMinAndMax(4, 20);
run("Cyan Hot");
makeRectangle(0, 0, 3789, 5264);
run("Crop");