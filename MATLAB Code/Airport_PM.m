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
Month = 'March';

% Please select the desired airport:
% ATL | BOS | CLT | ORD | MDW | DAL | DFW | DEN
% DTW | FLL | IAH | HOU | LAS | LAX | MIA | MSP
% JFK | LGA | EWR | OAK | MCO | PHL | PHX | PDX
% SLC | SAN | SFO | SEA | IAD | DCA
Airport = 'SFO';

% Please select the desired circle radius resolution:
% 0.01 | 0.02 (degrees, where 0.01 ~ 1 km)
R = 0.01;

% OUTPUTS:
% Plot 1: bar chart displaying the PM2.5 concentrations (2019) at the 
% chosen airport with its reference city location for the chosen.

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

% -------------------------------------------- %
% --- DO NOT MODIFY CODE FROM HERE ONWARDS --- %
% -------------------------------------------- %

% Importing the flight data datasheet
shts = sheetnames('Results.xlsx');
coordinates = readtable('Results.xlsx','Sheet',shts(1));
PM = readtable('Results.xlsx','Sheet',shts(2));
PM_conc = readtable('Results.xlsx','Sheet',shts(3));
PM_conc2019 = readtable('Results.xlsx','Sheet',shts(4));
ops = readtable('Results.xlsx','Sheet',shts(5));

% Finding the airport in question
index = find(strcmp(coordinates{1:30,1},Airport) == 1);

% Finding the airport and reference city coordinates
lat_airport = coordinates{index,2};
lon_airport = coordinates{index,3};
City = coordinates{index,4};
lat_city = coordinates{index,5};
lon_city = coordinates{index,6};

% Finding the nvPM data (in metric tons) for the airport in question, as
% well as the number of operations
PM_M = zeros(12,11); % For each of the 11 years and 12 months
ops_M = zeros(12,11);
for k = 1:12
    in = 2 + (k-1)*12;
    PM_M(k,:) = PM{index+1,in:(in+10)};
    ops_M(k,:) = ops{index+1,in:(in+10)};
end
PM_M_tot = sum(PM_M);
ops_M_tot = sum(ops_M);

% Finding the PM2.5 concentration for both the airport and its associated
% reference city in question
PM_conc_M = zeros(2,11); % For each of the 11 years and 12 months
PM_conc2019_M = zeros(2,12);
if R == 0.02 % Circle Resolution Option 1
    in1 = index;
elseif R == 0.01 % Circle Resolution Option 2
    in1 = index+34;
end
for k = 1:2
    in2 = 2 + (k-1)*13;
    PM_conc2019_M(k,:) = PM_conc2019{in1,in2:(in2+11)};
end
for k = 1:2
    in1 = in1 + 1;
    in2 = 2 + (k-1)*12;
    PM_conc_M(k,:) = PM_conc{in1,in2:(in2+10)};
end

% Identifying the month in question:
if sum(strcmp(Month,'January')) == 1,  m = 1;   
elseif sum(strcmp(Month,'February')) == 1, m = 2;
elseif sum(strcmp(Month,'March')) == 1, m = 3;
elseif sum(strcmp(Month,'April')) == 1, m = 4;
elseif sum(strcmp(Month,'May')) == 1, m = 5;
elseif sum(strcmp(Month,'June')) == 1, m = 6;
elseif sum(strcmp(Month,'July')) == 1, m = 7;
elseif sum(strcmp(Month,'August')) == 1, m = 8;
elseif sum(strcmp(Month,'September')) == 1, m = 9;
elseif sum(strcmp(Month,'October')) == 1, m = 10;
elseif sum(strcmp(Month,'November')) == 1, m = 11;
elseif sum(strcmp(Month,'December')) == 1, m = 12;    
end

% Extracting the relevant monthly data
PM_M_month = PM_M(m,:);
ops_M_month = ops_M(m,:);

% -------------------------------------------- %
% ----------------- Plotting ----------------- %
% -------------------------------------------- %
t = tiledlayout(2,2);

% Plot 1: Creating the bar plot comparing PM2.5 concentrations at the city 
% and airport locations
nexttile
CityNames = categorical([Airport,City]);
CityNames = reordercats(CityNames,[Airport,City]);
Vals = [PM_conc2019_M(1,m),mean(PM_conc2019_M(1,:)),PM_conc2019_M(2,m),mean(PM_conc2019_M(2,:))];

Colors = [0 0.4470 0.7410;0 0.4470 0.7410;0.8500 0.3250 0.0980;0.8500 0.3250 0.0980];
alphas = [1;0.5;1;0.5];
b = bar(diag(Vals,0),'stacked','facecolor', 'flat');
set(gca, 'xticklabel', [])
for k = 1:length(Vals)
    text(k,Vals(k)*1.1,[num2str(round(Vals(k),2)),'\mug/m^3'],'FontSize',12,'HorizontalAlignment','center');
    b(k).CData = Colors(k,:);
    b(k).FaceAlpha = alphas(k);
