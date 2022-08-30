%%%StripesKinetics_Freq_ee.m reads compiledResults_ectopicFlag.mat files,
%%%and plots kon values of endogenous and ectopic nuclei sorted 
%%%by mean fluorescence bins

%%%This script plots endogenous and ectopic patterns 
%%%for all genotypes collapsed on the same graph

%%%compiledResults_ectopicFlat files must be in a folders and subfolders
%%%with the format 
%%%eveS1Null-eveS2Gt/compiledResults_w7_K3_p0_ap1_t1_f2D_ectopicFlag.mat
% 
% clc; 
% clear;

function StripesKinetics_Freq_ee2

F = dir('ev*');
dAU = 10^4; %Divide arbitrary units by 10^5 to make it easier to read.

maxFreq_vec = [];
maxFluo_vec = [];

%Go through all folders (eveS1Null-eveS2Gt, eveS1Null-eveS2wt,
%eveS1wt-eveS2Gt, eveS1wt-eveS2wt) and load the .mat file in each folder
for i = 1:length(F)
    
    folder = F(i).name;
    cd(folder)
    
    file = dir('*.mat');
    load(file.name)
    
    %Save mean intensuty values (kon) and ste over each fluorescent bin
    freq = compiledResults.freq_vec_mean;
    freq_ste = compiledResults.freq_vec_ste;
    
    fluo_mean = compiledResults.fluo_mean  ./ dAU;
    ee_flag = compiledResults.additionalGroupVec;
    
    maxFreq_vec(i) = max(freq);
    maxFluo_vec(i) = max(fluo_mean);
    
    endo = find(ee_flag == 0);
    ecto = find(ee_flag == 1);
        
    %Plot kon values of endogenous and ectopic patterns, different colors
    %represent different genotypes
    
    if isequal(folder,'eveS1Null-eveS2Gt')
        
        eveS1Null_eveS2Gt_line = '-';
        genotypeLine = eveS1Null_eveS2Gt_line;
        
    elseif isequal(folder,'eveS1wt-eveS2Gt')
        
        eveS1wt_eveS2Gt_line = '--';
        genotypeLine = eveS1wt_eveS2Gt_line;
        
    elseif isequal(folder,'eveS1Null-eveS2wt')
        
        eveS1Null_eveS2wt_line = ':';
        genotypeLine = eveS1Null_eveS2wt_line;
        
    elseif isequal(folder,'eveS1wt-eveS2wt')
        
        eveS1wt_eveS2wt_line = '-.';
        genotypeLine = eveS1wt_eveS2wt_line;
        
    end

        
    %%%Plot with error shaded areas for endogenous values
    %%%
    [x2_endo, inBetween_endo] = shadedSte(freq(endo), fluo_mean(endo), freq_ste(endo));
    colLine = 'black';
    %Convert color code to 1-by-3 RGB array (0~1 each)
    %colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255; 
    h = fill(x2_endo, inBetween_endo, colLine);
    set(h,'facealpha',.1)
    set(h,'EdgeColor','none')
    hold on;
    plot(fluo_mean(endo), freq(endo), 'color', colLine, 'LineWidth', 2, 'LineStyle', genotypeLine);
    
    hold on
    
    %%%Plot with error shaded areas for ectopic values
    %%%
    [x2_ecto, inBetween_ecto] = shadedSte(freq(ecto), fluo_mean(ecto), freq_ste(ecto));
    colLine = 'red';
    %Convert color code to 1-by-3 RGB array (0~1 each)
    %colLine = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255; 
    h = fill(x2_ecto, inBetween_ecto, colLine);
    set(h,'facealpha',.2)
    set(h,'EdgeColor','none')
    hold on;
    plot(fluo_mean(ecto), freq(ecto), 'color', colLine, 'LineWidth', 3, 'LineStyle','-');
    hold on
    
    cd('..')
    
end

ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
%grid on

% maxFreq = max(maxFreq_vec);
% maxFluo = max(maxFluo_vec);

hold on

%%%Plot dummies for legends with the genotype colors
% l1 = plot(NaN,NaN, '-', 'LineWidth', 6,  'Color', eveS1Null_eveS2Gt_line);
% l2 = plot(NaN,NaN, '-', 'LineWidth', 6,  'Color', eveS1wt_eveS2Gt_color);
% l3 = plot(NaN,NaN, '-', 'LineWidth', 6,  'Color', eveS1Null_eveS2wt_color);
% l4 = plot(NaN,NaN, '-', 'LineWidth', 6, 'Color', eveS1wt_eveS2wt_color,...
%     'MarkerEdgeColor', 'black');
% l5 = plot(NaN,NaN, '-', 'LineWidth', 3, 'Color', 'black');
% l6 = plot(NaN,NaN, '--', 'LineWidth', 3, 'Color', 'black');

axis([0 round(max(maxFluo_vec) + max(maxFluo_vec)*0.1) 0 round(max(maxFreq_vec) + max(maxFreq_vec)*0.3)]);

% legend([l1, l2, l3, l4, l5, l6],...
%     {'eveS1\Delta-eveS2Gt','eveS1wt-eveS2Gt',...
%     'eveS1\Delta-eveS2wt','eveS1wt-eveS2wt',...
%     'endogenous', 'ectopic'},...
%     'Location','northwest', 'FontSize', 28, 'EdgeColor', 'black');
    
ylabel('\it k_o_n_ \rm(1/min)','Interpreter','tex', 'FontSize',12)

%xlabel('MS2 spot intensity (AU)')
set(gca,'XTickLabel',[]);

% set(gca,'FontSize',28)
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);


%title('K_o_n', 'FontSize',5)

end