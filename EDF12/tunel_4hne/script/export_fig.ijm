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

/* 4HNE 
run("Close All");
open("Z:/Chia-Chou/20240123_whole_mount_4hne/img/4hne_3.tif");
makeRectangle(787+408, 2280, 1994-787+1, 1738);
run("Add Selection...");
makeRectangle(1041+408, 2280, 1832-1041+1, 1738);
run("Add Selection...");
makeRectangle(441, 328, 2904, 4194);
run("Crop");
run("RGB Color");
saveAs("Tiff", "Z:/Chia-Chou/20240123_whole_mount_4hne/fig/image/4hne_3_w_box.tif");
*/


/* TUNEL */
run("Close All");
open("Z:/Chia-Chou/20240123_whole_mount_4hne/img/tunel_3.tif");
makeRectangle(591+126, 1908, 1718-591+1, 1738);
run("Add Selection...");
makeRectangle(920+126, 1908, 1510-920+1, 1738);
run("Add Selection...");
makeRectangle(144, 95, 2369, 3720);
run("Crop");
run("RGB Color");
//saveAs("Tiff", "Z:/Chia-Chou/20240123_whole_mount_4hne/fig/image/tunel_3_wo_box.tif");



