%Reads in CMIP5 climate data for three RCP scenarios and plots future
%projections. CMIP5 surface air temperature data has been previously downloaded for a 2x2 degree grid cell around each community
%Requires (1) list of models to analyze (models) and (2) list of the region for
%each community, with uncorrelated communities removed (regions1) and
%(3)listof names for each region (region_names)


%load normalized ERA results to enable forecasting
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\MODIS');
load('complete_slopes_normalized.mat'); %note this should be a normalized version of the complete slopes 'output' variable, 
%can be created using "correlations_with_ERA_and_plots.m" if you ensure the
%breakup dates and temperature are normalized to 2006-2018

for i = 1:length(communities)
    
    file_folder = ['\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\CMIP5\diag_timeseries_' communities{i} '\'];
    cd(file_folder)
    cd('tas')
    
    
    %read in rcp26 files
    count = 1;
    for j = 1:length(models)
         files = dir(['*' models{j} '*rcp85*.nc']);
         tas = ncread(files(1).name,'tas');
         time = ncread(files(1).name,'time');
         time = time - 2*10^4;
         if length(time)> 34300
         %make sure length of variable is correct
         if time(1) == 440.5
             if length(time) >= 34310
                 for p = 1:94
                   temp(p).ts = tas((p-1)*365+1:p*365)-273.15;
                 end
             elseif length(time) == 34309
                 for p = 1:94
                     if p ~= 94
                        temp(p).ts  = tas((p-1)*365+1:p*365)-273.15;
                     else
                       temp(p).ts  = tas((p-1)*365+1:end)-273.15;
                     end
                 end
             end
              model_count(count,1) = j;
              
         %calculate temperature values
         for p = 1:94
             t = temp(p).ts;
             tval = mean(t(output_all_n(i,8):output_all_n(i,9)));
             dd(p,1) = tval;
             maatr(p,1) = mean(t);
         end
         complete_dd85(:,count) = dd;
         complete_maat85(:,count) = maatr;
         count = count + 1;
         clear dd temp maatr
         end
         end
    end
   
     %read in rcp26 files
    count = 1;
    for j = 1:8
         files = dir(['*' valid_models{j} '*rcp45*.nc']);
         tas = ncread(files(1).name,'tas');
         time = ncread(files(1).name,'time');
         time = time - 2*10^4;
         if length(time)> 34300
         %make sure length of variable is correct
         if time(1) == 440.5
             if length(time) >= 34310
                 for p = 1:94
                   temp(p).ts = tas((p-1)*365+1:p*365)-273.15;
                 end
             elseif length(time) == 34309
                 for p = 1:94
                     if p ~= 94
                        temp(p).ts  = tas((p-1)*365+1:p*365)-273.15;
                     else
                       temp(p).ts  = tas((p-1)*365+1:end)-273.15;
                     end
                 end
             end
         
         %calculate temperature values
         for p = 1:94
             t = temp(p).ts;
             tval = mean(t(output_all_n(i,8):output_all_n(i,9)));
             dd(p,1) = tval;
             maatr(p,1) = mean(t);
         end
         complete_dd45(:,count) = dd;
         complete_maat45(:,count) = maatr;
         count = count + 1;
         clear dd temp maatr
         end
         end
    end
    
       %read in rcp26 files
    count = 1;
    for j = 1:8
         files = dir(['*' valid_models{j} '*rcp26*.nc']);
         tas = ncread(files(1).name,'tas');
         time = ncread(files(1).name,'time');
         time = time - 2*10^4;
         if length(time)> 34300
         %make sure length of variable is correct
         if time(1) == 440.5
             if length(time) >= 34310
                 for p = 1:94
                   temp(p).ts = tas((p-1)*365+1:p*365)-273.15;
                 end
             elseif length(time) == 34309
                 for p = 1:94
                     if p ~= 94
                        temp(p).ts  = tas((p-1)*365+1:p*365)-273.15;
                     else
                       temp(p).ts  = tas((p-1)*365+1:end)-273.15;
                     end
                 end
             end
         
         %calculate temperature values
         for p = 1:94
             t = temp(p).ts;
             tval = mean(t(output_all_n(i,8):output_all_n(i,9)));
             dd(p,1) = tval;
             maatr(p,1) = mean(t);
         end
         complete_dd26(:,count) = dd;
         complete_maat26(:,count) = maatr;
         count = count + 1;
         clear dd temp maatr
         end
         end
    end
    
    
    
    %calculate days earlier 2100
    [l,w] = size(complete_dd85);
    for p = 1:w
    comp_dd = complete_dd85(:,p);
    complete_dd85_norm(:,p) = (comp_dd - mean(comp_dd(1:13)));
    filtered = medfilt1(complete_dd85_norm(:,p),10,'truncate');
    change_rcp85(p,1) = output_all_n(i,5) + mean(filtered(end-10:end))*output_all_n(i,4);
    dd_rcp85(p,1) = mean(filtered(end-10:end));

    end
    for p = 1:94
    comp_dd = complete_dd85_norm(p,:);
    complete_dd85_25th(p,1) = prctile(comp_dd,25);
    complete_dd85_75th(p,1) = prctile(comp_dd,75);
    end

    comp = mean(complete_dd85_norm,2);
    comp_filtered = medfilt1(comp,10,'truncate');
    complete_maat85_all(:,i) = mean(complete_maat85(end-10:end,:));
    complete_maat85_all_start(:,i) = mean(complete_maat85(1:13,:));
    complete_dd85_norm_all(:,i) = comp;
    complete_dd85_norm_filtered_all(:,i) = comp_filtered;
    complete_dd85_25th_all(:,i) = complete_dd85_25th;
    complete_dd85_75th_all(:,i) = complete_dd85_75th;
    
    cmip5_results(i).community = communities{i};
    change2100 = output_all_n(i,5) + mean(comp_filtered(end-10:end))*output_all_n(i,4);
    cmip5_results(i).change_rcp85 = change2100;
    cmip5_results(i).change_all_rcp85 = change_rcp85;
    cmip5_results(i).median_rcp85 = median(change_rcp85);
    cmip5_results(i).mean_rcp85 = mean(change_rcp85);
    cmip5_results(i).max_rcp85 = max(change_rcp85);
    cmip5_results(i).min_rcp85 = min(change_rcp85);
    [~,ind] = min(change_rcp85);
    cmip5_results(i).min_ind = ind;
    [~,ind] = max(change_rcp85);
    cmip5_results(i).max_ind = ind;
    cmip5_results(i).dd_rcp85 = dd_rcp85;
    cmip5_results(i).mean_dd_rcp85 = mean(dd_rcp85);
    cmip5_results(i).std_dd_rcp85 = std(dd_rcp85);
    
     %calculate days earlier 2100 rcp 2.6
    [l,w] = size(complete_dd45);
    for p = 1:w
    comp_dd = complete_dd45(:,p);
    complete_dd45_norm(:,p) = (comp_dd - mean(comp_dd(1:13)));
    filtered = medfilt1(complete_dd45_norm(:,p),10,'truncate');
    change_rcp45(p,1) = output_all_n(i,5) + mean(filtered(end-10:end))*output_all_n(i,4);
    dd_rcp45(p,1) = mean(filtered(end-10:end));
    end
    for p = 1:94
    comp_dd = complete_dd45_norm(p,:);
    complete_dd45_25th(p,1) = prctile(comp_dd,25);
    complete_dd45_75th(p,1) = prctile(comp_dd,75);
    end

    comp = mean(complete_dd45_norm,2);
    comp_filtered = medfilt1(comp,10,'truncate');
    
    complete_dd45_norm_all(:,i) = comp;
    complete_dd45_norm_filtered_all(:,i) = comp_filtered;
    complete_dd45_25th_all(:,i) = complete_dd45_25th;
    complete_dd45_75th_all(:,i) = complete_dd45_75th;
    
    change2100 = output_all_n(i,3) + mean(comp_filtered(end-10:end))*output_all_n(i,4);
    cmip5_results(i).change_rcp45 = change2100;
    cmip5_results(i).change_all_rcp45 = change_rcp45;
    cmip5_results(i).median_rcp45 = median(change_rcp45);
    cmip5_results(i).mean_rcp45 = mean(change_rcp45);
    cmip5_results(i).max_rcp45 = max(change_rcp45);
    cmip5_results(i).min_rcp45 = min(change_rcp45);
    cmip5_results(i).models = model_count;
    %clear change_rcp26 change_rcp85 complete_dd26 complete_dd85 model_count
    
    
    
    
     %calculate days earlier 2100 rcp 2.6
    [l,w] = size(complete_dd26);
    for p = 1:w
    comp_dd = complete_dd26(:,p);
    complete_dd26_norm(:,p) = (comp_dd - mean(comp_dd(1:13)));
    filtered = medfilt1(complete_dd26_norm(:,p),10,'truncate');
    change_rcp26(p,1) = output_all_n(i,5) + mean(filtered(end-10:end))*output_all_n(i,4);
    dd_rcp26(p,1) = mean(filtered(end-10:end));
    end
    for p = 1:94
    comp_dd = complete_dd26_norm(p,:);
    complete_dd26_25th(p,1) = prctile(comp_dd,25);
    complete_dd26_75th(p,1) = prctile(comp_dd,75);
    end

    comp = mean(complete_dd26_norm,2);
    comp_filtered = medfilt1(comp,10,'truncate');
    
    complete_dd26_norm_all(:,i) = comp;
    complete_dd26_norm_filtered_all(:,i) = comp_filtered;
    complete_dd26_25th_all(:,i) = complete_dd26_25th;
    complete_dd26_75th_all(:,i) = complete_dd26_75th;
    
    change2100 = output_all_n(i,3) + mean(comp_filtered(end-10:end))*output_all_n(i,4);
    cmip5_results(i).change_rcp26 = change2100;
    cmip5_results(i).change_all_rcp26 = change_rcp26;
    cmip5_results(i).median_rcp26 = median(change_rcp26);
    cmip5_results(i).mean_rcp26 = mean(change_rcp26);
    cmip5_results(i).max_rcp26 = max(change_rcp26);
    cmip5_results(i).min_rcp26 = min(change_rcp26);
    cmip5_results(i).models = model_count;
    %clear change_rcp26 change_rcp85 complete_dd26 complete_dd85 model_count
    
    disp(['Finished ' communities{i}]);
end

for i = 1:length(cmip5_results)
    rcp_output(figure_order_index(i),1) = cmip5_results(i).change_rcp85;
    rcp_output(figure_order_index(i),2) = cmip5_results(i).change_rcp45;
    rcp_output(figure_order_index(i),3) = cmip5_results(i).change_rcp26;
end
cd('\\files.brown.edu\research\IBES_RyanLab\Shared\Shorefast_Ice_Project\CMIP5\');
save('cmip5_results.mat','cmip5_results');




%Plot by region

for j = 1:5
for i = 1:3
    if i == 1
        c = complete_dd26_norm_all;
        c_f = complete_dd26_norm_filtered_all;
        c_75 = complete_dd26_75th_all;
        c_25 = complete_dd26_25th_all;
    end
    if i == 2
        c = complete_dd45_norm_all;
        c_f = complete_dd45_norm_filtered_all;
        c_75 = complete_dd45_75th_all;
        c_25 = complete_dd45_25th_all;
    end
    if i == 3
        c = complete_dd85_norm_all;
        c_f = complete_dd85_norm_filtered_all;
        c_75 = complete_dd85_75th_all;
        c_25 = complete_dd85_25th_all;
    end
    
    %remove uncorrelated
    c(:,output_all_n(:,3) > 0.05) = [];
    c_f(:,output_all_n(:,3) > 0.05) = [];
    c_75(:,output_all_n(:,3) > 0.05) = [];
    c_25(:,output_all_n(:,3) > 0.05) = [];
    ind = find(regions1 == j);
    c = c(:,ind);
    c_f = c_f(:,ind);
    c_75 = c_75(:,ind);
    c_25 = c_25(:,ind);
    
    cmapc = lines(5);
    cmap = [cmapc(3,:); cmapc(5,:); cmapc(1,:)];
    
    %plot degree days
    years = 2006:2099;
    subplot(2,5,j);
    h1 = ciplot(medfilt1(mean(c_25,2),10,'truncate'),medfilt1(mean(c_75,2),10,'truncate'),years,cmap(i,:));
    alpha(h1,0.4);
    hold on
    plot(years,mean(c_f,2),'-','Color',cmap(i,:),'LineWidth',1.5);
    ylabel('\Delta Mean Spring T (°C)');
        axis([ 2005 2100 -2 10]);
    grid on
    title(region_names{j});
    
    %calculate breakup timing
    oa_reg_s = oa(regions1 == j,4);
    oa_reg_z = oa(regions1 == j,5);
    for p = 1:length(oa_reg_s)
        c_b(:,p) = c(:,p).*oa_reg_s(p) + oa_reg_z(p);
        c_fb(:,p) = c_f(:,p).*oa_reg_s(p) + oa_reg_z(p);
        c_25b(:,p) = c_25(:,p).*oa_reg_s(p) + oa_reg_z(p);
        c_75b(:,p) = c_75(:,p).*oa_reg_s(p) + oa_reg_z(p);
    end
    
    
    %plot breakup timing
    subplot(2,5,j+5);
    
    h1 = ciplot(medfilt1(mean(c_25b,2),10,'truncate'),medfilt1(mean(c_75b,2),10,'truncate'),years,cmap(i,:));
    alpha(h1,0.4);
    hold on
    plot(years,mean(c_fb,2),'-','Color',cmap(i,:),'LineWidth',1.5);
    ylabel('Projected \Delta in Breakup (days)');
    clear c_b c_fb c_25b c_75b
    axis([ 2005 2100 -50 5]);
    grid on
end
end
   
    
    
