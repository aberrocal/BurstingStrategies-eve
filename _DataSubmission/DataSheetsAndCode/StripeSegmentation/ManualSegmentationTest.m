%%%%%
%Plots stripes segmented by color over nc14
%This code plots the segmentation of the fully segmented CompiledParticles
%(after assigning spots to stripes). This code is mostly for testing
%purposes.

clc
clear

%Write compiled particles dataset you want to analyze. Make sure that your
%matlab path is on the folder of your compiled particles dataset.
%E.g.
%dataset = 'CompiledParticles_eveS1Null_eveS2Gt_1'

dataset = 'CompiledParticles_eveS1wt_eveS2Gt_6'
load(dataset)

time = mean(diff(ElapsedTime));
jj = round(5 / time); %number of time points to amalgamate
%ii = nc14 + round(25 / time);

plotVector = [];
c = 1;

%color
nancolor = '#000000'; %black

es0color = '#0072B2'; %blue
es1color = '#CC79A7'; %reddish purple
es15color = '#D55E00'; %vermillion
es2color = '#E69F00'; %orange
es3color = '#009E73'; %bluish green
es4color = '#676767'; %gray
es5color = '#F0E442'; %yellow

%Convert color code to 1-by-3 RGB array (0~1 each)
str_nan = nancolor;
colRGB_nan = sscanf(str_nan(2:end),'%2x%2x%2x',[1 3])/255;

str_es0 = es0color;
colRGB_es0 = sscanf(str_es0(2:end),'%2x%2x%2x',[1 3])/255;

str_es1 = es1color;
colRGB_es1 = sscanf(str_es1(2:end),'%2x%2x%2x',[1 3])/255;

str_es15 = es15color;
colRGB_es15 = sscanf(str_es15(2:end),'%2x%2x%2x',[1 3])/255;

str_es2 = es2color;
colRGB_es2 = sscanf(str_es2(2:end),'%2x%2x%2x',[1 3])/255;

str_es3 = es3color;
colRGB_es3 = sscanf(str_es3(2:end),'%2x%2x%2x',[1 3])/255;

str_es4 = es4color;
colRGB_es4 = sscanf(str_es4(2:end),'%2x%2x%2x',[1 3])/255;

str_es5 = es5color;
colRGB_es5 = sscanf(str_es5(2:end),'%2x%2x%2x',[1 3])/255;

%%%%

figure(1)

colores = {colRGB_es0, colRGB_nan, colRGB_es1, colRGB_es15, colRGB_es2, colRGB_es3, colRGB_es4, colRGB_es5};

stripeNames = {'eveS0', 'unassigned', 'eveS1', 'eveS1-2', 'eveS2', 'eveS3', 'eveS4', 'eveS5',};
l = 1;

ii_vec = nc14:jj:length(ElapsedTime)-jj;

for ii = nc14:jj:length(ElapsedTime)-jj
    
    label_names = [];
    if ii == ii_vec(end)
        
        jj = length(ElapsedTime) - ii_vec(end) + 1;
        
    end

    plotVector = [];
    
    for i = 1:length(CompiledParticles{1}(:))
        
        for j = 1:1:length(CompiledParticles{1}(i).Frame(:))
            
            if CompiledParticles{1}(i).Frame(j) >= ii && CompiledParticles{1}(i).Frame(j) < ii + jj
                
                plotVector(c,1) = CompiledParticles{1}(i).APPos(j);
                plotVector(c,2) = CompiledParticles{1}(i).yPos(j);
                plotVector(c,3) = CompiledParticles{1}(i).Stripe(j);
                c = c+1;
                
            end
            
        end
        
    end
    
    if isempty(plotVector)
       
        continue
        
    end
        
    valuesScatter = unique(plotVector(:,3));
    
    for i = 1:1:length(valuesScatter)
        
        if valuesScatter(i) == -1
            
            cuolore = 1;
            
        elseif valuesScatter(i) == 0
            
            cuolore = 2;
            
        elseif valuesScatter(i) == 1
            
            cuolore = 3;

        elseif valuesScatter(i) == 1.5

            cuolore = 4;
            
        elseif valuesScatter(i) == 2
            
            cuolore = 5;
            
        elseif valuesScatter(i) == 3
            
            cuolore = 6;
           
        elseif valuesScatter(i) == 4
            
            cuolore = 7;
            
        elseif valuesScatter(i) == 5
            
            cuolore = 8;
            
        end
        
        label_names(i) = cuolore;
        
        s = scatter(plotVector(plotVector(:,3) == valuesScatter(i),1),plotVector(plotVector(:,3) == valuesScatter(i),2));
        s.CData = colores{cuolore};

        if  valuesScatter(i) == 0
            s.Marker = '*';
        else
            s.Marker = '.';
        end            
        hold on
    end
    
    %hScatter = gscatter(plotVector(:,1),plotVector(:,2),plotVector(:,3), cell2mat(colores(plotVector(:,3))));
    title(strcat(num2str((ii - nc14) * time), '-', num2str((ii + jj - nc14) * time), ' min into nc14'))
    xlabel('Fraction of Embryo Length');
    ylabel('Pixels');
    legend(stripeNames(label_names))

    axis([0 1 0 256])
    %grid on
    pbaspect([6 2 1])
    drawnow()
    pause(5)
    
    F(l) = getframe(gcf);
    l = l + 1;
    hold off
end

%%save segmentation video

datasetName = strsplit(dataset, '.');
% create the video writer with 1 fps
videoName = strcat(datasetName{1},'.avi');
writerObj = VideoWriter(videoName);
writerObj.FrameRate = 0.2;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);

    if i == length(F)
        % print the last image of each video
        LastImageName = strcat(datasetName{1},'_last.png');
        LastImage = frame2im(F(i)); %return frame to image
        LastImage(LastImage == 240) = 255; %replace gray box around image for white color
        imshow(LastImage);
        print(gcf, LastImageName,'-dpng','-r1000');
        close()
    end
end
% close the writer object
close(writerObj);
