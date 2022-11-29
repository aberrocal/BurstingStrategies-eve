%%%%%%
%This script carries out the first step of assigning scattered MS2 foci to
%individual stripes, and is necessary to generate the heatmaps of Unified
%bursting strategies in ectopic and endogenous even-skipped expression patterns. 

%This script assigns particles that appear between 25 and 50 min into nc14
%to stripes, using a k-means based pipeline. 
% It works better on embryos that show well defined stripes.

%%%WARNING%%%
%This code may modify CompiledParticles.mat datasets whose particles have
%been already assigned to stripes.

clc
clear

%addpath '/Users/augustoberrocal/Documents/EisenLab/Analysis'
dataset = 'CompiledParticles_2019-08-13-A141P_eveWT2_30uW_550V';

load(dataset)

%number of clusters
% k_clusters = input('How many clusters do you need?\n');
% k = k_clusters;

for i = 1:length(CompiledParticles{1}(:))
    
    CompiledParticles{1}(i).Stripe = [];
    CompiledParticles{1}(i).Stripe = zeros(length(CompiledParticles{1}(i).Frame),1)';
    
end
%Take information from CompiledParticles{1}.OriginalParticle to give
%identity to each particle
Frames_all = cell2mat({CompiledParticles{1}(:).Frame});

xPos_all = cell2mat({CompiledParticles{1}(:).xPos});

yPos_all = cell2mat({CompiledParticles{1}(:).yPos});

fluor_all = cell2mat({CompiledParticles{1}(:).Fluo});

%Frame contains the time frame when the stripe first appeared

%Each frame happens every ~17.2 sec according to this formula
time = mean(diff(ElapsedTime));

jj = round(5 / time); %number of time points to amalgamate
%for i = nc14:j:length(ElapsedTime)-j
%for ii = length(ElapsedTime)-60:jj:length(ElapsedTime)-jj
ii_vec = nc14 + round(25 / time):jj:length(ElapsedTime)-jj;

