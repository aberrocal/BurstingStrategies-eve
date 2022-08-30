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

%Assign different line shape to stripes according on whether they are
%activated by mutant enhancers or not
% : ectopic stripes (at bigger linewidth)
% - endogenous stripes driven by wt enhancers
% -- ensogenous stripes driven by mutant enhancers

es0shape = ':';
es15shape = ':';
es3shape = '-';
es4shape = '-';

if isequal(titulo, 'eveS1\Delta-eveS2Gt')
    es1shape = '--';
    es2shape = '--';
elseif isequal(titulo,'eveS1\Delta-eveS2wt')
    es1shape = '--';
    es2shape = '-';
elseif isequal(titulo, 'eveS1wt-eveS2Gt')
    es1shape = '-';
    es2shape = '--';
elseif isequal(titulo,'eveS1wt-eveS2wt')
    es1shape = '-';
    es2shape = '-';
end

%%%
%%%
%%%

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
    
    %%%Plot with error shaded areas for ectopic values
    %%%
    [x2_geno, inBetween_geno] = shadedSte(genotype_int(strInd), genotype_fluo_mean(strInd), genotype_int_ste(strInd));
    str = strColor;
    %Convert color code to 1-by-3 RGB array (0~1 each)
    colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
    %h = fill(x2_geno, inBetween_geno, strColor);
    h = fill(x2_geno, inBetween_geno, colRGB);
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

l1 = plot(NaN,NaN, es0shape, 'LineWidth', 2, 'Color', es0color);
l2 = plot(NaN,NaN, '-', 'LineWidth', 2, 'Color', es1color);
l3 = plot(NaN,NaN, es15shape, 'LineWidth', 2, 'Color', es15color);
l4 = plot(NaN,NaN, '-', 'LineWidth', 2, 'Color', es2color);
l5 = plot(NaN,NaN, '-', 'LineWidth', 2, 'Color', es3color);
l6 = plot(NaN,NaN, '-', 'LineWidth', 2, 'Color', es4color);
l7 = plot(NaN,NaN, '-', 'LineWidth', 2, 'Color', 'black');
l8 = plot(NaN,NaN, ':', 'LineWidth', 2, 'Color',  'black');
l9 = plot(NaN,NaN, '--', 'LineWidth', 2, 'Color',  'black');
% ylabel('Burst Amplitude (AU/min)')
% xlabel('MS2 spot intensity (AU)')

if ~isequal(titulo, 'eveS1\Delta-eveS2Gt')
    set(gca,'XTickLabel',[]);
end

if isequal(titulo, 'eveS1wt-eveS2wt')
    title('\itr', 'FontSize',12)
end

if isequal(titulo, 'eveS1\Delta-eveS2wt')
    legend([l1, l2, l3, l4, l5, l6, l7, l8, l9], {'eveS0','eveS1',...
        'eveS1-2','eveS2','eveS3','eveS4','endo-wt','ecto','endo-mt'},...
        'Location', 'none', ...
        'Position',[0.824769707428537 0.300880852166181 0.133903132077635 0.134214182639487],...
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