%Classifies MODIS imagery and detects shorefast ice breakup timing
%Requires (1) precreated land/water masks that have been labeled into 5x5 km
%grids surrounding each community, (2) list of communities and (3) x and y
%coordinates of the mask area to read in (i.e. the area surrounding the
%community, so you do not have to read in the entire image


for t = 1:length(communities) %loop through all communities
    tic
    xcoord = xcoords(t,:); %x and y coordinates of bounding box to read in
    ycoord = ycoords(t,:);
    
    tile_folder = ['\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS\' tiles{t} '\']; 
    output_folder = [tile_folder '\breakup_results\' communities{t}];
    mkdir(output_folder);
    
    %read in mask
    mask_folder = [tile_folder '\masks'];
    cd(mask_folder);
    mask_name = [communities{t} '_mask.tif'];
    mask = imread(mask_name,'PixelRegion',{xcoord,ycoord});


for p = 1:19
    year = 1999+p;
 
    %run classification
    [output] = run_classification(mask,tile_folder,year,xcoord,ycoord);
 
    %run breakup data detection
    [breakup_dates] = run_breakup_date_detection_with_error(output,tile_folder,output_folder,year);
    
    %save results
    cd([tile_folder num2str(year)]);
    output_name = [communities{t} '_breakup_dates.mat'];
    save(output_name,'breakup_dates','output');
    clear breakup_dates output
    disp(['Finished ' communities{t} ' ' num2str(year)])
end
    toc

end



