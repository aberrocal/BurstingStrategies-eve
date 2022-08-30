%%This code calls the scripts to plot in a single graph the transcriptional kinetics per genotype
clear;
clc;

cd CompiledResults_Stripes
% titulo = 'eveS1\Delta-eveS2Gt';
% titulo = 'eveS1wt-eveS2Gt';
% titulo = 'eveS1\Delta-eveS2wt';
% titulo = 'eveS1wt-eveS2wt';

f = figure(1);
f.Units = 'centimeters';
f.OuterPosition = [0 0 19 26]; %tiled figure size in centimeters

t = tiledlayout(4,3);
t.Padding = "compact";
t.TileSpacing = "compact";
t.XLabel.String = 'Mean MS2 Fluorescence (AU)';
t.XLabel.FontSize = 12;

%set(gcf, 'WindowState', 'maximized');

%%%
titulo1 = 'eveS1wt-eveS2wt';
titulo2 = 'eveS1wt-eveS2Gt';
titulo3 = 'eveS1\Delta-eveS2wt';
titulo4 = 'eveS1\Delta-eveS2Gt';

nexttile

StripesKinetics_Freq_0_2(titulo1)

nexttile

StripesKinetics_Dur_0_2(titulo1)

nexttile

StripesKinetics_Int_0_2(titulo1)

%%%
nexttile

StripesKinetics_Freq_0_2(titulo2)

nexttile

StripesKinetics_Dur_0_2(titulo2)

nexttile

StripesKinetics_Int_0_2(titulo2)

%%%
nexttile

StripesKinetics_Freq_0_2(titulo3)

nexttile

StripesKinetics_Dur_0_2(titulo3)

nexttile

StripesKinetics_Int_0_2(titulo3)

%%%
nexttile

StripesKinetics_Freq_0_2(titulo4)

nexttile

StripesKinetics_Dur_0_2(titulo4)

nexttile

StripesKinetics_Int_0_2(titulo4)

print(gcf,'fdi_color_0_2.png','-dpng','-r800'); 
%saveas(gcf,'./fdi.tif')

% set(gcf, 'PaperUnits', 'normalized');
% set(gcf, 'PaperType', 'A4');
% % set(gcf, 'PaperPositionMode', 'auto');
% set(gcf, 'PaperOrientation', 'landscape');



