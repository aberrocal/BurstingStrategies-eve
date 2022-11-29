%%%%%%
%This script carries out the third step of assigning scattered MS2 foci to
%individual stripes, and is necessary to generate the heatmaps of Unified
%bursting strategies in ectopic and endogenous even-skipped expression patterns. 

%This script assigns the correct names to stripes 
% segmented by scatterToHeat1 and 2.

%%%WARNING%%%
%This code may modify CompiledParticles.mat datasets whose particles have
%been already assigned to stripes. 
%This code may require some modification according to the stripes that are
%being analyzed.

clc
clear

dataset = 'CompiledParticles_2019-08-13-A141P_eveWT2_30uW_550V';

load(dataset)

for i = 1:1:length(CompiledParticles{1}(:))
    
    CompiledParticles{1}(i).Stripe = CompiledParticles{1}(i).Stripe * 100;
    
    for j = 1:1:length(CompiledParticles{1}(i).Stripe(:))
       
        if CompiledParticles{1}(i).Stripe(j) == 100
           
            CompiledParticles{1}(i).Stripe(j) = 4;
            
        elseif CompiledParticles{1}(i).Stripe(j) == 200
            
            CompiledParticles{1}(i).Stripe(j) = 3;
            
        elseif CompiledParticles{1}(i).Stripe(j) == 300
            
            CompiledParticles{1}(i).Stripe(j) = 2;
            
        elseif CompiledParticles{1}(i).Stripe(j) == 400
            
            CompiledParticles{1}(i).Stripe(j) = 1;
            
        elseif CompiledParticles{1}(i).Stripe(j) == 500
            
            CompiledParticles{1}(i).Stripe(j) = 5;
            
        end
        
    end
    
end

save(dataset, 'CompiledParticles', '-append')
