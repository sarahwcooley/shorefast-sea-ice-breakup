

for t = 1:length(communities)
    tic
    %xcoord = xcoords(t,:);
    %ycoord = ycoords(t,:);
    tile_folder = ['\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS\' tiles{t} '\'];
    output_folder = [tile_folder '\breakup_results\' communities{t}];
    mkdir(output_folder);
    %mask_folder = [tile_folder '\masks'];
    %cd(mask_folder);
    %mask_name = [communities{t} '_mask.tif'];
    %mask = imread(mask_name,'PixelRegion',{xcoord,ycoord});
    %[mask_full,R] = geotiffread(mask_name);
    %info = geotiffinfo(mask_name);

for p = 1:19
    year = 1999+p;
    %water_thresh = 800;
    %ice_thresh = 5500;
    %[output] = run_classification(mask,tile_folder,year,xcoord,ycoord);
    
     cd([tile_folder num2str(year)]);
     output_name = [communities{t} '_breakup_dates_Nov1_75.mat'];
     load(output_name)
%     if t == 22 || t == 27
%     output_name = ['Rankin_Inlet_breakup_dates_Feb28.mat'];
%     end
%     
%     load(output_name)
%     for i = 1:length(output)
%         output_ed(i).doy = output(i).doy;
%         output_ed(i).cloudy_strong = output(i).cloudy_strong(all_ids(t,:));
%         output_ed(i).ice_strong = output(i).ice_strong(all_ids(t,:));
%         output_ed(i).water_strong = output(i).water_strong(all_ids(t,:));
%         output_ed(i).mixed_strong = output(i).mixed_strong(all_ids(t,:));
%     end
    [breakup_dates] = run_breakup_date_detection_with_error_oct31(output_ed,tile_folder,output_folder,year);
    cd([tile_folder num2str(year)]);
    output_name = [communities{t} '_breakup_dates_Nov1_90.mat'];
    save(output_name,'breakup_dates','output_ed');
    clear breakup_dates output_ed
    disp(['Finished ' communities{t} ' ' num2str(year)])
end
    toc

end



