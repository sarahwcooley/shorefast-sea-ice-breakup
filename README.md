# shorefast-sea-ice-breakup
Matlab workflow to classify MODIS band 2 satellite imagery, detect the timing of shorefast ice breakup, compare it to springtime air temperatures and project changes in breakup into the future. These scripts were used for the shorefast ice breakup research described in a forthcoming paper and a full description of the method and data sources can be found therein. 

All scripts (c) Sarah Cooley 2020. Please contact me at sarah_cooley (at) brown (dot) edu with any questions or for further information. Any use of these scripts should credit Sarah Cooley and cite paper, forthcoming. 

Please note this workflow first requires the creation of land/water MODIS masks where the ocean is gridded into 5x5km grid cells.

# Classification Workflow Scripts
1.	complete_run_classification_and_breakup.m – runs the complete MODIS image classification and breakup timing detection
2.	run_classification – function which classifies MODIS imagery into ice/mixed/water/cloud
3.	run_breakup_date_detection_with_error – function which runs the breakup detection method. Thresholds for breakup timing can be changed within this function
4.	calculate_breakup_date_with_error – calculates the breakup date based on time series of percent water for each 5x5km grid cell
5.	organize_breakup_date – after complete_run_classification_and_breakup, this short script reorganizes all of the breakup data to be used in the rest of the analysis

# Temperature Analysis Scripts
1.	read_era_temperature_data_multiple_grid_cells.m – reads in 6-hourly ERA-Interim temperature data and processes to daily data for the four grid cells surrounding each community
2.	correlations_with_ERA_and_plots.m – compares breakup timing to springtime ERA temperature data and plots the results
3.	organize_AWS_data.m – reads in historical automated weather station data from the Canadian Weather Archive and processes it to mean springtime air temperature for each community
4.	organize_AWS_data_greenland.m – same as above but for data from Greenland communities, which is in a different format to the Canadian data
5.	correlations_with_AWS_and_plots.m – compares breakup timing to springtime AWS temperature data and plots the results
6.	read_in_cmip5_data_and_project_into_future.m – reads in CMIP5 data from 8 CMIP5 models (which has been previously downloaded and processed for each community) and projects how breakup timing in each community will change in the future. Also creates plots of project change in springtime air temperature and corresponding change in breakup timing for each study region. 


