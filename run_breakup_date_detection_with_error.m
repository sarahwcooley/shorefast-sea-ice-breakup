%Function for detecting breakup date

function [breakup_dates] = run_breakup_date_detection_with_error(output,tile_folder,output_folder,year)


%Breakup thresholds
mean_thresh = 50;
max_thresh = 90;
min_thresh = 10;
num_days = 5;

    image_folder =  [tile_folder num2str(year) '\band_2'];
    cd(image_folder)
    %load data
  
    clear doy_act ice_strong water_strong cloud_strong mixed_strong
for i = 1:length(output)
    
    ice_strong(:,i) = output(i).ice_strong;
    water_strong(:,i) = output(i).water_strong;
    cloud_strong(:,i) = output(i).cloudy_strong;
    mixed_strong(:,i) = output(i).mixed_strong;
    doy_act(i,1) = output(i).doy;
end

for i = 1:length(water_strong)
    water = water_strong(i,:);
    cloud = cloud_strong(i,:);
    mixed = mixed_strong(i,:);
    ice = ice_strong(i,:);
    doy = doy_act;
    water(cloud >= 50) = [];
    doy(cloud >= 50) = [];
    ice(cloud >= 50) = [];
    mixed(cloud >= 50) = [];
    cloud(cloud >= 50) = [];
    
%STEP 1: REMOVE OUTLIERS
   
[water_flt,~] = hampel(water,5,3);
[ice_flt,~] = hampel(ice,5,3);
water_flt = medfilt1(water_flt,5,'truncate');
ice_flt = medfilt1(ice_flt,5,'truncate');

%STEP 2: CALCULATE TYPE

freezup = NaN;
pre_freezup = NaN;
post_freezup = NaN;
breakup = NaN;
pre_breakup = NaN;
post_breakup = NaN;


if isempty(ice_flt) == 0 && isempty(water_flt) == 0

if length(water_flt) >= 5

per_test = mean(water_flt(1:5));
if per_test > 10
    type = 1; %starts with open water
else
    type = 0; % starts with ice
end

if sum(ice_flt > 90) > 3 && sum(water_flt > 90) > 3


%STEP 3: If starts with open water, calculate freezup date
if type == 1
[freezup,~] = calculate_breakup_date_with_error(ice_flt,doy,num_days,mean_thresh,max_thresh,min_thresh,1);
end

%STEP 4: calculate breakup date
if type == 1
    ind_start = find(doy == post_freezup);
else
    ind_start = 1;
end

[breakup,uncertainty] = calculate_breakup_date_with_error(water_flt,doy,num_days,mean_thresh,max_thresh,min_thresh,ind_start);

else
    if sum(ice_flt > 90) <= 3
        breakup = 1; %never froze up 
        uncertainty = 1;
     
    end
    if sum(water_flt > 90) <= 3
        breakup = 2; %never broke up 
        uncertainty = 2;
    end

end



end
end


breakup_dates(i).tile_id = i;
breakup_dates(i).freeze_date = freezup;
breakup_dates(i).breakup_date = breakup;
breakup_dates(i).breakup_uncertainty = uncertainty;



end %end loop through pixels
cd(output_folder)

end














