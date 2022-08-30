%%This code calls the scripts to plot in a single graph 
%the transcriptional kinetics separated by endogenous and ectopic
%accross many genotypes
clear;
clc;

cd CompiledResults_EndogenousEctopic
f = figure(1);
f.Units = 'centimeters';
f.OuterPosition = [0 0 19 28]; %tiled figure size in centimeters

t = tiledlayout(3,1);
t.Padding = "compact";
t.TileSpacing = "loose";
t.XLabel.String = 'Mean MS2 Fluorescence (AU)';
t.XLabel.FontSize = 12;


nexttile

StripesKinetics_Freq_ee2()
%pbaspect([1 0.5 0.5])

nexttile

StripesKinetics_Dur_ee2()
%pbaspect([1 0.5 0.5])

nexttile

StripesKinetics_Int_ee2()
%pbaspect([1 0.5 0.5])

print(gcf,'ee_final3.png','-dpng','-r800'); 
%saveas(f,'./ee.png')
