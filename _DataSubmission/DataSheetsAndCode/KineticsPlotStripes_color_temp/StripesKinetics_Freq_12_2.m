% clc; 
% clear;

% titulo = 'eveS1\Delta-eveS2Gt';
% titulo = 'eveS1wt-eveS2Gt';
% titulo = 'eveS1\Delta-eveS2wt';
% titulo = 'eveS1wt-eveS2wt';

function StripesKinetics_Freq_12_2(titulo)

F = dir('ev*');
dAU = 10^4; %Divide arbitrary units by 10^5 to make it easier to read.

for i = 1:length(F)

    folder = F(i).name;
    cd(folder)
    
    file = dir('*.mat');
    load(file.name)
    
    if isequal(folder,'eveS1Null-eveS2Gt')
        
        eveS1Null_eveS2Gt_freq = compiledResults.freq_vec_mean;
        eveS1Null_eveS2Gt_freq_ste = compiledResults.freq_vec_ste;
        
        
        eveS1Null_eveS2Gt_fluo_mean = compiledResults.fluo_mean ./ dAU;   
        eveS1Null_eveS2Gt_stripe = compiledResults.additionalGroupVec;

        eveS1Null_eveS2Gt_bin = compiledResults.groupID_index;
        
    elseif isequal(folder,'eveS1Null-eveS2wt')
        
        eveS1Null_eveS2wt_freq = compiledResults.freq_vec_mean;
        eveS1Null_eveS2wt_freq_ste = compiledResults.freq_vec_ste;
        
        
        eveS1Null_eveS2wt_fluo_mean = compiledResults.fluo_mean ./ dAU;
        eveS1Null_eveS2wt_stripe = compiledResults.additionalGroupVec;
        
    elseif isequal(folder,'eveS1wt-eveS2Gt')
        
        eveS1wt_eveS2Gt_freq = compiledResults.freq_vec_mean;
        eveS1wt_eveS2Gt_freq_ste = compiledResults.freq_vec_ste;
        
        
        eveS1wt_eveS2Gt_fluo_mean = compiledResults.fluo_mean ./ dAU;
        eveS1wt_eveS2Gt_stripe = compiledResults.additionalGroupVec;
        
    elseif isequal(folder,'eveS1wt-eveS2wt')
        
        eveS1wt_eveS2wt_freq = compiledResults.freq_vec_mean;
        eveS1wt_eveS2wt_freq_ste = compiledResults.freq_vec_ste;
        
        
        eveS1wt_eveS2wt_fluo_mean = compiledResults.fluo_mean ./ dAU;
        eveS1wt_eveS2wt_stripe = compiledResults.additionalGroupVec;
        
    end
    
    cd('..')
end


maxFluo = max([eveS1Null_eveS2Gt_fluo_mean, eveS1Null_eveS2wt_fluo_mean,...
    eveS1wt_eveS2Gt_fluo_mean, eveS1wt_eveS2wt_fluo_mean]);

maxFreq = max([eveS1Null_eveS2Gt_freq, eveS1Null_eveS2wt_freq,...
    eveS1wt_eveS2Gt_freq, eveS1wt_eveS2wt_freq]);


%%%%%
%%%%% Change titulo and genotype variables for each phenotype

%titulo = 'eveS1\Delta-eveS2Gt';

if isequal(titulo, 'eveS1\Delta-eveS2Gt')
    
    genotype_freq = eveS1Null_eveS2Gt_freq;
    genotype_freq_ste = eveS1Null_eveS2Gt_freq_ste;
    
    genotype_fluo_mean = eveS1Null_eveS2Gt_fluo_mean;
    genotype_stripe = eveS1Null_eveS2Gt_stripe;
    
elseif isequal(titulo, 'eveS1wt-eveS2Gt')
    
    genotype_freq = eveS1wt_eveS2Gt_freq;
    genotype_freq_ste = eveS1wt_eveS2Gt_freq_ste;
    
    genotype_fluo_mean = eveS1wt_eveS2Gt_fluo_mean;
    genotype_stripe = eveS1wt_eveS2Gt_stripe;
    
elseif isequal(titulo, 'eveS1\Delta-eveS2wt')
    
    genotype_freq = eveS1Null_eveS2wt_freq;
    genotype_freq_ste = eveS1Null_eveS2wt_freq_ste;
    
    genotype_fluo_mean = eveS1Null_eveS2wt_fluo_mean;
    genotype_stripe = eveS1Null_eveS2wt_stripe;
    
elseif isequal(titulo, 'eveS1wt-eveS2wt')
    
    genotype_freq = eveS1wt_eveS2wt_freq;
    genotype_freq_ste = eveS1wt_eveS2wt_freq_ste;
    
    genotype_fluo_mean = eveS1wt_eveS2wt_fluo_mean;
    genotype_stripe = eveS1wt_eveS2wt_stripe;
    
end

%%%%
%%%%
%%%Fix to plot only a few stripes in the dataset
unique_stripes_all = unique(genotype_stripe);

unique_stripes = unique_stripes_all(unique_stripes_all > 1 &...
    unique_stripes_all < 3); %select which stripes to plot stripes
%%%%
%%%%

%shape
es0shape = '-';
es1shape = '-'; 
es15shape = '-';
es2shape = '-';
es3shape = '-';
es4shape = '-';

