<a name="back_to_top"></a>
# Visualizing and Quantifying Particulate Matter (PM) Production and Concentration Trends at 30 Major U.S. Airports

In this repository, we provide an overview of the MATLAB code utilized to visualize and quantify trends in both PM production and concentration levels at 30 Major U.S. airports, between 2009 and 2019. For more details, please consult the write-up, titled "Visualizing and Quantifying PM".

## MATLAB Code

### Table of Contents

1: [ Data Sources & Scripts ](#overview) <br />
2: [ Results ](#results) <br />

---
<a name="overview"></a>
### 1: Data Sources & Scripts

### Data Sources

The code developed for this work leveraged publicly available datasources from the U.S. [Bureau of Transportation Statistics](https://www.transtats.bts.gov/) (BTS), the [International Civil Aviation Organization](https://www.easa.europa.eu/en/domains/environment/icao-aircraft-engine-emissions-databank) (ICAO) as well as the University of Washington in St. Louis' [Atmospheric Composition Analysis Group](https://sites.wustl.edu/acag/datasets/surface-pm2-5/) (ACAG). 
* _From the BTS_: Extracted data from [Form 41 T-100 Segment](https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=GDM) for all flights (domestic and international) operated by U.S. airlines between 2009 and 2019. The data has been compiled and cleaned into an excel [datasheet](https://mitprod-my.sharepoint.com/:x:/g/personal/andyeske_mit_edu/EXCUoyS-hvFJkhy3sSUVcVMBTWTA0K3ABpiHsyl4SvChfw?e=xda3xC) which, for every flight, contains information about the specific aircraft as well as the total number of departures over the measured period.
* _From the ICAO_: Extracted data corresponding to the production of nvPM for various engines at the four stages of flight falling within the Landing and Take-Off (LTO) category. The "_Summary_" tab within the above-mentioned excel [datasheet](https://mitprod-my.sharepoint.com/:x:/g/personal/andyeske_mit_edu/EXCUoyS-hvFJkhy3sSUVcVMBTWTA0K3ABpiHsyl4SvChfw?e=xda3xC) provides a matching of specific jet engines engines to specific aircraft, to enable calculating the nvPM produced during the LTO phase of every flight.
* _From the ACAG_: Extracted satellite geospatial monthly and annual data corresponding to surface PM2.5 measurements in North America between 2009 and 2019. This data has been kindly prepared and made open to the public by ACAG in the [following repository](https://wustl.app.box.com/s/iwvi2avusnz3fpabl6v5ouyobavbt70a/folder/273835984482).

### Scripts

In the [MATLAB Code](https://github.com/andyeske/Airports-PM/tree/main/MATLAB%20Code) folder of this repository, the user will find three scripts: ```Airport_PM```, ```Compute_PM```, and ```Compute_PM_conc```. Of these, only the first script will be described in detail, given that the latter two were utilized to compute the results conveniently stored in the _'Results.xlsx'_ spreadsheet, contained within the [Data Tables](https://github.com/andyeske/Airports-PM/tree/main/Data%20Tables) folder. Should the user desire to run additional case studies for other US airports or would like to examine PM2.5 data corresponding to other regions, it can do so using the these two scrips as well as the datasources above-mentioned.

In order to run ```Airport_PM```, the user must download the _'Results.xlsx'_ spreadsheet. Within ```Airport_PM```, the user will only need to focus on lines 1-43, which are copied below:

```
% -------------------------------------------- %
% ---------------- Airport_PM ---------------- %
% -------------------------------------------- %

% The following script calculates the evolution of PM2.5 concentrations and
% nvPM production quantities at 30 major US airports between 2009 and 2019

% -------------------------------------------- %
% ---------- USER DEFINED VARIABLES ---------- %
% -------------------------------------------- %
% INPUTS: 
% Please select the desired month:
% January | February | March     | April   | May      | June
% July    | August   | September | October | November | December
Month = 'January';

% Please select the desired airport:
% ATL | BOS | CLT | ORD | MDW | DAL | DFW | DEN
% DTW | FLL | IAH | HOU | LAS | LAX | MIA | MSP
% JFK | LGA | EWR | OAK | MCO | PHL | PHX | PDX
% SLC | SAN | SFO | SEA | IAD | DCA
Airport = 'CLT';

% Please select the desired circle radius resolution:
% 0.01 | 0.02 (degrees, where 0.01 ~ 1 km)
R = 0.01;

% OUTPUTS:
% Plot 1: bar chart displaying the PM2.5 concentrations (2019) at the 
% chosen airport with its reference city location for the chosen month. 

% Plot 2: map displaying the locations of the chosen airport and the
% reference city location.

% Plot 3: bar chart displaying the year-by-year evolution (2009 - 2019) of
% the nvPM production at an airport and the total number of operations,
% defined as the number of landings and take-offs the airport saw during
% that period.

% Plot 4: scatter plot displaying the year-by-year relationship 
% (2009 - 2019) between PM2.5 concentrations at the airport and the 
% absolute production quantities of nvPM due to aircraft landing and 
% taking-off at that airport.
```

Here, the user must simply input a number on:
* ```Month```: enter a month, e.g., ```Month = September```. This choice will influence the results seen in "_Plot 1_".
* ```Airport```: enter a three-letter airport code, e.g., ```Airport = BOS```. This choice will influence the results seen across all of the plots. The choice of possible airports supported by this code is shown above, and also in **Figure 1** below.  
* ```R```: enter a resolution for the circle around the airport and reference city, e.g., ```R = 0.02```. This choice will influence the results in all plots but "_Plot 3_". This circle is used to obtain surface PM2.5 concentrations at the locations of interest.

<p align="left">
<img src="https://github.com/andyeske/Airports-PM/blob/main/Sample%20Figures/Airports.jpg" width="500"> 

**Figure 1:** _30 Major U.S. Airports supported by the developed code_.
</p>

([ back to top ](#back_to_top))

---
<a name="results"></a>
### 2: Results

The following section presents some sample results from implementing the developed code. For instance:

**1:** Setting ```Month = November```, ```Airport = BOS``` and ```R = 0.01``` results in **Figure 2** below. BOS experienced, on average, a higher [PM2.5] than the downtown area during November 2019, and in general, nvPM production / operations has been steadily going down. Meanwhile, there is no clear correlation between [PM2.5] and the nvPM produced at the airport.

<p align="left">
<img src="https://github.com/andyeske/Airports-PM/blob/main/Sample%20Figures/Boston%20Example.jpg" width="500"> 

**Figure 2:** _Boston Logan (BOS) nvPM and [PM2.5] values_.
</p>

**2:** Setting ```Month = January```, ```Airport = CLT``` and ```R = 0.01``` results in **Figure 3** below. CLT experienced, on average, a lower [PM2.5] than the downtown area during January 2019, and nvPM production / operations have oscillated with time. There is still no clear correlation between [PM2.5] and the nvPM produced at the airport.

<p align="left">
<img src="https://github.com/andyeske/Airports-PM/blob/main/Sample%20Figures/Charlotte%20Example.jpg" width="500"> 

**Figure 3:** _Charlotte Douglas (CLT) nvPM and [PM2.5] values_.
</p>

**3:** Setting ```Month = September```, ```Airport = PHL``` and ```R = 0.02``` results in **Figure 4** below. PHL experienced, on average, a higher [PM2.5] than the downtown area during September 2019, and nvPM production / operations have increased and decreased with time. Now, there is a much clearer agreement between [PM2.5] and the nvPM produced at the airport.

<p align="left">
<img src="https://github.com/andyeske/Airports-PM/blob/main/Sample%20Figures/Philadelphia%20Example.jpg" width="500"> 

**Figure 4:** _Philadelphia International (PHL) nvPM and [PM2.5] values_.
</p>

**4:** Setting ```Month = August```, ```Airport = PHX``` and ```R = 0.02``` results in **Figure 5** below. PHX experienced, on average, a roughly comparable [PM2.5] to the downtown area during August 2019, while nvPM production / operations have steadily decreased with time. For PHX, there seems to be a very clear positive relationship between [PM2.5] and the nvPM produced at the airport.

<p align="left">
<img src="https://github.com/andyeske/Airports-PM/blob/main/Sample%20Figures/Phoenix%20Example.jpg" width="500"> 

**Figure 5:** _Phoenix Sky Harbor (PHX) nvPM and [PM2.5] values_.
</p>

**5:** Setting ```Month = March```, ```Airport = SFO``` and ```R = 0.01``` results in **Figure 6** below. SFO experienced, on average, a similar [PM2.5] to the downtown area during March 2019, and nvPM production / operations have seemed to have decreased with time. There is also a decent agreement between [PM2.5] and the nvPM produced at the airport.

<p align="left">
<img src="https://github.com/andyeske/Airports-PM/blob/main/Sample%20Figures/San%20Francisco%20Example.jpg" width="500"> 

**Figure 6:** _San Franciso International (SFO) nvPM and [PM2.5] values_.
</p>

([ back to top ](#back_to_top))

## Author

Andy Eskenazi, Department of Aeronautics and Astronautics,
Massachusetts Institute of Technology, 2024 <br />
