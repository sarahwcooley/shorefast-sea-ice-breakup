%Calculates correlations with ERA springtime air temperature and plots the
%results

%load AWS data
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\AWS\');
load('output_AWS_2000-2018.mat');

%load breakup dates
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS');
load('complete_dates_communities_nov1.mat');

%load ERA processed data
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS');
load('complete_dd_ERA.mat');

for t = 1:length(communities)
    
    if isempty(output_aws(t).temp_dd) == 0
        dates = complete_dates(:,t);
        era = complete_dd(:,t);
        aws_dd = output_aws(t).temp_dd;
        
        %create corrected aws time series
        years = 2000:2019;
        dd_years = zeros(19,1);
        for k = 1:19
            ind = find(aws_dd(:,1) == years(k));
            if isempty(ind) == 0
                temp = aws_dd(:,2);
                dd_years(k,1) = mean(temp(ind));
            else
                dd_years(k,1) = NaN;
            end
        end
        
        %calculate correlation with ERA
        era(isnan(dd_years) == 1) = [];
        dd_years2 = dd_years;
        dd_years2(isnan(dd_years) == 1) = [];
        [r,p] = corrcoef(era,dd_years2);
        output_aws(t).era_rsq = r(2)*r(2);
        output_aws(t).era_pval = p(2);
        output_aws(t).num_years = length(dd_years2);
        rmse = sqrt(mean((era - dd_years2).^2));
        output_aws(t).era_rmse = rmse;
        
        %calculate correlation with breakup
        dates(isnan(dd_years) == 1) = [];
        dd_years(isnan(dd_years) == 1) = [];
        dd_years(isnan(dates) == 1) = [];
        dates(isnan(dates) == 1) = [];
        [r,p] = corrcoef(dates,dd_years);
        output_aws(t).breakup_rsq = r(2)*r(2);
        output_aws(t).breakup_pval = p(2);
        pp = polyfit(dd_years,dates,1);
        output_aws(t).slope = pp(1);
        
        aws_info(t,1) = r(2)*r(2);
        aws_info(t,2) = p(2);
        aws_info(t,3) = pp(1);
        aws_info(t,4) = length(dd_years2);
        
        %get x max and x min for plotting results
        range_x = (max(dd_years) + min(dd_years))/2;
        range_check(t,1) = max(dd_years) - min(dd_years);
        x_min = range_x - 6;
        x_max = range_x + 6;
        range_y = (max(dates) + min(dates))/2;
        y_min = range_y - 40;
        y_max = range_y + 40;
        
        %calculate correlations
        pp = polyfit(dd_years,dates,1);
        [r,p] = corrcoef(dates,dd_years);
        f = fit(dd_years,dates,'poly1');
        x = x_min:x_max;
        y = x*pp(1)+pp(2);
        ci = predint(f,x,0.95, 'functional','off');
        
       
    
    figure(1)
    
    subplot(5,6,t)
    hold off
    h1 = ciplot(ci(:,1),ci(:,2),x,[0.8 0.8 0.8]);
    hold on
    if p(2) <= 0.054
        h2 = plot(x,y,'k-','LineWidth',1.5);
    else
        h2 = plot(x,y,'k--','LineWidth',1.5);
    end
    h3 = scatter(dd_years,dates,40,[0.4 0.7 0.4],'Filled');
    xlabel('Mean Spring T (°C)');
    ylabel('Breakup Date');
   
    if p(2) < 0.05
        title(communities_names{t});
    else
        if length(dd_years2) >= 10
        title([communities_names{t} '*'])
        else
        title([communities_names{t} '**'])
        end
    end
    axis([x_min x_max y_min y_max]);
    box on
    set(gca,'FontSize',10);
    
             
    end
end
legend([h3, h2, h1],{'Observations','Regression Line','Uncertainty'});



