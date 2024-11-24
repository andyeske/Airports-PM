<a name="back_to_top"></a>
# Visualizing and Quantifying Particulate Matter (PM) Production and Concentration Trends at 30 Major U.S. Airports

In this repository, we provide an overview of the MATLAB code utilized to visualize and quantify trends in PM production and concentration at 30 Major U.S. airports, between 2009 and 2019.

## MATLAB Code

### Table of Contents

1: [ Code Overview & Inputs](#overview) <br />
2: [ Results ](#results) <br />

---
<a name="overview"></a>
### 1: Code Overview & Inputs

In the MATLAB Code folder of this repository, the user will find 

In order to run ```AllPathways_scrip```, besides downloading the above-listed functions

Within ```AllPathways_scrip```, the user will only need to focus on lines 12-51, which are copied below:

Here, the user must simply input a number on:
* ```Bio_path```: enter a vector (using the numbers 1-5), separated by commas, indicating the desired Bio pathways. E.g., ```Bio_path = [1,3]``` for _'1) Corn Grain + Corn Residue (Stover) ATJ, + Corn Oil HEFA'_ and _'3) Sugarcane Grain, + Bagasse ATJ'_.
* ```DAC_path```: simply leave as ```DAC_path = 1```, which corresponds to _'DAC + RWGS + FT'_.
* ```state```: enter a string (using the state two-letter code), separated by commas, indicating the desired states. E.g., ```state = {'CA','FL','IA','MA','TX'}``` for California, Florida, Iowa, Massachusetts and Texas bar and map plots.

([ back to top ](#back_to_top))

---
<a name="results"></a>
### 2: Results: Biological (Crop) Feedstock Pathways

The following section presents the plots corresponding

([ back to top ](#back_to_top))

## Author

Andy Eskenazi, Department of Aeronautics and Astronautics,
Massachusetts Institute of Technology, 2024 <br />