end

% label and set axis limits
text(1.5,-0.3,CityNames(1),'FontSize',12,'HorizontalAlignment','center');
text(3.5,-0.3,CityNames(2),'FontSize',12,'HorizontalAlignment','center');
max_lim = max(Vals)*1.15;
ylim([0 max_lim])
ylabel("[PM_2_._5] (\mug/m^3)");
str1 = [Airport,' - ', Month,' (2019)'];
str2 = [Airport,' - Average (2019)'];
str3 = ['City - ',Month,' (2019)'];
str4 = ['City - Average (2019)'];
legend(str1,str2,str3,str4,'Location','Southeast')
title({'Airport and Reference City [PM_2_._5]',[num2str(Month),' 2019 data']});
set(gca,'FontSize',12)

% Plot 2: Creating the map plot to visualize the city and airport location
% Creating the plot limit coordinates
coor_lat = [lat_airport;lat_city];
coor_lon = [lon_airport;lon_city];
names = {Airport;City};
latlim = [min(coor_lat)-0.05 max(coor_lat)+0.05];
lonlim = [min(coor_lon)-0.05 max(coor_lon)+0.05];
% Creating the circle coordinates
R_vect = R*ones(2,1);
[lats,lons] = scircle1(coor_lat,coor_lon,R_vect);
load usapolygon.mat
gx = geoaxes(t);
for k = 1:2
    hold on
    geoplot(gx,lats(:,k),lons(:,k),'LineWidth',2,'LineStyle','--')
    
    text(gx,coor_lat(k),coor_lon(k),names{k},'HorizontalAlignment','center','VerticalAlignment','middle',...
        'FontSize',12,'Color','w')
end
geobasemap(gx,'streets-dark')
geolimits(gx,latlim,lonlim)
gx.Layout.Tile = 2;
title({'Airport and Reference City Location',['Radius = ',num2str(R),'^o']});
set(gca,'FontSize',12)

% Plot 3: Creating a bar chart showing the evolution of nvPM particle
% production and aircraft operations overtime
nexttile
yyaxis left
bar(2009:2019,(PM_M_month.*10^6)./ops_M_month)
xlabel("Years");
ylb1 = ylabel("nvPM Production / Aircraft Ops (mg/operation)");
ax = gca;
ax.YColor = 'k';

yyaxis right
plot(2009:2019,ops_M_month,'o-','LineWidth',1,'Color',[0,0,0])
ylb2 = ylabel("Aircraft Monthly Ops");
legend(['nvPM/ops - ',Month],['Ops - ',Month],'Location','Southwest')
set(get(gca,'YLabel'),'Rotation',270)
ax = gca;
ax.YColor = 'k';
set(ylb1, 'Color', 'k');
set(ylb2, 'Color', 'k');
ax.YColor = 'k';
title({'Airport nvPM Emissions by Operation',[Month,' yearly data']});
set(gca,'FontSize',12)

% Plot 4: Creating a scatter plot showing the relationship between the
% absolute production of nvPM and the [PM2.5] at the airport in question
nexttile
scatter((10^6).*PM_M_tot./ops_M_tot,PM_conc_M(1,:),100,'*','linewidth',1)
% Fitting a curve to the scatter points
C = fit(((10^6).*PM_M_tot./ops_M_tot)',PM_conc_M(1,:)','poly1');
Y = C.p1.*(10^6).*PM_M_tot./ops_M_tot + C.p2;
% Calculating the R2 of the fit
SStot = sum((PM_conc_M(1,:)-mean(PM_conc_M(1,:))).^2); % Total Sum-Of-Squares
SSres = sum((PM_conc_M(1,:)-Y).^2); % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;   
hold on
plot((10^6).*PM_M_tot./ops_M_tot,Y,'LineWidth',1,'Color',[0 0 0])
title({'Airport nvPM Production and [PM_2_._5]','Yearly average data'})
xlabel('nvPM Production / Aircraft Ops (mg/operation)')
ylabel('[PM_2_._5] (\mug/m^3)')
legend('Data','Fit','Location','Northeast')
str = {['R^2 = ',num2str(round(Rsq,2))],['y = (',num2str(round(C.p1,2)),')*x + (',num2str(round(C.p2,2)),')']};
text(min((10^6).*PM_M_tot./ops_M_tot)*1.01,0.95*max(PM_conc_M(1,:)),str,'FontSize',12)
set(gca,'FontSize',12)

title(t,['Particulate Matter: ',Airport,' as a Case Study'],'FontSize',14,'FontWeight','bold')
% Resizing the figure 
set(gcf, 'Units', 'Normalized', 'Position', [0.1, 0.1, 0.8, 0.8]);


