%shadedSte generates the variables x2 and inBetween. Both are inputs of the
%fill() function, which generates a shaded area to plot ste

%From mathworks
%https://www.mathworks.com/matlabcentral/answers/180829-shade-area-between-graphs#answer_169649

%%%Code that uses the function shadedSte
% [x2, inBetween] = shadedSte2(dur, fluo_mean, dur_ste)
% 
% str = genotypeColor;
%
% Convert color code to 1-by-3 RGB array (0~1 each)
% colRGB = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255; 
% h = fill(x2, inBetween, colRGB);
% set(h,'facealpha',.1)
% hold on;
% plot(fluo_mean, dur, 'color', colRGB, 'LineWidth', 2);

function [x2, inBetween] = shadedSte(mvec, fluo, ste)

% Convert color code to 1-by-3 RGB array (0~1 each)

y = mvec; % your mean vector;
x = fluo;
ste_dev = ste;
curve1 = y + ste_dev;
curve2 = y - ste_dev;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];

end
