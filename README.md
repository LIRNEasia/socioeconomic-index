## Introduction
A socioeconomic index, also known as a deprivation index, is a single numerical figure that gauges the socioeconomic status of a predefined area. It encompasses multiple socioeconomic characteristics as well as their relative significance. It would allow for direct comparisons of socioeconomic status between regions and would be tremendously useful in identifying patterns and correlations between socioeconomic status and other attributes. This is our attempt at creating a socioeconomic index for Sri Lanka.

## Dataset
The dataset we used was the [2011 national census datasets](http://www.statistics.gov.lk/PopHouSat/CPH2011/index.php?fileName=Activities/TentativelistofPublications). This repository contains a [cleaned version](/data) of these datasets. Below is a thorough description of the datasets and their respective name in the code.

Dataset | Category | Variable | Name in Code
------- | -------- | -------- | ------------
Household | Cooking Fuel | Firewood<br/>Kerosene<br/>Gas<br/>Electricity<br/>Sawdust / Paddy husk<br/>Other | coo_firewood<br/>coo_kerosene<br/>coo_gas<br/>coo_electricity<br/>coo_sawdust_paddyhusk<br/>coo_other
Household | Floor Material | Cement<br/>Tile / Granite / Terrazzo<br/>Mud<br/>Wood<br/>Sand<br/>Concrete<br/>Other | flo_cement<br/>flo_tile_granite_terrazzo<br/>flo_mud<br/>flo_wood<br/>flo_sand<br/>flo_concrete<br/>flo_other
Household | Housing | Permanent<br/>Semi-permanent<br/>Improvised<br/>Unclassified | hou_permanent<br/>hou_semipermanent<br/>hou_improvised<br/>hou_unclassified
Household | Lighting | National Grid<br/>Hydro Power<br/>Kerosene<br/>Solar Power<br/>Biogas<br/>Other | lig_nationalgrid<br/>lig_hydro<br/>lig_kerosene<br/>lig_solar<br/>lig_biogas<br/>lig_other
Household | Roof Material | Tile<br/>Asbestos<br/>Concrete<br/>Zinc / Aluminium sheet<br/>Metal sheet<br/>Cadjan / Palmyrah / Straw<br/>Other | roo_tile<br/>roo_asbestos<br/>roo_concrete<br/>roo_zinc_aluminium<br/>roo_metal<br/>roo_cadjan_palmyrah_straw<br/>roo_other
Household | Structure | Single - 1 story<br/>Single - 2 story<br/>Single - 3+ story<br/>Attached house / Annex<br/>Flat<br/>Condominium<br/>Twin house<br/>Row / Line room<br/>Hut / Shanty | str_single_1<br/>str_single_2<br/>str_single_3<br/>str_attachedhouse_annex<br/>str_flat<br/>str_condominium<br/>str_twinhouse<br/>str_room<br/>str_hut_shanty
Household | Tenure | Owned<br/>Rent / Lease - government owned<br/>Rent / Lease - private owned<br/>Rent free<br/>Encroached<br/>Other | ten_owned<br/>ten_rent_gov<br/>ten_rent_pvt<br/>ten_rent_free<br/>ten_encroached<br/>ten_other
Household | Toilet Facilities | Water Seal - connected to sewer<br/>Water Seal - connected to septic tank<br/>Pour flush<br/>Direct pit<br/>Other<br/>No toilet | toi_waterseal_sewer<br/>toi_waterseal_tank<br/>toi_pourflush<br/>toi_directpit<br/>toi_other<br/>toi_none
Household | Wall Material | Brick<br/>Cement block / Stone<br/>Cabook<br/>Soil brick<br/>Mud<br/>Cadjan / Palmyrah<br/>Plank / Metal sheet<br/>Other | wal_brick<br/>wal_cementblock_stone<br/>wal_cabook<br/>wal_soilbrick<br/>wal_mud<br/>wal_cadjan_palmyrah<br/>wal_plank_metal<br/>wal_other
Household | Waste Disposal | Collected by government<br/>Burned<br/>Buried<br/>Composted<br/>Disposed into environment<br/>Other | was_collect_gov<br/>was_burn<br/>was_bury<br/>was_compost<br/>was_dispose_env<br/>was_other
Household | Water Source | Protected well - within premises<br/>Protected well - outside premises<br/>Unprotected well<br/>Tap - within unit<br/>Tap - outside unit but within premises<br/>Rural water projects<br/>Tube well<br/>Bowser<br/>River / Tank / Stream<br/>Rain water<br/>Bottled water<br/>Other | wat_well_prot_in<br/>wat_well_prot_out<br/>wat_well_unprot<br/>wat_tap_unit_in<br/>wat_tap_prem_in<br/>wat_tap_prem_out<br/>wat_rural<br/>wat_tubewell<br/>wat_bowser<br/>wat_river_tank_stream<br/>wat_rain<br/>wat_bottled<br/>wat_other
Population | Age | 0 - 4<br/>5 - 9<br/>10 - 14<br/>15 - 19<br/>20 - 24<br/>25 - 29<br/>30 - 34<br/>35 - 39<br/>40 - 44<br/>45 - 49<br/>50 - 54<br/>55 - 59<br/>60 - 64<br/>65 - 69<br/>70 - 74<br/>75 - 79<br/>80 - 84<br/>85 - 89<br/>90 - 94<br/>95 & above | age_y0_4<br/>age_y5_9<br/>age_y10_14<br/>age_y15_19<br/>age_y20_24<br/>age_y25_29<br/>age_y30_34<br/>age_y35_39<br/>age_y40_44<br/>age_y45_49<br/>age_y50_54<br/>age_y55_59<br/>age_y60_64<br/>age_y65_69<br/>age_y70_74<br/>age_y75_79<br/>age_y80_84<br/>age_y85_89<br/>age_y90_94<br/>age_y95_above
Population | Education | Primary<br/>Secondary<br/>O Level<br/>A Level<br/>Degree & Above<br/>No Schooling | edu_primary<br/>edu_secondary<br/>edu_olevel<br/>edu_alevel<br/>edu_degree<br/>edu_none
Population | Employment | Employed<br/>Unemployed<br/>Economically Inactive | emp_employed<br/>emp_unemployed<br/>emp_inactive
Population | Gender | Male<br/>Female | gen_male<br/>gen_female

_Note: The 2011 national census datasets are only available as a summary of counts at the Grama Niladhari Division (GND) level. The original categorical variables surveyed at the household level have been converted to binary variables and aggregated for each GND. This obscures certain correlations between variables, therefore our results are suboptimal._

## Methodology
We employed principal component analysis (PCA) and extracted the first principal component to use as the socioeconomic index. We strongly recommend reading [Vyas and Kumaranayake (2006)](https://doi.org/10.1093/heapol/czl029) for a thorough justification of this method as well as an exploration of alternatives. 

This [blog post](blogpostlink) contains a thorough description of our process. In short, we observed the following procedure:
1. Curate the dataset to remove variables that are either redundant or non-indicative of socioeconomic status.
2. Normalize the dataset with respect to each category within each GND.
3. Standardize each variable.
4. Run PCA on the standardized dataset.
5. Extract the weights given by the first principal component.
6. Multiply the standardized dataset by these weights.
7. Sum the above scores for each GND to get the socioeconomic index.

## Results
We separated the GNDs into seven quantiles and plotted their socioeconomic index as a choropleth map. These are our results using the household and population datasets.

### Combined Dataset
![Socioeconomic Index using the combined dataset](/results/gnd_combined.png)

### Household Dataset
![Socioeconomic Index using the household dataset](/results/gnd_household.png)

### Population Dataset
![Socioeconomic Index using the population dataset](/results/gnd_population.png)
