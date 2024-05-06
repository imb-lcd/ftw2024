function id_remove = manual_remove_wrong_initiation(initiation)
%MANUAL_REMOVE_WRONG_INITIATION Summary of this function goes here
%   Detailed explanation goes here

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame<8);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_early_occurrence/"+s),fname);
% cd(old)
id_remove{1} = id_check;
id_remove{1}(19) = [];  % done
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==8);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame8/"+s),fname);
% cd(old)
% id_remove{2} = id_check;
% id_remove{2} = id_remove{2}([7 32]); % done
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==9);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame9/"+s),fname);
% cd(old)
% id_remove{3} = id_check;
% id_remove{3} = id_remove{3}([9]); % done
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==10);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame10/"+s),fname);
% cd(old)
% id_remove{3} = id_check;
% id_remove{3} = id_remove{3}([9]);
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==11);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame11/"+s),fname);
% cd(old)
% id_remove{3} = id_check;
% id_remove{3} = id_remove{3}([9]);
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==12);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame12/"+s),fname);
% cd(old)
% id_remove{3} = id_check;
% id_remove{3} = id_remove{3}([9]);
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==13);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame13/"+s),fname);
% cd(old)
% id_remove{3} = id_check;
% id_remove{3} = id_remove{3}([9]);
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch1") & initiation.frame==14);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch1_after_filter_frame14/"+s),fname);
% cd(old)
% id_remove{3} = id_check;
% id_remove{3} = id_remove{3}([9]);
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch2") & initiation.frame<=2);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch2_after_filter_frame1to2/"+s),fname);
% cd(old)
id_remove{4} = id_check;
id_remove{4}([7 31 39 40 45 46 49 50 62 63 65 66 67 68 69 70 72]) = []; % done
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch2") & initiation.frame==3);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch2_after_filter_frame3/"+s),fname);
% cd(old)
% id_remove{4} = id_check;
% id_remove{4}([7 31 39 40 45 46 49 50 62 63 65 66 67 68 69 70 72]) = [];
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch2") & initiation.frame==4);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch2_after_filter_frame4/"+s),fname);
% cd(old)
% id_remove{4} = id_check;
% id_remove{4}([7 31 39 40 45 46 49 50 62 63 65 66 67 68 69 70 72]) = [];
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch2") & initiation.frame==5);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch2_after_filter_frame5/"+s),fname);
% cd(old)
% id_remove{4} = id_check;
% id_remove{4}([7 31 39 40 45 46 49 50 62 63 65 66 67 68 69 70 72]) = [];
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch2") & initiation.frame==6);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch2_after_filter_frame6/"+s),fname);
% cd(old)
% id_remove{4} = id_check;
% id_remove{4}([7 31 39 40 45 46 49 50 62 63 65 66 67 68 69 70 72]) = [];
% initiation(id_remove,:) = [];

%%
id_check = find(contains(initiation.batch_well,"batch2") & initiation.frame==7);
% tbl_check = initiation(id_check,:);
% fname = tbl_check.batch_well+"_initiation"+pad(string(tbl_check.initiation),2,'left','0')+".png";
% old = cd("../img/check_initiation/")
% arrayfun(@(s) copyfile(s,"./batch2_after_filter_frame7/"+s),fname);
% cd(old)
% id_remove{4} = id_check;
% id_remove{4}([7 31 39 40 45 46 49 50 62 63 65 66 67 68 69 70 72]) = [];
% initiation(id_remove,:) = [];

end

