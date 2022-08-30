%%%StripesKinetics_Int_ee.m reads compiledResults_ectopicFlag.mat files,
%%%and plots r values of endogenous and ectopic nuclei sorted 
%%%by mean fluorescence bins

%%%This script plots endogenous and ectopic patterns 
%%%for all genotypes collapsed on the same graph

%%%compiledResults_ectopicFlat files must be in a folders and subfolders
%%%with the format 
%%%eveS1Null-eveS2Gt/compiledResults_w7_K3_p0_ap1_t1_f2D_ectopicFlag.mat

% clc; 
% clear;

function StripesKinetics_Int_ee2

F = dir('ev*');
dAU = 10^4; %Divide arbitrary units by 10^5 to make it easier to read.

maxInt_vec = [];
maxFluo_vec = [];

%Go through all folders (eveS1Null-eveS2Gt, eveS1Null-eveS2wt,
%eveS1wt-eveS2Gt, eveS1wt-eveS2wt) and load the .mat file in each folder
for i = 1:length(F)
    
    folder = F(i).name;
    cd(folder)
    
    file = dir('*.mat');
    load(file.name)
    
    %Save mean intensity values (r) and ste over each fluorescent bin
    int = compiledResults.init_vec_mean ./ dAU;
    int_ste = compiledResults.init_vec_ste ./ dAU;
    
    fluo_mean = compiledResults.fluo_mean ./ dAU;
    ee_flag = compiledResults.additionalGroupVec;
    
    maxInt_vec(i) = max(int);
    maxFluo_vec(i) = max(fluo_mean);
    
    endo = find(ee_flag == 0);
    ecto = find(ee_flag == 1);
        
    %Plot r values of endogenous and ectopic patterns, different colors
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
    [x2_endo, inBetween_endo] = shadedSte(int(endo), fluo_mean(endo), int_ste(endo));
    colLine = 'black';
    %Convert color code to 1-by-3 RGB array (0~1 each)
    %colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255; 
    h = fill(x2_endo, inBetween_endo, colLine);
    set(h,'facealpha',.1)
    set(h,'EdgeColor','none')
    hold on;
    plot(fluo_mean(endo), int(endo), 'color', colLine, 'LineWidth', 2, 'LineStyle', genotypeLine);
    
    hold on
    
    %%%Plot with error shaded areas for ectopic values
    %%%
    [x2_ecto, inBetween_ecto] = shadedSte(int(ecto), fluo_mean(ecto), int_ste(ecto));
    colLine = 'red';
    %Convert color code to 1-by-3 RGB array (0~1 each)
    %colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255; 
    h = fill(x2_ecto, inBetween_ecto, colLine);
    set(h,'facealpha',.2)
    set(h,'EdgeColor','none')
    hold on;
    plot(fluo_mean(ecto), int(ecto), 'color', colLine, 'LineWidth', 3, 'LineStyle','-');
        
    hold on
    
    cd('..')
    
end

ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;

%grid on

% maxInt = max(maxInt_vec);
% maxFluo = max(maxFluo_vec);

hold on

%%%Plot dummies for legends with the genotype colors
l1 = plot(NaN,NaN, eveS1wt_eveS2wt_line, 'LineWidth', 2, 'Color', 'black');
l2 = plot(NaN,NaN, eveS1wt_eveS2Gt_line, 'LineWidth', 2,'Color', 'black');
l3 = plot(NaN,NaN, '-', 'LineWidth', 2,  'Color', 'red');
l4 = plot(NaN,NaN, eveS1Null_eveS2Gt_line, 'LineWidth', 2,'Color', 'black');
l5 = plot(NaN,NaN, eveS1Null_eveS2wt_line, 'LineWidth', 2,'Color', 'black');

legend([l1, l2, l3, l4, l5],...
    {'Wild-type',...
    'eveS1wt-eveS2Gt^{-}',...
    'eveS1\Delta-eveS2Gt^{-} (ectopic)',...
    'eveS1\Delta-eveS2Gt^{-} (endogenous)',...
    'eveS1\Delta-eveS2wt'},...
    'Location','southeast', 'FontSize', 10, 'EdgeColor', 'black');
legend('boxoff');
    

ylabel('\it r \rm(AU/min)','Interpreter','tex','FontSize',12)


%xlabel('MS2 spot intensity (AU)')

% set(gca,'FontSize',28)
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%title('r', 'FontSize',5)

end