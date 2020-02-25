%Organize AWS data downloaded from Greenland. Note this script is just for
%Uummannaq, but numbers can be changed for other Greenland communities

%load ERA results to get start and end days
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS');
load('complete_output.mat');
output = output_all;



main_folder = '\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\AWS\';
number_points = zeros(28,1);

%load Canada AWS data to put into same format 
cd(main_folder)
load('output_aws_2000-2018.mat');

for i = 1 %:length(folders)
    cd(main_folder);
    cd('greenland\Uummannaq\');
    station_id = 4213;
    t = 3; 
    start_val = output(t,8);
    end_val = output(t,9);
    
    %read in temperature data
    filename = ['temperature_data_' num2str(station_id) '_Mar18.mat'];
    load(filename);
    
    %read in data by year (for 2000-2018)
    years = 2000:2018;
    days = 1:36;
    count = 1;
    for k = 1:19
        if temp_output(k+21).data_exist == 1
        temp_ts = temp_output(k+21).temp;
        count_ts = temp_output(k+21).temp_count;
        count_val = count_ts(start_val:end_val);
        %only use if sum (count_val >= 22) >= 35
        count_val(isnan(count_val) == 1) = 0;
        if sum(count_val >= 22) >= 31
            temp_val = temp_ts(start_val:end_val);
            %interpolate over missing values
            temp_val(count_val < 22) = [];
            day_val = days;
            day_val(count_val < 22) = [];
            day_val(isnan(temp_val) == 1) = [];
            temp_val(isnan(temp_val) == 1) = [];
            if length(temp_val) < 36
                temp_out = interp1(day_val,temp_val,days,'linear');
            else
                temp_out = temp_val;
            end
            output_dd(count,1) = years(k);
            output_dd(count,2) = nanmean(temp_out);
            output_dd(count,3) = station_id;
            count = count + 1;
        end
        end
    end
    if count > 1
    [l,w] = size(output_dd);
    output_aws(t).community = 'Uummannaq';
    n = number_points(t,1)+1;
    nl = l+number_points(t,1);
    output_aws(t).temp_dd(n:nl,:) = output_dd;
    number_points(t,1) = nl;
    output_aws(t).number_points = nl;
    clear output_dd
    end
end

cd(main_folder)
save('output_aws_2000-2018.mat','output_aws');
                
