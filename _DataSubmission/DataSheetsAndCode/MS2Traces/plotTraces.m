%This code reads single MS2 traces and cpHMM inferences and plots them.

% clear;
% clc;

%make sure that the right path is enabled
%cd ..\BinStats\singleTraceFits\
%filename = "singleTraceFits_eveS1Null_eveS2Gt_Stripe_longform.csv";

function plotTraces(filename, traceNumber)

%I will plot traces from eveS1Null_eveS2Gt embryos.
traceFits = readmatrix(filename); %read matrix with all data
dAU = 10^4; %Divide arbitrary units by 10^4 to make it easier to read.

%%%retrieve the ID of particle that displayed more data points
particleID = traceFits(:,7); %particleID column
[C,~,ic] = unique(particleID); %get unique values and their index (index to C)

particleID_counts = accumarray(ic,1); %count the number of appearances of each element
value_counts = [C, particleID_counts];
value_counts_noNaNs = rmmissing(value_counts); %delete NaNs

[~, ilong] = maxk(value_counts_noNaNs(:,2), traceNumber); %retrieve the n most recurring elements
trace_IDsandDPs = value_counts_noNaNs(ilong,:) %find the most recurring particle ids and their counts.
traceIDandDP = trace_IDsandDPs(end,:)

%%% Use particleIDs with most data points for plotting

trace_i = find(traceFits(:,7) == traceIDandDP(1)); %find index of all the appearances of selected particle id in dataset

trace_time = traceFits(trace_i,1); %time - time points of selected particle id
trace_time = trace_time ./ 60; %convert time units from seconds to minutes

trace_fluoInterp = traceFits(trace_i,9); %fluoInterp - interpolated fluorescence of selected particle id
trace_fluoInterp = trace_fluoInterp ./ dAU; %divide AU by 10^4 for easier reading

trace_promoter_state = traceFits(trace_i,12); %promoter_state - promoter state (inferred by cpHMM) of selected particle id
trace_promoter_state = trace_promoter_state - 1; %substract 1 from promoter state so OFF is 0 instead of 1.

trace_predicted_fluo = traceFits(trace_i,13); %predicted_fluo - predicted fluorescence (inferred by cpHMM) of selected particle id
trace_predicted_fluo = trace_predicted_fluo ./ dAU; %divide AU by 10^4 for easier reading

%Plot raw traces (trace_fluoInterp), traces predicted by cpHMM (trace_predicted_fluo)
%and promoter state (trace_promoter_state)

p1 = plot(trace_time, trace_fluoInterp, 'color', "#32CD30", 'LineWidth', 5);
%p1.Color(4) = 0.75; %add transparency to line
hold on
plot(trace_time, trace_predicted_fluo, 'color', "#000000", 'LineWidth', 2);
hold on

%Select which promoter state bars to plot
bar(trace_time, trace_promoter_state .* 2.5, 'FaceColor', "#7E2F8E", 'EdgeColor', "#7E2F8E"); %multiply promoter state values to increase bar size
%Keep promoter state bars of the same size (ON and OFF, instead of ON1,
%ON2, and OFF)
%bar(trace_time, (trace_promoter_state ./ trace_promoter_state) + 1, 'FaceColor', "#7E2F8E", 'EdgeColor', "#7E2F8E"); %multiply promoter state values to increase bar size

%Set size of x-axis (0-50 min) and y axis (0-40 AU)
axis([0 50 0 40])
ax = gca;


ax.YAxis.FontSize = 10;
ax.YTick = [0, 20, 40];
ax.YTickLabel = {'0','20','40'};

%Labeling trace plots from eveS1wt_eveS2wt and eveS1Null_eveS2Gt datasets
if isequal(filename, "singleTraceFits_eveS1wt_eveS2wt_Stripe_longform.csv")
    plttxt1 = strcat('Wild-type');
    plttxt2 = strcat('particleID: ', num2str(traceIDandDP(1)));

    ax.XTick = [10, 20, 30, 40, 50];
    ax.XTickLabel = {'','','', '', ''};

    text(1,38,plttxt1,'FontSize',10)
    text(1,34,plttxt2,'FontSize',10)

    yyaxis right
    ax.YTick = [];

end

if isequal(filename, "singleTraceFits_eveS1Null_eveS2Gt_Stripe_longform.csv")
    plttxt1 = strcat('eveS1\Delta-eveS2Gt','^{-}');
    plttxt2 = strcat('particleID:', num2str(traceIDandDP(1)));

    text(1,38,plttxt1,'FontSize',10)
    text(1,34,plttxt2,'FontSize',10)

    ax.XAxis.FontSize = 10;
    ax.XTick = [0, 10, 20, 30, 40, 50];
    ax.XTickLabel = {'0', '10','20','30', '40', '50'};

    yyaxis right
    ylabel('cpHMM-inferred promoter state', 'Rotation', 270, 'VerticalAlignment','bottom')
    ax.YTick = [];

    % plot_dummies for legend
    l1 = plot(NaN,NaN, '-', 'LineWidth', 5, 'Color', "#32CD30");
    l2 = plot(NaN,NaN, '-', 'LineWidth', 2, 'Color', "#000000");

    legend([l1, l2], {'observed fluo','cpHMM fluo'},...
        'Location', 'none', ...
        'Position',[0.167832167832168,0.340529900264625,0.460863247105681,0.10110803059924],...
        'FontSize', 9);
    legend('boxoff')

end

end

