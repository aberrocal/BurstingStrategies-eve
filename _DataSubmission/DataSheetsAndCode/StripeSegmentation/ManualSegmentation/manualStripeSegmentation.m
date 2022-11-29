%%%%%
%This script allows to manually assigning scattered MS2 foci to
%individual stripes, and is necessary to generate some of the heatmaps of Unified
%bursting strategies in ectopic and endogenous even-skipped expression patterns.

%This script will ask the user how many stripes are in the CompiledParticles dataset
%and will ask the user to assign the identity of each stripe. 
%Users will be able to assign particles to stripes
%based on the position of stripes between 45 and 50 min into nc14. 

%This script is particularly useful to segment stripes in Gt mutants.
%where stripes are not clearly separated from the background.

%%%WARNING%%%
%This code may modify CompiledParticles.mat datasets whose particles have
%been already assigned to stripes. 

clc
clear

dataset = 'CompiledParticles-2019-04-13-A140P_GtSL-eveS1_550V_30uW_copy.mat';

load(dataset)

%Fill all Compiled Particles with zeros
for i = 1:length(CompiledParticles{1}(:))
    
    CompiledParticles{1}(i).Stripe = zeros(length(CompiledParticles{1}(i).Frame),1)';
    
end

%Start time (45 min)
time = mean(diff(ElapsedTime));
ii = nc14 + round(45 / time);

xPos_w = [];
yPos_w = [];

c = 1;
for i = 1:1:length(CompiledParticles{1}(:))
   
    for j =  1:1:length(CompiledParticles{1}(i).Frame(:))
        
        if CompiledParticles{1}(i).Frame(j) >= ii %Frames between 45min and end
    
            xPos_w(c) = CompiledParticles{1}(i).xPos(j);
            APPos(c) = CompiledParticles{1}(i).APPos(j);

            yPos_w(c) = CompiledParticles{1}(i).yPos(j);
            
            c = c+1;
            
        end
        %Save x and y positions
    end    
    
end

% figure(1)
% scatter(xPos_w, yPos_w, '.k')
% title('xy particle position')

figure(1)
scatter(APPos, yPos_w, '.k')
ylim([0 256])
title('AP particle position')

%select stripes
manualStripes = input('How many stripes?\n');

AP_stVec = [];
for Assign = 1:1:manualStripes + 1

    sprintf(strcat('Manual fixing\t', num2str(Assign)))
    [APb, yb] = ginput(1);
    AP_stVec(Assign) = APb;
    
    hold on
    plot(repmat(APb, 256, 1)', 1:256, '-r')
        
end

hold off
AP_stVec

%%%

for i = 1:1:length(AP_stVec)-1
    
    figure(1)
    scatter(APPos, yPos_w, '.k')
    ylim([0 256])
    title('AP particle position')
    
    hold on
    plot(repmat(AP_stVec(i), 256, 1)', 1:256, '-b')
    hold on
    plot(repmat(AP_stVec(i+1), 256, 1)', 1:256, '-b')
    
    StripeName = input('Which stripe is this?\n');
    
    for j = 1:1:length(CompiledParticles{1}(:))
        
        for m =  1:1:length(CompiledParticles{1}(j).Frame(:))
            
            if CompiledParticles{1}(j).APPos(m) >= AP_stVec(i) && CompiledParticles{1}(j).APPos(m) < AP_stVec(i+1)
                
                %Assign stripe to compiled particles
                CompiledParticles{1}(j).Stripe(m) = StripeName;
                
            end
            
        end
        
    end
    
    hold off
    
end

save('CompiledParticles-2019-04-13-A140P_GtSL-eveS1_550V_30uW_copy.mat', 'CompiledParticles', '-append')
%if positions between selected stripes

%assign stripes

%save in compiled particles

