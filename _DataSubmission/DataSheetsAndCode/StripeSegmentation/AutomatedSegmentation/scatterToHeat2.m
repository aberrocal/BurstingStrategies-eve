%%%%
%This script carries out the second step of assigning scattered MS2 foci to
%individual stripes, and is necessary to generate the heatmaps of Unified
%bursting strategies in ectopic and endogenous even-skipped expression patterns.

%This script assigns particles that appear between 0 and 25 min into nc14
%to stripes, based on the results of scatterToHeat.m script. 
%This script works better on embryos that show well defined stripes.

%%%WARNING%%%
%This code may modify CompiledParticles.mat datasets whose particles have
%been already assigned to stripes.

clc
clear

dataset = 'CompiledParticles_2019-08-13-A141P_eveWT2_30uW_550V';

load(dataset)

%number of clusters
k_clusters = input('How many clusters do you need?\n');
k = k_clusters;

time = mean(diff(ElapsedTime));
jj = round(5 / time); %number of time points to amalgamate
ii = nc14 + round(25 / time);

xPos_w = [];
APPos_w = [];
yPos_w = [];
Stripe_w = [];
Fluo_w = [];

c = 1;
for i = 1:1:length(CompiledParticles{1}(:))
    
    for j = 1:1:length(CompiledParticles{1}(i).Frame)
        
        if CompiledParticles{1}(i).Frame(j) >= ii && CompiledParticles{1}(i).Frame(j) < ii + jj
 
            xPos_w(c) = CompiledParticles{1}(i).xPos(j);
            APPos_w(c) = CompiledParticles{1}(i).APPos(j);
            yPos_w(c) = CompiledParticles{1}(i).yPos(j);
            Stripe_w(c) = CompiledParticles{1}(i).Stripe(j);
            Fluo_w(c) = CompiledParticles{1}(i).Fluo(j);
            c = c+1;
            
        end
        
    end
    
end

im = zeros(256, 1024);
    
for i = 1:length(xPos_w)
    
    x_im = xPos_w(i);
    y_im = yPos_w(i);
    Fluo_im = Fluo_w(i);
    %im(y_im, x_im) +
    im(y_im, x_im) = Fluo_im * 100000;
    
end

figure(1)
im_gauss = imgaussfilt(im, 0.5);
imagesc(im_gauss)
pause(5)
hold off

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

%Mesh Segmentation

x_mesh = 1:1:1024;
y_mesh = 1:1:256;
[xG,yG] = meshgrid(x_mesh,y_mesh);
XYGrid = [xG(:),yG(:)]; % Defines a fine grid on the plot

idx2Region = kmeans(XYGrid, k,'MaxIter',1,'Start',C);

%Fix the stripe number
[~,~,ic2Region] = unique(idx2Region,'stable');
%Use this mesh segmentation to assign stripe location before 25 min

figure (2)
gscatter(XYGrid(:,1),XYGrid(:,2),ic2Region);
hold on
scatter(xPos_w, yPos_w, '.k')

%%Need to reassign numbers

%%%%Fix assignation of mesh
manualAssignments = input('How many fixings needed?\n');
    
for Assign = 1:1:manualAssignments

    sprintf(strcat('Manual fixing\t', num2str(Assign)))
    [xb, yb] = ginput(1);

    manualLorR = input('Choose left or right to dump\n');

    if strcmpi(manualLorR,'left')
        
        LeftSideStripe = input('What stripe number?\n');
       
        for i = 1:1:length(XYGrid(:,1))
           
            if XYGrid(i,1) < xb

                ic2Region(i) = LeftSideStripe;
                
            end
            
        end
        
    elseif strcmpi(manualLorR,'right')
        
        RightSideStripe = input('What stripe number?\n');
        
        for i = 1:1:length(XYGrid(:,1))
            
            if XYGrid(i,1) > xb
                
                ic2Region(i) = RightSideStripe;
                
            end
            
        end
        
    else
        
        sprintf('Nor Left or Right\nError')
        
        break
        
    end
    
end

figure (2)
gscatter(XYGrid(:,1),XYGrid(:,2),ic2Region);
hold on
scatter(xPos_w, yPos_w, 'k.')
drawnow()
pause(5)


for m = 1:1:length(unique(ic2Region))

    particlesStripes = XYGrid(ic2Region == m,:);
    
    for i = 1:1:length(CompiledParticles{1}(:))

        for j = 1:1:length(CompiledParticles{1}(i).Frame)

            if CompiledParticles{1}(i).Frame(j) >= nc14 && CompiledParticles{1}(i).Frame(j) < ii

                isXinStripe = ismember(CompiledParticles{1}(i).xPos(j), particlesStripes(:,1));
                isYinStripe = ismember(CompiledParticles{1}(i).yPos(j), particlesStripes(:,2));

                if isXinStripe && isYinStripe

                    CompiledParticles{1}(i).Stripe(j) = m;

                end

            end

        end

    end

end

%Ask which stripe correspond to numbers in K

save(dataset, 'CompiledParticles', '-append')
