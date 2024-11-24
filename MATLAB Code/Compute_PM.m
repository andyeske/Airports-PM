% -------------------------------------------- %
% ---------------- Compute_PM ---------------- %
% -------------------------------------------- %

% The following script accompanies the "Airport_PM" script and computes the
% production quantities of nvPM at 30 major US airports for each month 
% during the 2009 - 2019 period. These airports include:
% ATL | BOS | CLT | ORD | MDW | DAL | DFW | DEN | DTW | FLL | 
% IAH | HOU | LAS | LAX | MIA | MSP | JFK | LGA | EWR | OAK | 
% MCO | PHL | PHX | PDX | SLC | SAN | SFO | SEA | IAD | DCA |

% Importing the flight data datasheet
shts = sheetnames('Historic Flights.xlsx');
summary = readtable('Historic Flights.xlsx','Sheet',shts(1));

% Importing the engine datasheet
shts2 = sheetnames('edb-emissions-databank_v30__web_.xlsx');
PM_sheet = readtable('edb-emissions-databank_v30__web_.xlsx','Sheet',shts2(4));

% Extracting airports, aircraft and engine data from the "summary" sheet:
Airports  = summary{1:30,10};
Aircraft = summary{1:40,4};
Engines = summary{1:40,7};

% Creating the matrix that will contain the engine performance
% characteristics for the production of nvPM during each of the stages of
% flight dictated by the LTO cycle. Each column precisely represents the mg
% of nvPM produced for every second of the respective LTO cycle
Engine_Specs = zeros(40,4); 

% Matching the aircraft engines to the nvPM production quantities listed 
% on the PM_sheet datatable
for k = 1:40
    % Extracting the engine in question
    eng = Engines{k};
    % Finding the engine in question on the PM_sheet datatable
    index = find(strcmp(eng,PM_sheet{1:215,1}) == 1);
    % Extracting the engine performance data from the PM_sheet datatable
    fuel_flow_TO = PM_sheet{index,12};  % Fuel flow during the take-off stage (kg/s)
    fuel_flow_CO = PM_sheet{index,13};  % Fuel flow during the climb-out stage (kg/s)
    fuel_flow_APP = PM_sheet{index,14}; % Fuel flow during the approach stage (kg/s)
    fuel_flow_IDL = PM_sheet{index,15}; % Fuel flow during the idle stage (kg/s)
    PM_EI_TO = PM_sheet{index,27};      % nvPM emission index during the take-off stage (mg/kg)
    PM_EI_CO = PM_sheet{index,27};      % nvPM emission index during the take-off stage (mg/kg)
    PM_EI_APP = PM_sheet{index,27};     % nvPM emission index during the take-off stage (mg/kg)
    PM_EI_IDL = PM_sheet{index,27};     % nvPM emission index during the take-off stage (mg/kg)
    % Storing the data in the Engine_Specs matrix
    % Here, we are multiplying the fuel flow * emissions index * standard
    % LTO times for each of the stages of flight
    Engine_Specs(k,1) = fuel_flow_TO*PM_EI_TO*42;   % nvPM flow during the take-off stage (mg)
    Engine_Specs(k,2) = fuel_flow_CO*PM_EI_CO*132;   % nvPM flow during the climb-out stage (mg)
    Engine_Specs(k,3) = fuel_flow_APP*PM_EI_APP*240; % nvPM flow during the approach stage (mg)
    Engine_Specs(k,4) = fuel_flow_IDL*PM_EI_IDL*1560/2; % nvPM flow during the idle stage (mg)
    % Here, we divide the idle time by 2, assuming that an equal amount of
    % time is spent in the idle stage at the origin and destination
    % airports.
end

% Creating the matrix to store the total nvPM production quantities
PM = zeros(30,11,12);

% Creating the matrix to store the total number of operations (i.e.,
% landings and take-offs) at the 30 major US airports
ops = zeros(30,11,12);

% Calculating the total nvPM production at the 30 major US airports,
% during 2009 and 2019, for each month
% Iterating through the years
for year = 1:11 
    
    % Utilizing the correct sheet from the "Historic Flights" database
    flights = readtable('Historic Flights.xlsx','Sheet',shts(year+1));

    % Iterating through every flight
    for k = 1:height(flights) 
        
        origin = flights{k,3};
        destination = flights{k,4};
        departures = flights{k,1}; 
        plane = flights{k,5};
        month = flights{k,7};

        % Only considering those flights in and out the 30 major airports
        if sum(strcmp(origin,Airports)) == 1 
            
            % Finding the airport index
            airport_index = find(strcmp(origin,Airports) == 1);
            % Finding the index of the aircraft that operated the route
            airplane_index = find((plane == Aircraft) == 1);
            if isempty(airplane_index) == 0
                % Take-off, climb-out, and departure idle emissions
                PM_emissions = Engine_Specs(airplane_index,1) + Engine_Specs(airplane_index,2) + Engine_Specs(airplane_index,4);
                PM(airport_index,year,month) = PM(airport_index,year,month) + departures*PM_emissions;
                ops(airport_index,year,month) = ops(airport_index,year,month) + departures;
            end

        elseif sum(strcmp(destination,Airports)) == 1

            % Finding the airport index
            airport_index = find(strcmp(destination,Airports) == 1);
            % Finding the index of the aircraft that operated the route
            airplane_index = find((plane == Aircraft) == 1);
            if isempty(airplane_index) == 0
                % Approach and arrival idle emissions
                PM_emissions = Engine_Specs(airplane_index,3) + Engine_Specs(airplane_index,4);
                PM(airport_index,year,month) = PM(airport_index,year,month) + departures*PM_emissions;
                ops(airport_index,year,month) = ops(airport_index,year,month) + departures;
            end

        end
        % If the flight is not to/from the 30 major US airports, skip to
        % the next flight   
    end

end