for ii = nc14 + round(25 / time):jj:length(ElapsedTime)-jj
    %for ii = nc14 + round(39 / time):jj:nc14 + round(44 / time)
    if ii == ii_vec(end)
        
        jj = length(ElapsedTime) - ii_vec(end) + 1;
        
    end
    
    Frames_nc14 = find(Frames_all >= ii & Frames_all < ii + jj);
    
    xPos_window = xPos_all(Frames_nc14);
    yPos_window = yPos_all(Frames_nc14);
    
    fluor_window = fluor_all(Frames_nc14);
    
    im = zeros(256, 1024);
    
    for i = 1:length(xPos_window)
        
        x_im = xPos_window(i);
        y_im = yPos_window(i);
        fluo_im = fluor_window(i);
        %im(y_im, x_im) +
        im(y_im, x_im) = fluo_im * 100000;
        
    end
    
    figure(1)
    im_gauss = imgaussfilt(im, 0.5);
    imagesc(im_gauss)
    pause(5)
    hold off
    
    %number of clusters
    k_clusters = input('How many clusters do you need?\n');
    k = k_clusters;

    
    [l,w] = size(im_gauss);
    scatter_gauss_x = [];
    scatter_gauss_y = [];
    c = 1;
    
    %Save coordinates of data in blurred image to make a scatter plot
    for i = 1:1:w
        
        for j = 1:1:l
            
            if im_gauss(j,i) > 0
                
                %save coordinates of scatter plot
                scatter_gauss_x(c) = i;
                scatter_gauss_y(c) = j;
                c = c + 1;
                
            end
            
        end
        
    end
    
    %Save coordinates of data positions in scatter plot in a single dataset for
    %kmeans
    scatter_gauss = [scatter_gauss_x; scatter_gauss_y]';
    
    rng(1); % For reproducibility
    
    [idx,C] = kmeans(scatter_gauss, k, 'Replicates', 30);
    
    %the order of idx is sorted by the x position of the particle along AP axis. Therefore,
    %getting the unique 'stable' order (ic) of elements in the idx vector
    %accurately substitutes the randomly generated idx number by its sorted
    %position along the x axis.
    [~,~,ic] = unique(idx,'stable');
    C;
    
    figure (1)
    gscatter(scatter_gauss(:,1),scatter_gauss(:,2),ic)
    hold on
    scatter(C(:,1), C(:,2), 'ko')
    title(strcat(num2str((ii - nc14) * time), '-', num2str((ii + jj - nc14) * time), ' min into nc14'))
    
    grid on
    legend('1', '2', '3', '4')
    pause(5)
    drawnow()
    hold off
    
    %%
    %Manually assign some blurs to stripes
    manualAssignments = input('How many assignments do you want to add?\n');
    
    for Assign = 1:1:manualAssignments
        
        sprintf(strcat('Manual assignment number\t', num2str(Assign)))
        [xb, yb] = ginput(4);
        
        manualStripe = input('Chose stripe\n');
        
        for i = 1:1:length(scatter_gauss(:,1))
            if (scatter_gauss(i,1) > min(xb) & scatter_gauss(i,1) < max(xb))
                if (scatter_gauss(i,2) > min(yb) & scatter_gauss(i,2) < max(yb))
                    %sprintf('ooo')
                    %ic(i)
                    ic(i) = manualStripe;
                    %ic(i)
                    %sprintf('ooo')
                end
            end
        end
        
        figure (1)
        gscatter(scatter_gauss(:,1),scatter_gauss(:,2),ic)
        hold on
        scatter(C(:,1), C(:,2), 'ko')
        title(strcat(num2str((ii - nc14) * time), '-', num2str((ii + jj - nc14) * time), ' min into nc14'))
        
        grid on
        legend('1', '2', '3', '4', '100')
        pause(5)
        drawnow()
        hold off
    end
    
    %%
    figure(2)
    colours = {'.r', '.g', '.c', '.m', 'k'};
    test_x = [];
    test_y = [];
    for i = 1:1:length(unique(ic))
        
        %check this part
        particlesStripes = scatter_gauss(ic == i,:);
        Stripes_x = ismember(xPos_window, particlesStripes(:,1));
        Stripes_y = ismember(yPos_window, particlesStripes(:,2));
        
        Stripes_xy = Stripes_x & Stripes_y;
        
        scatter(xPos_window(Stripes_xy), yPos_window(Stripes_xy), colours{i})
        title(strcat(num2str((ii - nc14) * time), '-', num2str((ii + jj - nc14) * time), ' min into nc14'))
        grid on
        hold on
        
        %Go through particles that occur in nc14
        for j = 1:1:length(CompiledParticles{1}(:))
            
            for m = 1:1:length(CompiledParticles{1}(j).Frame)
                
                if CompiledParticles{1}(j).Frame(m) >= ii && CompiledParticles{1}(j).Frame(m) < ii + jj
                    
                    isXinStripe = ismember(CompiledParticles{1}(j).xPos(m), particlesStripes(:,1));
                    isYinStripe = ismember(CompiledParticles{1}(j).yPos(m), particlesStripes(:,2));
                    
                    if isXinStripe && isYinStripe
                        
                        CompiledParticles{1}(j).Stripe(m) = i;
                        
                    end
                    
                end
                
            end
            
        end
        
    end
    hold off
end
hold off
    
    %a few spots (5/5000) are counted twice, this glitch does not seem to
    %be important.
%     test_xy = [test_x; test_y]';
%     xyPos_window = [xPos_window; yPos_window]';
%     
%     testcomparisons(fff) = isequal(sortrows(test_xy, [1 2]), sortrows(xyPos_window, [1 2]));
%     fff = fff + 1;
%      if(~isequal(sortrows(test_xy, [1 2]), sortrows(xyPos_window, [1 2])))
%          size(test_xy)
%          size(xyPos_window)
%          
%      end

% file_name = strsplit(dataset, '/');
% file_name = file_name(end);

save(dataset, 'CompiledParticles', '-append')