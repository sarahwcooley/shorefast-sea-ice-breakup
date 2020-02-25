%Organize AWS data downloaded from Canada's Historical database

%load ERA results to get start and end days
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS');
load('complete_output.mat');
output = output_all;

main_folder = '\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\AWS\';
cd(main_folder);

file_list = readtable('Station_Inventory_Project_edited_communities.csv');
main_folder = '\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\AWS\canada';
cd(main_folder);
years = 1979:2018;
folders = table2array(file_list(:,1));
stations = table2array(file_list(:,4));
community_index = table2array(file_list(:,7));
number_points = zeros(28,1);

for i = 1:length(folders)
    cd(main_folder);
    cd(folders{i});
    station_id = num2str(stations(i));
    t = community_index(i);
    start_val = output_all(t,8); %start and end times for calculating springtime air temperature
    end_val = output(t,9);
       
    %read in temperature data
    filename = ['temperature_data_' station_id '_Mar18.mat'];
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
        
        %only use if at least 31 days have at least 22 hours of data
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
            output_dd(count,3) = stations(i);
            count = count + 1;
        end
        end
    end
    if count > 1
    [l,w] = size(output_dd);
    output_aws(t).community = communities{t};
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
                
                
