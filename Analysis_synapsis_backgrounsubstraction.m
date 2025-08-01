%% analysis synaptic marker 
close all;clear all;clc;
%Dialog-Box for signal thresholds
%give thresholds for GFP and RFP signal values
dlg_title = 'Thresholds';
prompt = {'Intensity threshold for GFP','Intensity threshold for RFP'};
num_lines = 1;
defaultans = {'700','250'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
threshGFP = str2num(answer{1,1});
threshRFP = str2num(answer{2,1});
%%first read in tiff file

files = dir('MAX_*.tif'); %change here name of files to be read in 

for i=1:size(files)
    file_name = files(i).name;
    redchannel = imread(file_name,1);
    greenchannel = imread(file_name,2);
    dicchannel = imread(file_name,3);


figure; imagesc(greenchannel)

 %draw circle around Tpiece
  
tpiece = drawcircle(gca,'Center',[100,100],'Radius',20)
waitfordoubleclick
            % Wait for the user to finish drawing the ROI


 
%create mask for Tpiece
mask1=createMask(tpiece);
%close all;
TpieceGFP = greenchannel(mask1);
TpieceRFP = redchannel(mask1);

TpieceGFP_sort = sort(TpieceGFP);
TpieceGFP_background = mean(TpieceGFP_sort(3:20));
TpieceRFP_sort = sort(TpieceRFP);
TpieceRFP_background = mean(TpieceRFP_sort(3:20));

GFPsignalTpiece = TpieceGFP>threshGFP;
RFPsignalsynapsTpiece = TpieceRFP>threshRFP;
tpiece_size(i)=sum(GFPsignalTpiece);
tpiece_meansignalGFP(i)=mean(TpieceGFP(GFPsignalTpiece))-TpieceGFP_background;
tpiece_size_synapsis(i) = sum(RFPsignalsynapsTpiece);
tpiece_meansignalRFP(i) = mean(TpieceRFP(RFPsignalsynapsTpiece))-TpieceRFP_background;


%now draw roi for nervring
roi2Width = 250;
roi2Height = 250;

     
nervring = imrect(gca, [0 0 roi2Width roi2Height]);
wait(nervring)
%create mask for nervring
mask2=createMask(nervring);
%close all;
nervringGFP = greenchannel(mask2);
nervringRFP = redchannel(mask2);

nervringGFP_sort = sort(nervringGFP);
nervringGFP_background = mean(nervringGFP_sort(3:20));
nervringRFP_sort = sort(nervringRFP);
nervringRFP_background = mean(nervringRFP_sort(3:20));

GFPsignalnervring = nervringGFP>threshGFP;
RFPsignalsynapsnervring = nervringRFP>threshRFP;
nervring_size(i)=sum(GFPsignalnervring);
nervring_meansignalGFP(i)=mean(nervringGFP(GFPsignalnervring))-nervringGFP_background;
nervring_size_synapsis(i) = sum(RFPsignalsynapsnervring);
nervring_meansignal(i) = mean(nervringRFP(RFPsignalsynapsnervring))-nervringRFP_background;
end
titles = {'size Tpiece', 'mean GFP intensity Tpiece','size synapses Tpiece','mean RFP intensity Tpiece','size nervring', 'mean GFP intensity nervring','size synapses nervring','mean RFP intensity nervring'};

results = [tpiece_size;tpiece_meansignalGFP;tpiece_size_synapsis;tpiece_meansignalRFP;nervring_size;nervring_meansignalGFP;nervring_size_synapsis;nervring_meansignal];
results=results';
filename = ('iBlinc_Lethargus_synapticanalysis_backrgoundsub.xlsx');
writecell(titles,filename,'Sheet',1,'Range','A1:H1');
writematrix(results,filename,'Sheet',1,'Range','A2:H35');
close all;

