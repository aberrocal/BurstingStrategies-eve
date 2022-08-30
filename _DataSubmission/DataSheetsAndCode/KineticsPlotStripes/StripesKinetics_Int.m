% clc; 
% clear;

% titulo = 'eveS1\Delta-eveS2Gt';
% titulo = 'eveS1wt-eveS2Gt';
% titulo = 'eveS1\Delta-eveS2wt';
% titulo = 'eveS1wt-eveS2wt';

function StripesKinetics_Int(titulo)

F = dir('ev*');
dAU = 10^4; %Divide arbitrary units by 10^5 to make it easier to read.

for i = 1:length(F)

    folder = F(i).name;
    cd(folder)
    
    file = dir('*.mat');
    load(file.name)
    
    if isequal(folder,'eveS1Null-eveS2Gt')
        
        eveS1Null_eveS2Gt_int = compiledResults.init_vec_mean ./ dAU;
        eveS1Null_eveS2Gt_int_ste = compiledResults.init_vec_ste ./ dAU;
        
        
        eveS1Null_eveS2Gt_fluo_mean = compiledResults.fluo_mean ./ dAU;   
        eveS1Null_eveS2Gt_stripe = compiledResults.additionalGroupVec;
        
    elseif isequal(folder,'eveS1Null-eveS2wt')
        
        eveS1Null_eveS2wt_int = compiledResults.init_vec_mean ./ dAU;
        eveS1Null_eveS2wt_int_ste = compiledResults.init_vec_ste ./ dAU;
        
        
        eveS1Null_eveS2wt_fluo_mean = compiledResults.fluo_mean ./ dAU;
        eveS1Null_eveS2wt_stripe = compiledResults.additionalGroupVec;
        
    elseif isequal(folder,'eveS1wt-eveS2Gt')
        
        eveS1wt_eveS2Gt_int = compiledResults.init_vec_mean ./ dAU;
        eveS1wt_eveS2Gt_int_ste = compiledResults.init_vec_ste ./ dAU;
        
        
        eveS1wt_eveS2Gt_fluo_mean = compiledResults.fluo_mean ./ dAU;
        eveS1wt_eveS2Gt_stripe = compiledResults.additionalGroupVec;
        
    elseif isequal(folder,'eveS1wt-eveS2wt')
        
        eveS1wt_eveS2wt_int = compiledResults.init_vec_mean ./ dAU;
        eveS1wt_eveS2wt_int_ste = compiledResults.init_vec_ste ./ dAU;
        
        
        eveS1wt_eveS2wt_fluo_mean = compiledResults.fluo_mean ./ dAU;
        eveS1wt_eveS2wt_stripe = compiledResults.additionalGroupVec;
        
    end
    
    
    cd('..')
end


maxFluo = max([eveS1Null_eveS2Gt_fluo_mean, eveS1Null_eveS2wt_fluo_mean,...
    eveS1wt_eveS2Gt_fluo_mean, eveS1wt_eveS2wt_fluo_mean]);

maxInt = max([eveS1Null_eveS2Gt_int, eveS1Null_eveS2wt_int,...
    eveS1wt_eveS2Gt_int, eveS1wt_eveS2wt_int]);


%%%%%
%%%%% Change titulo and genotype variables for each phenotype

%titulo = 'eveS1\Delta-eveS2Gt';

if isequal(titulo, 'eveS1\Delta-eveS2Gt')
    
    genotype_int = eveS1Null_eveS2Gt_int;
    genotype_int_ste = eveS1Null_eveS2Gt_int_ste;
    
    genotype_fluo_mean = eveS1Null_eveS2Gt_fluo_mean;
    genotype_stripe = eveS1Null_eveS2Gt_stripe;
    
elseif isequal(titulo, 'eveS1wt-eveS2Gt')
    
    genotype_int = eveS1wt_eveS2Gt_int;
    genotype_int_ste = eveS1wt_eveS2Gt_int_ste;
    
    genotype_fluo_mean = eveS1wt_eveS2Gt_fluo_mean;
    genotype_stripe = eveS1wt_eveS2Gt_stripe;
    
elseif isequal(titulo, 'eveS1\Delta-eveS2wt')
    
    genotype_int = eveS1Null_eveS2wt_int;
    genotype_int_ste = eveS1Null_eveS2wt_int_ste;
    
    genotype_fluo_mean = eveS1Null_eveS2wt_fluo_mean;
    genotype_stripe = eveS1Null_eveS2wt_stripe;
    
elseif isequal(titulo, 'eveS1wt-eveS2wt')
    
    genotype_int = eveS1wt_eveS2wt_int;
    genotype_int_ste = eveS1wt_eveS2wt_int_ste;
    
    genotype_fluo_mean = eveS1wt_eveS2wt_fluo_mean;
    genotype_stripe = eveS1wt_eveS2wt_stripe;
    
