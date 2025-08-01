
close all
clear all
control =textread('selected_*.txt');

%calculate sleep fraction
timethresh=12; 
speedthresh = 0.2;

for i=2:size(control,2)
control_bouts(:,i-1) = boutdetection(control(:,i),timethresh,speedthresh);
end


sleepfraction_control =1-sum(control_bouts)/length(control_bouts)
