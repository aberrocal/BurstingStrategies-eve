%heatMap_inactive_all takes the heatmaps generated by heatMap_inactive and
%tile them to generate a figure for publication.
%Check heatMap_inactive.m to plot logarithmic heatmap.
%Labels font = 12

clear;
clc;

f = figure(1);
f.Units = 'centimeters';
f.OuterPosition = [0 0 16 24]; %tiled figure size in centimeters
%f.OuterPosition = [0.2 0.2 4 9]; %tiled figure size in inches

t = tiledlayout(4,1); %4 heatmaps in 1 column

t.Padding = "compact";
t.TileSpacing = "loose";
t.XLabel.String = 'Fraction of Embryo Length';
t.XLabel.FontSize = 12;
t.YLabel.String = 'Time in nc14 (min)';
t.YLabel.FontSize = 12;

%Read the four _longform datasets. They include the position of inactive
%nuclei.
traces_es1n_es2gt = readmatrix('./singleTraceFits_Heatmaps/singleTraceFits_Stripe_longform_es1n_es2gt');
traces_es1wt_es2gt = readmatrix('./singleTraceFits_Heatmaps/singleTraceFits_Stripe_longform_es1wt_es2gt');
traces_es1n_es2wt = readmatrix('./singleTraceFits_Heatmaps/singleTraceFits_Stripe_longform_es1n_es2wt');
traces_es1wt_es2wt = readmatrix('./singleTraceFits_Heatmaps/singleTraceFits_Stripe_longform_es1wt_es2wt');

% titulo = 'eveS1\Delta-eveS2Gt';
% titulo = 'eveS1wt-eveS2Gt';
% titulo = 'eveS1\Delta-eveS2wt';
% titulo = 'eveS1wt-eveS2wt';

nexttile

titulo = 'Wild-type';
plttxt = titulo;
h1 = heatMap_inactive(traces_es1wt_es2wt, plttxt);
h1.Title = plttxt;

nexttile
 
titulo = 'eveS1wt-eveS2Gt';
plttxt = strcat(titulo,'^{-}');
h2 = heatMap_inactive(traces_es1wt_es2gt, plttxt);
h2.Title = plttxt;

nexttile
 
titulo = 'eveS1\Delta-eveS2wt';
plttxt = titulo;
h3 = heatMap_inactive(traces_es1n_es2wt, plttxt);
h3.Title = plttxt;

nexttile
 
titulo = 'eveS1\Delta-eveS2Gt';
plttxt = strcat(titulo,'^{-}');
h4 = heatMap_inactive(traces_es1n_es2gt, plttxt);
h4.Title = plttxt;

print(gcf,'heatmaps_log_final.png','-dpng','-r800'); 
%saveas(f,'heatmaps.png','-dpng','-r300')

  
