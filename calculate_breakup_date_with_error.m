%Calculates breakup date with uncertainty due to cloud cover


function [breakup,uncertainty] = calculate_breakup_date_with_error_nov(water,doy,num_days,mean_thresh,max_thresh,min_thresh,ind_start)
breakup_date = 0;
for p = ind_start:length(water) - num_days
    water_val = mean(water(p:p+num_days));
    if water_val > mean_thresh %if over a five-day period the mean water value is greater than 50%
        
        %find first day when fjord is 50% open water
        test_values = water(p:p+num_days);
        doy_values  = doy(p:p+num_days);
        ind = find(test_values > mean_thresh); %find first date when fjord is > 90% water
        breakup_date = doy_values(ind(1));
        if isempty(ind) == 0
        ind_date = find(doy == breakup_date);
        water_val_pre_breakup = water(ind_start:ind_date);
        doy_val_pre_breakup = doy(ind_start:ind_date);
        ind = find(water_val_pre_breakup <= min_thresh);
        if isempty(ind) == 0
        pre_breakup = doy_val_pre_breakup(ind(end)); 
        else
        pre_breakup =doy_val_pre_breakup(1);
        end
        water_val_post_breakup = water(ind_date:end);
        doy_val_post_breakup = doy(ind_date:end);
        ind = find(water_val_post_breakup >= max_thresh);
        if isempty(ind) == 0
        p_breakup = doy_val_post_breakup(ind(1));
        ind_check = find(doy == p_breakup);
        if ind_check > 1
        p_breakup_unc = doy(ind_check-1);
        else
        p_breakup_unc = p_breakup;
        end
        if length(water_val_post_breakup(ind(1):end)) > 5 %ensure average water percentage after breakup date is at least 80
            post_breakup_values = mean(water_val_post_breakup(ind(1)):water_val_post_breakup(ind(1)+4));
        else
            post_breakup_values = mean(water_val_post_breakup(ind(1)):water_val_post_breakup(end));
        end
        if post_breakup_values > 80
            break
        end
        else
        p_breakup = doy_val_post_breakup(end);
        p_breakup_unc = p_breakup;
        break
        end
        end
    end
end

if breakup_date > 0
breakup = (p_breakup + p_breakup_unc)/2;
uncertainty = p_breakup - p_breakup_unc;
else
breakup = NaN;
uncertainty = NaN;
end
end