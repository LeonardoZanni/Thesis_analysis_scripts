
clear 
close all
clc

% Define a starting folder.
topLevelFolder = uigetdir('','Select starting folder?');
if topLevelFolder == 0
	return;
end
cd(topLevelFolder)

%Dialog-Box for working variables
dlg_title = 'Cropper';
prompt = {'Pixel to crop (n*n)','Seconds between each frame'};
num_lines = 1;
defaultans = {'110','5'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

strain = 0;
while (1)
strain = strain+1;
    %Dialog-Box for working variables
    dlg_title = 'Strain Specifics';
    prompt = {'Filmed Field','Name the Strain'};
    num_lines = 1;
    defaultans = {'1','N2'};
    answer2 = inputdlg(prompt,dlg_title,num_lines,defaultans);
    strain_name_list(strain,1)=answer2(2,1);
    
    %save strain strain-field connection
    strain_field(1,strain) = str2num(answer2{1,1});
    
    %get all files
    file_num=1; %placeholder till for-loop
    common_name=strjoin(['*XY' ,answer2(1,1),'*.tif']);
    common_name=regexprep(common_name,' ','');
    dirInfo=dir(common_name);
    cur_file=dirInfo(file_num).name;

    A = imread(cur_file);

    %load pick and show in grayscale
    imagesc(A);
    colormap('gray');

    %crop as many ROIs as you like. Question after each.
    roi = 1;
    while (1)
        %put a moveable square on pic and get values after double-click
        h = imrect(gca, [1 1 str2num(answer{1,1}) str2num(answer{1,1})]);
        addNewPositionCallback(h,@(p) title(mat2str(p,3)));
        fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
        setPositionConstraintFcn(h,fcn);
        setResizable(h,[0])

        position = wait(h);%wait for doubleclick to continue script

        % block alrdy used ROI
        used_roi = createMask(h); 
        A=regionfill(A,used_roi); %uses surrounding pixels to fill
        imagesc(A);

        %save all values from square for later use
        position = ceil(position);%rount to integer pixels

        %save all values from square for later use
        %build x/y values for cutting
        roi_list(1,roi,strain) = position(1,2);
        roi_list(2,roi,strain) = position(1,2)+position(1,4);
        roi_list(3,roi,strain) = position(1,1);
        roi_list(4,roi,strain) = position(1,1)+position(1,3);

        %delete used square
        delete(h);

        %break while-loop if enough ROI
        promptMessage = sprintf('Do you want to select another ROI?');
        button = questdlg(promptMessage, 'Not enough ROIs yet?',...
            'Another ROI', 'Done!', 'Another ROI');
        if strcmpi(button, 'Done')
            strain_roi(1,strain) = roi;
        break
        end
        roi = roi+1;        
    end
    n_select=1;
    work_file_name(:,strain)={dirInfo.name}';

    
    %break while-loop if enough ROI
    promptMessage = sprintf('Do you want to select another strain?');
    button = questdlg(promptMessage, 'Not enough strains yet?',...
        'Another Strain', 'Done', 'Another Strain');
    if strcmpi(button, 'Done')
    break
    end

end

%first image-subtraction of whole img, then mean of all roi...repeat
tic

roi_mean_list=zeros(size(work_file_name,1)-1,size(roi_list,2),strain);
for strain_num = 1:strain

    %Inner Loop: Image Subtraction of the Picz
    for subtract_image = 1:size(work_file_name,1)-1
        subtract_image
        cur_file_i1 = work_file_name(subtract_image,strain_num);
        cur_file_i2 = work_file_name(subtract_image+1,strain_num);

        pic_i1 = imread(cur_file_i1{1,1});
        pic_i2 = imread(cur_file_i2{1,1});
        pic_dif = imsubtract(pic_i1,pic_i2);

        

        % ROICUTTER
%         for roi_n=1:size(roi_list,2) % isntead count rois strain
%         strain=1; %placeholder - remove later
        for roi_n=1:strain_roi(1,strain_num);    
            roi_mean_raw = pic_dif(...
                [roi_list(1,roi_n,strain_num):...
                roi_list(2,roi_n,strain_num)],...
                [roi_list(3,roi_n,strain_num):...
                roi_list(4,roi_n,strain_num)]);
            roi_mean = mean(mean(roi_mean_raw));
            roi_mean_list(subtract_image,roi_n,strain_num) = roi_mean;
        end
        
    end
    
end
toc
close all



% % {'nd001_T0001_XY1.tif'}
% %pack the stuff into a package
% work_border = regexprep(work_file_name,'\w*_T','');
% work_border = regexprep(work_border,'_\w*.tif','');
% work_border = str2num(cell2mat(work_border));
% work_min = min(work_border);
% work_max = max(work_border);
% time=(work_min*str2num(answer{4,1}):str2num(answer{4,1}):...
%     (work_max-1)*str2num(answer{4,1}))';

%pack the stuff into a package
work_min = 1;
work_max = size(work_file_name,1);
time=(work_min*str2num(answer{2,1}):str2num(answer{2,1}):...
    (work_max-1)*str2num(answer{2,1}))';

for files = 1:strain_num
    roi_strain_mean_list = roi_mean_list(:,1:strain_roi(1,files),files);
    
    final_data = [time roi_strain_mean_list];
    array_table=array2table(final_data);

    strain_txt = strcat('intensity_',strain_name_list{files,1},'.txt');
    writetable(array_table,strain_txt(1:end),'Delimiter','\t');
end


