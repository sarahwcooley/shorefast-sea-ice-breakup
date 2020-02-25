%Function for classifying MODIS data into ice/water and calculating percent
%water/ice/cloud for 5x5km grid cells


function [output] = run_classification(mask,tile_folder,year,xcoord,ycoord)
    
    %define folders
    image_folder = [tile_folder num2str(year) '\band_2'];
    cloud_folder = [tile_folder num2str(year) '\band_state'];

    %define thresholds
    water_thresh = 1000; 
    ice_thresh = 5500;
    
    
    %identify missing files
    missing_files = zeros(180,2);
    count = 1;
    for i = 1:180
    if 60 + i < 100
    wc = ['*' num2str(year) '0' num2str(60 + i) '*.tif'];
    else
       wc = ['*' num2str(year) num2str(60 + i) '*.tif'];
    end
    
    
    %read in image
    cd(image_folder);
    filenames = dir(wc);
    if isempty(filenames) == 0
    image = imread(filenames(1).name,'PixelRegion',{xcoord,ycoord});
    else
        missing_files(i,1) = 2000060 + i;
    end
    
    
    %read in cloud mask
    cd(cloud_folder);
    filenames = dir(wc);
    if isempty(filenames) == 0
    cloud = imread(filenames(1).name,'PixelRegion',{xcoord,ycoord});
    else
        missing_files(i,2) = 60 + i;
    end
    
    if missing_files(i,1) == 0 && missing_files(i,2) == 0
        
    
        %create cloud mask
        bit0 = bitget(cloud,1);
        bit1 = bitget(cloud,2);
      

        cloud_mask_strong = zeros(size(cloud));
        cloud_mask_strong(bit0 == 0 & bit1 == 1) = 1;
        cloud_mask_strong(bit0 == 1 & bit1 == 0) = 1;
             
        %classify image
        classified = image;
        classified(image <= water_thresh) = 1; %water
        classified(image > water_thresh & image < ice_thresh) = 2; %mixed
        classified(image >= ice_thresh) = 3; %ice
        classified_s = classified;
        classified_s(cloud_mask_strong == 1) = 100;
        classified_s(image == 0) = 100; 
        
        %calculate statistics for each 5x5km grid cell
        stats_s = regionprops(mask,classified_s,'PixelValues');
        output(count).doy = 60 + i;
        for k = 1:length(stats_s)
            val_strong = stats_s(k).PixelValues;
            od(k,1) = 100*sum(val_strong == 100)/length(val_strong);
            od(k,2) = 100*sum(val_strong == 3)/sum(val_strong < 100);
            od(k,3) = 100*sum(val_strong == 1)/sum(val_strong < 100);
            od(k,4) = 100*sum(val_strong == 2)/sum(val_strong < 100);
        end
        
        %save output
        output(count).cloudy_strong = od(:,1);
        output(count).ice_strong = od(:,2);
        output(count).water_strong = od(:,3);
        output(count).mixed_strong = od(:,4);
        count = count + 1;
        clear od
        
    end

    disp(['Finished ' num2str(year) ' ' num2str(60 + i) ' ']);

    end

end