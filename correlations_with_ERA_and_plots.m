%Calculates correlations with ERA springtime air temperature and plots the
%results

%load temperature data
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\ERA\');
load('temperature_output_2000-2018_May15_4cells.mat');

%load breakup dates
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS');
load('complete_dates_communities_nov1.mat');

%get max/min breakup date
min_breakup = min(complete_dates,[],1);
max_breakup = max(complete_dates,[],1);

for t = 1:length(communities)
    dates = complete_dates(:,t);
    
    %get temperature data
    for k = 1:19
        temp_ts = temperature_output(k).temp(:,t);
            start_val = round(min_breakup(t))-5;
            end_val = start_val - 35;
            testval = mean(temp_ts(end_val:start_val));
            dd_breakup(k,1) = testval;
    end
    
    %turn on to normalize over 18 year period
    %dd_breakup = dd_breakup - nanmean(dd_breakup);
    %dates = dates - nanmean(dates);
    %
    %turn on to normalize over 2006-2018 (overlap with CMIP5)
    %dd_breakup = dd_breakup - nanmean(dd_breakup(7:end));
    %dates = dates - nanmean(dates(7:end));
    
    complete_dd(:,t) = dd_breakup;
    dd_breakup(isnan(dates) == 1) = [];
    dates(isnan(dates) == 1) = [];
    
    %get x max and x min for plotting to ensure slopes are comparable
    range_x = (max(dd_breakup) + min(dd_breakup))/2;
    x_min = range_x - 6; %154;
    x_max = range_x + 6; %154;
    range_y = (max(dates) + min(dates))/2;
    y_min = range_y - 40;
    y_max = range_y + 40;
    
    
    %get correlation and slopes of line
    pp = polyfit(dd_breakup,dates,1);
    [r,p] = corrcoef(dates,dd_breakup);
    f = fit(dd_breakup,dates,'poly1');
    x = x_min:x_max;
    y = x*pp(1)+pp(2);
    ci = predint(f,x,0.95, 'functional','off');
    
    %plot
    figure(1)
    subplot(5,6,t)
    hold off
    h1 = ciplot(ci(:,1),ci(:,2),x,[0.8 0.8 0.8]);
    hold on
    if p (2) < 0.05
    h2 = plot(x,y,'k-','LineWidth',1.5);
    else
    h2 = plot(x,y,'k--','LineWidth',1.5);
    end
    h3 = scatter(dd_breakup,dates,40,[0.2 0.4 0.7],'Filled');
    xlabel('Mean Spring T (°C)');
    ylabel('Breakup Date');
    if p(2) < 0.05
        title(communities_names{t});
    else
        title([communities_names{t} '*'])
    end
    axis([x_min x_max y_min y_max]);
    box on
    set(gca,'FontSize',10);
    
    
    %save output
    output_all(t,1) = r(2); %r
    output_all(t,2) = r(2)*r(2); %r squared
    output_all(t,3) = p(2); % p value
    output_all(t,4) = pp(1); %sensitivity 
    output_all(t,5) = pp(2); %intercept
    output_all(t,6) = 40; %number of days prior to earliest breakup to start springtime period
    output_all(t,7) = 5; %number of days prior to earliest breakup to end springtime period
    output_all(t,8) = end_val; %day to start springtime period
    output_all(t,9) = start_val; %day to end springtime period
    output_all(t,10) = 35; %number of days
end
legend([h3, h2, h1],{'Observations','Regression Line','Uncertainty'});
clear out_r complete_r
save('complete_dd_ERA.mat','complete_dd');
save('complete_slopes.mat','output_all');
