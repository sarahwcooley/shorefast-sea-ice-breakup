%Read and organize ERA-Interim Temperature data for four grid cells
%surrounding each community
%Requires latlons which is a matrix containing latitude and longitude
%coordinates for all communities


cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\ERA\T2_NetCDF_2019');
years = 2000:2018;

for i =  1:length(years)
    year = years(i);
    %read in nc data for year
    if year < 2011
        files = dir(['*' num2str(years(i)) '.nc']);
         temperature = ncread(files(1).name,'2T_GDS4_SFC');
        lat = ncread(files(1).name,'g4_lat_1');
        lon = ncread(files(1).name,'g4_lon_2');
        
    else
        files = dir(['*' num2str(years(i)) '*.nc']);
        lat = ncread(files(1).name,'g4_lat_1');
        lon = ncread(files(1).name,'g4_lon_2');
          for k = 1:length(files)
              temptemp = ncread(files(k).name,'2T_GDS4_SFC');
              if k > 1
                  temperature = cat(3,temperature,temptemp);
              else
                  temperature = temptemp;
              end
          end
    end

    %fix lat lon
    for k = 1:length(lon)
        if lon(k) > 180
            lon(k) = lon(k) -360;
        end
    end
    
    %get time series for each community
    for p = 1:length(latlons)
        latlon = latlons(p,:);
        

        diflat = abs(lat - latlon(1));
        diflon = abs(lon - latlon(2));
        [~,indlat1] = min(diflat);
        [~,indlon1] = min(diflon);
        diflat(indlat1) = 100;
        diflon(indlon1) = 100;
        [~,indlat2] = min(diflat);
        [~,indlon2] = min(diflon);
        if indlat1 < indlat2 
        lat1 = indlat1; lat2 = indlat2; 
        else
        lat1 = indlat2; lat2 = indlat1;
        end
        if indlon1 < indlon2 
        lon1 = indlon1; lon2 = indlon2; 
        else
        lon1 = indlon2; lon2 = indlon1;
        end
        temp_ts_raw = temperature(lon1:lon2,lat1:lat2,:);

         
        
        
        %average time series
        if mod(years(i),4) == 0
            day_max = 366;
        else
            day_max = 365;
        end
        
        day_max = 120;
        
        temp_ts = zeros(day_max,1);
        for k = 1:day_max
            temp_ts(k,1) = mean(mean(mean(temp_ts_raw(:,:,4*(k-1)+1:4*k))))-273.15;
        end
    
        %create pdd time series
        temp_pdd = zeros(size(temp_ts));
        temp_pdd(temp_ts > 0) = temp_ts(temp_ts > 0);
        pdd_ts = cumsum(temp_pdd);
    
        temperature_output(i).year = years(i);
        temperature_output(i).temp(:,p) = temp_ts;
        temperature_output(i).pdd_ts(:,p) = pdd_ts;
    end
    display(['Finished ' num2str(year)]);
end

save('temperature_output_2000-2018_May15_4cells.mat','temperature_output');
    
 
