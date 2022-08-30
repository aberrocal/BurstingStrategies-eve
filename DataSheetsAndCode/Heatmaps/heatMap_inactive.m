%heatMap_inactive creats a kymograph heatmap of MS2 fluorscence, using data
%from a single genotype (es1wt_es2wt, es1n_es2gt, es1wt_es2gt, es1n_es2wt),
%in _longform files. These files include the position of inactive nuclei over time.

%heatMap_inactive function is called by heatMap_inactive_all to generate
%tiled heatmaps in a single image. 
%Check line 63 to make logarithmic heatmaps.

%Labels font 10

% clear
% clc

% traces_es1wt_es2wt = readmatrix('singleTraceFits_Stripe_longform_eS1wt_eS2wt');
% traces_es1n_es2gt = readmatrix('singleTraceFits_Stripe_longform_eS1n_eS2gt');
% traces_es1wt_es2gt = readmatrix('singleTraceFits_Stripe_longform_eS1wt_eS2gt');
% traces_es1n_es2wt = readmatrix('singleTraceFits_Stripe_longform_eS1n_eS2wt.csv');
% 
% traces = traces_es1n_es2gt;
%
%   plttxt = title (genotype) for the heatmap.
%heatMap_inactive2(traces, plttxt)

function h = heatMap_inactive(traces, plttxt)
dAU = 10^4; %Divide arbitrary units by 10^5 to make it easier to read.
AAPosNorm = traces(:,11); %AP position of active and inactive nuclei.
AAPosNorm = round(AAPosNorm, 1);

fluoInterp = traces(:,9); %Fliorescence of active nuclei (inactive nuclei as NaN).

time = traces(:,1); %Time position of active and inactive nuclei.
%min(AAPosNorm)
%max(AAPosNorm)

%%%Add NaN values from AP 0 to 100 to generate heatmaps of the same size
for i = 0:0.1:min(AAPosNorm)
    
    if ~ismember(i, AAPosNorm)
        AAPosNorm(end+1) = i;
        fluoInterp(end+1) = NaN;
        time(end+1) = 0;
    end
    
end

for i = max(AAPosNorm):0.1:100
    
    AAPosNorm(end+1) = i;
    fluoInterp(end+1) = NaN;
    time(end+1) = 0;
    
end
%%%


fluoInterp(isnan(fluoInterp)) = 0; %NaN values are converted to 0
fluoInterp(fluoInterp < 0) = 0; %Values under 0 (due to extrapolation) are converted to 0
n_bins = length(min(AAPosNorm):0.5:max(AAPosNorm)); %Discretize values for heatmap
AAPosNorm = discretize(AAPosNorm, n_bins);

fluoInterp = fluoInterp ./ dAU;
tracesTable = table(time, AAPosNorm, fluoInterp); %Generate table for heatmap
h = heatmap(tracesTable,'AAPosNorm','time','ColorVariable','fluoInterp','Colormap',jet,'ColorLimits',[0 (300000 / dAU)]);
%Comment line above and uncomment line below to make the logarithmic version of the heatmaps. 
%h = heatmap(tracesTable,'AAPosNorm','time','ColorVariable','fluoInterp','Colormap',jet, 'ColorScaling','log', 'ColorLimits',[log(0.00001) log(30)]);

h.MissingDataColor = [0 0 0.5];
h.XLimits = {30,120}; %Heatmap size (from 0.15 to 0.6 embryo length)
h.Title = {};

h.XLabel = {};
h.YLabel = {};
h.GridVisible = 'off';

%%%Add Y labels (time)
idxY = 0:10:50;
idxY = idxY .* 60; 

for l = 1:1:length(h.YDisplayLabels)
    
    ydispLabel = str2double(cell2mat(h.YDisplayLabels(l)));
    if ~ismember(ydispLabel,idxY)
        
        h.YDisplayLabels(l) = {''};
        
    elseif ismember(ydispLabel,idxY)
        
        frame2time = round(ydispLabel * 1/60);
        h.YDisplayLabels(l) = {num2str(frame2time)};
        
    end
    
end

%Add X labels (space)
idxX = 0:20:120;
for l = 1:1:length(h.XDisplayLabels)
    
    if ~ismember(str2double(h.XDisplayLabels{l}),idxX)
        
        h.XDisplayLabels(l) = {''};
        
    elseif ismember(str2double(h.XDisplayLabels{l}),idxX)
        
        h.XDisplayLabels(l) = {str2double(h.XDisplayLabels{l})/200};
        
    end
    
end

%FontSize of heatmap legends
h.FontSize = 10;
%h.title = {plttxt};

%textHandles(1,1) = text(2.5,2.5,plttxt,'FontSize',12, 'horizontalAlignment','center')

%text(2.5,2.5,plttxt,'FontSize',12)

end
