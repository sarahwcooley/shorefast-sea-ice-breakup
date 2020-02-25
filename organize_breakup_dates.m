%Organizes breakup dates
%Requires (1) com_ids, i.e. ids of grid cells to be analyzed for each
%community (located within 20 km of community)


for t = 1:length(communities)
 
    tile_folder = ['\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS\' tiles{t} '\'];
   
    in_name = [communities{t} '_breakup_dates.mat'];

    %load breakup dates
    for k = 1:19
    year = 1999 + k;
    image_folder =  [tile_folder num2str(year)];
    cd(image_folder)
    load(in_name);
        for i = 1:length(breakup_dates)
        complete_breakup_dates(i,k) = breakup_dates(i).breakup_date;
        end
    end
    
    %save for all grid cells
    cd(tile_folder);
    output_name = [communities{t} '_complete_breakup_Nov1_80.mat'];
    save(output_name,'complete_breakup_dates');
    disp(['Finished ' communities{t}])
    
    
    %grid cells to be analyzed for each community
    complete_breakup_dates = complete_breakup_dates(com_ids(t,:),:);
    complete_breakup_dates(complete_breakup_dates == 2) = NaN;
    complete_breakup_dates(complete_breakup_dates == 1) = NaN;
    bdates = transpose(nanmean(complete_breakup_dates));
    complete_dates(:,t) = bdates;
    clear complete_breakup_dates 
 
    
end
 
    
    