function lethargus_selector

close all
clc;  
workspace;  
clear
movementfiles = dir('intensity_*.txt');
%mkatefiles = dir('*mKate_intensity.txt');
%gcampfiles = dir('*GCaMP_intensity.txt');
data_speed=[];
for i=1:size(movementfiles)
input_file_speed = movementfiles(i).name;
 data_speed_table=readtable(input_file_speed);
 data_speed =[data_speed,table2array(data_speed_table(:,2:end))];
end

% 
% input_file_gcamp = gcampfiles(i).name;
%  data_gcamp=textread(input_file_gcamp); 
% 
 %  input_file_mkate = mkatefiles(i).name;
 % data_mkate=textread(input_file_mkate);

 % 
 % pos_without_worm = zeros(size(data_speed,2));
 %  pos_without_worm(2:end,:) = [];
 % pos_without_worm([2,7])=1;
 % pos_with_worm = ~boolean(pos_without_worm)

 % data_speed = data_speed(:,pos_with_worm);
 % data_mkate= data_mkate(:,pos_with_worm);
 % data_gcamp= data_gcamp(:,pos_with_worm);

  prompt1 = {'Time to be analysed before molt in h', 'Seconds between Frames'};
  defaultans = {'3','10'};
  dlg_title = 'Input';
  num_lines = 1;
  answer = inputdlg(prompt1,dlg_title,num_lines,defaultans);
  
   molttime = str2num(answer{1});
  analysetime = str2num(answer{2});
  lengthtoanalyse = (molttime*60*60)/analysetime;
  correctsequence_speed = zeros((molttime*60*60)/analysetime,size(data_speed,2));
  % correctsequence_gcamp = zeros((molttime*60*60)/analysetime,size(data_gcamp,2));
  % correctsequence_mkate = zeros((molttime*60*60)/analysetime,size(data_mkate,2));
  
  for j = 1:size(data_speed,2)
  
  prompt = {sprintf('Molt frame for worm %i in %s', j,input_file_speed)};
  answerworm = inputdlg(prompt);
  molt = str2num(answerworm{1});
  
  correctsequence_speed(:,j) = data_speed((molt-molttime*60*60/analysetime+1):molt,j);
  
  % correctsequence_gcamp(:,j) = data_gcamp((molt-molttime*60*60/analysetime+1):molt,j);
  % 
  % correctsequence_mkate(:,j) = data_mkate((molt-molttime*60*60/analysetime+1):molt,j);
  
  end
  x = ((1:lengthtoanalyse)*5)';
  final_data_speed = [x,correctsequence_speed];
 %  final_data_gcamp = [x,correctsequence_gcamp]; 
 % final_data_mkate = [x,correctsequence_mkate];


  
  newname_speed = input_file_speed(1:(end-4));

  % newname_mkate = input_file_mkate(1:(end-4));
  % 
  % newname_gcamp = input_file_gcamp(1:(end-4));

for i=1:size(data_speed,2)
bouts(:,i) = boutdetection(final_data_speed(:,i+1),12,0.3);
end
 sleepfraction =1-sum(bouts)/length(bouts)
  save('selected_250603sleepfraction_Arrest2_C5.txt','final_data_speed','-ascii');
% save('20240918_PHX9563_mkate_timeselection.txt','final_data_mkate','-ascii');
% save('20240918_PHX9563_gcamp_timeselection.txt','final_data_gcamp','-ascii');
 


end