%color
es0color = '#0072B2'; %blue
es1color = '#CC79A7'; %reddish purple
es15color = '#D55E00'; %vermillion
es2color = '#E69F00'; %orange
es3color = '#009E73'; %bluish green
es4color = '#676767'; %gray
%es4color = '#F0E442'; %yellow

for k = 1:length(unique_stripes)
    
    strInd = find(genotype_stripe == unique_stripes(k));
    
     %same shape for same stripe, always
    if unique_stripes(k) == -1
        lineShape = es0shape;  
        strColor = es0color;
        linewidth = 3;
    elseif unique_stripes(k) == 1
        lineShape = es1shape; 
        strColor = es1color;
        linewidth = 1;
    elseif unique_stripes(k) == 1.5
        lineShape = es15shape; 
        strColor = es15color;
        linewidth = 3;
    elseif unique_stripes(k) == 2
        lineShape = es2shape;   
        strColor = es2color;
        linewidth = 1;
    elseif unique_stripes(k) == 3
        lineShape = es3shape;  
        strColor = es3color;
        linewidth = 1;
    elseif unique_stripes(k) == 4
        lineShape = es4shape;  
        strColor = es4color;
        linewidth = 1;
    end
        
    %plot new line per stripe in a loop
    
%     if unique_stripes(k) == -1 || unique_stripes(k) == 1.5
%         strColor = "r";
%         linewidth = 1.5;
%     else
%         strColor = "k";
%         linewidth = 1;
%     end

    if isequal(titulo, 'eveS1\Delta-eveS2Gt')
        if unique_stripes(k) == 2
            fprintf('titulo'); titulo %dataset
            fprintf('stripe (code)'); unique_stripes(k) %stripe analyzed (code)
            fprintf('bin ID'); eveS1Null_eveS2Gt_bin(strInd) %number of bin
    
            fprintf('\n kon'); genotype_freq(strInd) %frequency
            fprintf('fluorescence'); genotype_fluo_mean(strInd) %fluorescence
            fprintf('stripe (dataset)'); eveS1Null_eveS2Gt_stripe(strInd) %stripe from data set, must match strope analyzed (code)
        end
    end
    
    %%%Plot with error shaded areas for ectopic values
    %%%
    [x2_geno, inBetween_geno] = shadedSte(genotype_freq(strInd), genotype_fluo_mean(strInd), genotype_freq_ste(strInd));
    str = strColor;
    %Convert color code to 1-by-3 RGB array (0~1 each)
    colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
    %h = fill(x2_geno, inBetween_geno, strColor);
    h = fill(x2_geno, inBetween_geno, colRGB);
    set(h,'facealpha',.2)
    set(h,'EdgeColor','none')
    hold on;
    
   
    p = plot(genotype_fluo_mean(strInd), genotype_freq(strInd), 'color', strColor, 'LineWidth', linewidth, 'LineStyle', lineShape, 'Marker', 'o');
    p.MarkerSize = 6;
    p.MarkerFaceColor = strColor;
    hold on
    
end

axis([0 round(maxFluo + maxFluo*0.1) 0 round(maxFreq + maxFreq*0.3)])

%round(maxFreq + maxFreq*0.3)
%axis([0 300000 0 180000])

%grid on
ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.YTick = [0, 1, 2, 3];
ax.YTickLabel = {'0','1','2','3'};

hold on

% plot_dummies for legend

% l1 = plot(NaN,NaN, es0shape, 'LineWidth', 6, 'Color', 'r');
% l2 = plot(NaN,NaN, es1shape, 'LineWidth', 6, 'Color', 'k');
% l3 = plot(NaN,NaN, es15shape, 'LineWidth', 6, 'Color', 'r');
% l4 = plot(NaN,NaN, es2shape, 'LineWidth', 6, 'Color', 'k');
% l5 = plot(NaN,NaN, es3shape, 'LineWidth', 6, 'Color', 'k');
% l6 = plot(NaN,NaN, es4shape, 'LineWidth', 6, 'Color', 'k');

% legend([l1, l2, l3, l4, l5, l6], {'eveS0','eveS1',...
%     'eveS1-2 interstripe','eveS2','eveS3','eveS4'},...
%     'Location','northwest', 'FontSize', 28, 'EdgeColor', 'black');

% ylabel('Burst Frequency (1/min)')
% xlabel('MS2 spot intensity (AU)')

if ~isequal(titulo, 'eveS1\Delta-eveS2Gt')
    set(gca,'XTickLabel',[]);
end

if isequal(titulo, 'eveS1wt-eveS2wt')
    title('\itk_o_n', 'FontSize',12)
end

%%% Label panels
if isequal(titulo, 'eveS1\Delta-eveS2Gt') || isequal(titulo, 'eveS1wt-eveS2Gt')
    plttxt = strcat(titulo,'^{-}');
elseif isequal(titulo, 'eveS1wt-eveS2wt')
    plttxt = 'Wild-type';
elseif isequal(titulo, 'eveS1\Delta-eveS2wt')
    plttxt = titulo;
end
text(0.2,2.7,plttxt,'FontSize',10)
%%%

ylabel('\itk_o_n_ \rm(1/min)','Interpreter','tex','FontSize',12)

% set(gca,'FontSize',28)
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%title(titulo, 'FontSize',34, 'Interpreter', 'tex')

end