end


%%%

% errb = errorbar(genotype_fluo_mean, genotype_int, genotype_int_ste, 'vertical');
% 
% errb.LineStyle = 'none';
% errb.CapSize = 0;
% errb.Color = 'black';
% errb.LineWidth = 1.5;
% 
% hold on

unique_stripes = unique(genotype_stripe);

es0shape = '-';
es1shape = '-'; 
es15shape = '--';
es2shape = '-.';
es3shape = ':';
es4shape = '--';

for k = 1:length(unique_stripes)
    
    strInd = find(genotype_stripe == unique_stripes(k));
    
    %same shape for same stripe, always
    if unique_stripes(k) == -1
        lineShape = es0shape;
    elseif unique_stripes(k) == 1
        lineShape = es1shape;
    elseif unique_stripes(k) == 1.5
        lineShape = es15shape;
    elseif unique_stripes(k) == 2
        lineShape = es2shape;
    elseif unique_stripes(k) == 3
        lineShape = es3shape;
    elseif unique_stripes(k) == 4
        lineShape = es4shape;
    end
    
    %plot new line per stripe in a loop
    
    if unique_stripes(k) == -1 || unique_stripes(k) == 1.5
        strColor = "r";
        linewidth = 1.5;
    else
        strColor = "k";
        linewidth = 1;
    end
    
    %%%Plot with error shaded areas for ectopic values
    %%%
    [x2_geno, inBetween_geno] = shadedSte(genotype_int(strInd), genotype_fluo_mean(strInd), genotype_int_ste(strInd));
    %str = strColor;
    %Convert color code to 1-by-3 RGB array (0~1 each)
    %colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
    h = fill(x2_geno, inBetween_geno, strColor);
    set(h,'facealpha',.2)
    set(h,'EdgeColor','none')
    hold on;
    
    
    plot(genotype_fluo_mean(strInd), genotype_int(strInd), 'color', strColor, 'LineWidth', linewidth, 'LineStyle', lineShape);
    
    hold on
        
end

%round(maxInt + maxInt*0.1)
axis([0 round(maxFluo + maxFluo*0.1) 0 round(maxInt + maxInt*0.1)])
%axis([0 300000 0 180000])

%grid on
ax = gca;
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;

hold on

% plot_dummies for legend

l1 = plot(NaN,NaN, es0shape, 'LineWidth', 2, 'Color', 'r');
l2 = plot(NaN,NaN, es1shape, 'LineWidth', 2, 'Color', 'k');
l3 = plot(NaN,NaN, es15shape, 'LineWidth', 2, 'Color', 'r');
l4 = plot(NaN,NaN, es2shape, 'LineWidth', 2, 'Color', 'k');
l5 = plot(NaN,NaN, es3shape, 'LineWidth', 2, 'Color', 'k');
l6 = plot(NaN,NaN, es4shape, 'LineWidth', 2, 'Color', 'k');

% ylabel('Burst Amplitude (AU/min)')
% xlabel('MS2 spot intensity (AU)')

if ~isequal(titulo, 'eveS1\Delta-eveS2wt')
    set(gca,'XTickLabel',[]);
end

if isequal(titulo, 'eveS1wt-eveS2wt')
    title('\itr', 'FontSize',12)
end

if isequal(titulo, 'eveS1\Delta-eveS2wt')
    legend([l1, l2, l3, l4, l5, l6], {'eveS0','eveS1',...
        'eveS1-2','eveS2','eveS3','eveS4'},...
        'Location', 'none', ...
        'Position',[0.824769707428537 0.0797403792871828 0.133903132077635 0.134214182639487],...
        'FontSize', 8);
    legend('boxoff')
end

%%% Label panels
if isequal(titulo, 'eveS1\Delta-eveS2Gt') || isequal(titulo, 'eveS1wt-eveS2Gt')
    plttxt = strcat(titulo,'^{-}');
elseif isequal(titulo, 'eveS1wt-eveS2wt')
    plttxt = 'Wild-type';
elseif isequal(titulo, 'eveS1\Delta-eveS2wt')
    plttxt = titulo;
end

%Rule of three to position the title of intensity plot at the same position
%as the titles for frequency and duration plots.
rt1 = round(maxInt + maxInt*0.1);
%rt1 = 15;
rt2 = 3;
rt3 = 2.7;

rt = rt3 * rt1 / rt2;

text(0.2,rt,plttxt,'FontSize',10)
%%%

%lgd.Position
ylabel('\itr \rm(AU/min)','Interpreter','tex','FontSize',12)

% set(gca,'FontSize',28)
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

%title(titulo, 'FontSize',34, 'Interpreter', 'tex')

end