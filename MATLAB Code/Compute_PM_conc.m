% -------------------------------------------- %
% ------------- Compute_PM_conc -------------- %
% -------------------------------------------- %

% The following script accompanies the "Airport_PM" script and computes the
% production quantities of PM2.5 at 30 major US airports for each month 
% during the 2009 - 2019 period. These airports include:
% ATL | BOS | CLT | ORD | MDW | DAL | DFW | DEN | DTW | FLL | 
% IAH | HOU | LAS | LAX | MIA | MSP | JFK | LGA | EWR | OAK | 
% MCO | PHL | PHX | PDX | SLC | SAN | SFO | SEA | IAD | DCA |

% Importing the flight data datasheet
shts = sheetnames('Historic Flights.xlsx');
summary = readtable('Historic Flights.xlsx','Sheet',shts(1));

% Extracting the airport and city coordinates
coor_airp = summary{1:30,11:12};
coor_city = summary{1:30,14:15};

% Writing the file name corresponding to the month in question
for k = 1:12
    if k < 10
        m = ['0',num2str(k)];
    else
        m = num2str(k);
    end
    PM25file_month(k) = "V6GL02.02.CNNPM25.NA.2019"+m+"-2019"+m+".nc";
end

% Writing the file name for the years in question
for k = 1:11
    y = 2009+(k-1);
    year = num2str(y);
    PM25file_year(k) = "V6GL02.02.CNNPM25.NA."+year+"01-"+year+"12.nc";
end

% Writing the matrix where the PM2.5 concentration results will be stored
PM_conc = zeros(30,11,2); % Here, the dimensions correspond to the 30 
% airports, 11 years, and 2 comparison cases (airport and reference city)

PM_conc2019 = zeros(30,12,2); % The difference here is that this matrix is 
% purely for 2019 levels, comparing each month separately.

% -------------------------------------------- %
% Modified code from: Atmospheric Composition Analysis Group at the
% Washington University in St. Louis, Shen et al. (2024)
% -------------------------------------------- %

% Buffer radius around the reference city and airport, in degrees
R = 0.015;

% Iterating through all 30 airports
for k = 1:30

    % Airport and Reference City coordinates
    lat_airport = coor_airp(k,1);
    lon_airport = coor_airp(k,2);
    lat_city = coor_city(k,1);
    lon_city = coor_city(k,2);
    coor = [lat_airport,lon_airport;lat_city,lon_city];

    % Loading the coordinates
    tLAT = double(ncread(sprintf(PM25file_year(1),1,1), "lat"));
    tLON = double(ncread(sprintf(PM25file_year(1),1,1), "lon"));
    % create grid of coordinates
    [tLONg, tLATg] = meshgrid(tLON,tLAT);

    % Identifying pixels within radius for each location
    CityPixels = cell(2,1);
    for Ci = 1:2
        % calculate distance between each grid cell and location
        d = ((tLATg - coor(Ci,1)).^2 + (tLONg - coor(Ci,2)).^2).^0.5;
        % Identify and store pixels within given radius
        CityPixels{Ci} = uint64(find(d <= R));
    end
    
    % Iterating through the 11 years
    for year = 1:11

        % Loading PM2.5 concentrations
        tPM25 = double(ncread(sprintf(PM25file_year(year),1,1),"PM25"));

        % % Extracting the PM2.5 concentrations from the locations in question
        PM_conc(k,year,1) = nanmean(tPM25(CityPixels{1}));
        PM_conc(k,year,2) = nanmean(tPM25(CityPixels{2}));

    end

    % Iterating through the 12 months of 2019
    for month = 1:12
        
        % Loading PM2.5 concentrations
        tPM25 = double(ncread(sprintf(PM25file_month(month),1,1),"PM25"));
        
        % % Extracting the PM2.5 concentrations from the locations in question
        PM_conc2019(k,month,1) = nanmean(tPM25(CityPixels{1}));
        PM_conc2019(k,month,2) = nanmean(tPM25(CityPixels{2}));
        
    end

end