clear;
clc;

%cd ..\BinStats\singleTraceFits\
filename1 = "singleTraceFits_eveS1wt_eveS2wt_Stripe_longform.csv";
filename2 = "singleTraceFits_eveS1Null_eveS2Gt_Stripe_longform.csv";

f = figure(1);
f.Units = 'centimeters';
f.OuterPosition = [0 0 8 12]; %tiled figure size in centimeters

t = tiledlayout(2,1);
t.Padding = "compact";
t.TileSpacing = "compact";
t.XLabel.String = 'Time into nc14 (min)';
t.XLabel.FontSize = 12;

t.YLabel.String = 'MS2 Fluorescence (AU)';
t.YLabel.FontSize = 12;

nexttile

traceNumber = 8;
plotTraces(filename1, traceNumber)

nexttile

traceNumber = 21;
plotTraces(filename2, traceNumber)

print(gcf,'plotTraces','-dpng','-r800'); 
%print(gcf,'plotTraces_ONOFF','-dpng','-r800'); 