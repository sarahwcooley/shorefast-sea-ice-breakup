cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\ERA\');
load('temperature_output_2000-2018_May15_4cells.mat');
min_breakup = min(complete_dates,[],1);
max_breakup = max(complete_dates,[],1);
for t = 1:length(communities)
    dates = complete_dates(:,t);
    %get temperature data
    for k = 1:19
        temp_ts = temperature_output(k).temp(:,t);
            start_val = round(min_breakup(t))-5;
            end_val = start_val - 35;
            testval = cumsum(temp_ts(end_val:start_val));
            dd_breakup(k,1) = testval(end);
    end
    %dd_breakup = dd_breakup - nanmean(dd_breakup);
    %dates = dates - nanmean(dates);
     complete_dd(:,t) = dd_breakup;
    dd_breakup(isnan(dates) == 1) = [];
    dates(isnan(dates) == 1) = [];
    pp = polyfit(dd_breakup,dates,1);
    [r,p] = corrcoef(dates,dd_breakup);
    f = fit(dd_breakup,dates,'poly1');
    x = min(dd_breakup)-3:max(dd_breakup)+3;
    y = x*pp(1)+pp(2);
    ci = predint(f,x,0.95, 'functional','off');
    
    figure(2)
    co = figure_order_index(t);
    if co > 5
        co = co+1;
    end
    if co > 23
        co = co+1;
    end
    subplot(5,6,co)
    hold off
    h1 = ciplot(ci(:,1),ci(:,2),x,[0.8 0.8 0.8]);
    hold on
    h2 = plot(x,y,'k-','LineWidth',1.5);
    h3 = scatter(dd_breakup,dates,40,[0.2 0.4 0.7],'Filled');
    xlabel('DD (°C)');
    ylabel('Day of Breakup');
    if p(2) < 0.05
        title(communities_names{t});
    else
        title([communities_names{t} '*'])
    end
    axis([min(dd_breakup)-3 max(dd_breakup)+3 min(dates)-3 max(dates)+3]);
    box on
    set(gca,'FontSize',10);
    
    
    
    output_all(figure_order_index(t),1) = r(2);
    output_all(figure_order_index(t),2) = r(2)*r(2);
    output_all(figure_order_index(t),3) = p(2);
    output_all(figure_order_index(t),4) = pp(1);
    output_all(figure_order_index(t),5) = pp(2);
    output_all(figure_order_index(t),6) = 40;
    output_all(figure_order_index(t),7) = 1;
    output_all(t,8) = round(min_breakup(t))-40;
    output_all(t,9) = round(min_breakup(t));
    output_all(figure_order_index(t),10) = 40;
end
legend([h3, h2, h1],{'Observations','Regression Line','Uncertainty'});
clear out_r complete_r
