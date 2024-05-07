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

open("D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/cy5_cropped_treated_before_induction_frame2_6.tif");
rename("cy5");
run("Cyan Hot");
run("Median...", "radius=2 stack");
run("Subtract Background...", "rolling=50 stack");
run("Make Montage...", "columns=5 rows=4 scale=1");

selectWindow("cy5");
// setMinAndMax(220, 420);
setMinAndMax(20, 200); // after background sutraction 50
run("RGB Color");

// control
selectWindow("cy5");
run("Duplicate...", "duplicate range=1-5");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_control_treat_before_induction_f start=2 digits=1");
run("Duplicate...", " ");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=1 pixel_width=1.26 pixel_height=1.26 voxel_depth=1.26");
run("Scale Bar...", "width=200 height=100 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold");
saveAs("Tiff", "D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/cy5_control_treat_before_induction_f2_scalebar.tif");

// fer1
selectWindow("cy5");
run("Duplicate...", "duplicate range=6-10");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_fer1_treat_before_induction_f start=2 digits=1");

// nec1
selectWindow("cy5");
run("Duplicate...", "duplicate range=11-15");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_nec1_treat_before_induction_f start=2 digits=1");

// zvad
selectWindow("cy5");
run("Duplicate...", "duplicate range=16-20");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_zvad_treat_before_induction_f start=2 digits=1");
/*
close("*"); close("Results"); close("ROI Manager");

open("D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/cy5_cropped_treated_after_induction_frame2_11.tif");
rename("cy5");
run("Cyan Hot");
run("Median...", "radius=2 stack");
run("Make Montage...", "columns=10 rows=4 scale=1");

selectWindow("cy5");
setMinAndMax(230, 480);
run("RGB Color");

// control
selectWindow("cy5");
run("Duplicate...", "duplicate range=1-10");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_control_treat_after_induction_f start=2 digits=2");
run("Duplicate...", " ");
Stack.setXUnit("um");
run("Properties...", "channels=1 slices=1 frames=1 pixel_width=1.26 pixel_height=1.26 voxel_depth=1.26");
run("Scale Bar...", "width=200 height=100 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold");
saveAs("Tiff", "D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/cy5_control_treat_after_induction_f2_scalebar.tif");

// fer1
selectWindow("cy5");
run("Duplicate...", "duplicate range=11-20");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_fer1_treat_after_induction_f start=2 digits=2");

// nec1
selectWindow("cy5");
run("Duplicate...", "duplicate range=21-30");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_nec1_treat_after_induction_f start=2 digits=2");

// zvad
selectWindow("cy5");
run("Duplicate...", "duplicate range=31-40");
run("Image Sequence... ", "select=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/"+
" dir=D:/ftw_paper_figures_v2/figS5_death_inhibitor/fig/ format=TIFF "+
"name=cy5_zvad_treat_after_induction_f start=2 digits=2");
*/
