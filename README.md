## Introduction
A socioeconomic index, also known as a deprivation index, is a single numerical figure that gauges the socioeconomic status of a predefined area. It encompasses multiple socioeconomic characteristics as well as their relative significance. It would allow for direct comparisons of socioeconomic status between regions and would be tremendously useful in identifying patterns and correlations between socioeconomic status and other attributes. This is our attempt at creating a socioeconomic index for Sri Lanka.

## Dataset
The dataset we used was the [2011 national census datasets](http://www.statistics.gov.lk/PopHouSat/CPH2011/index.php?fileName=Activities/TentativelistofPublications). This repository contains a [cleaned version](/data) of these datasets.

_Note: The 2011 national census datasets are only available as a summary of counts at the Grama Niladhari Division (GND) level. The original categorical variables surveyed at the household level have been converted to binary variables and aggregated for each GND. This obscures certain correlations between variables, therefore our results are suboptimal._

## Methodology
We employed principal component analysis (PCA) and extracted the first principal component to use as the socioeconomic index. We strongly recommend reading [Vyas and Kumaranayake (2006)](https://doi.org/10.1093/heapol/czl029) for a thorough justification of this method as well as an exploration of alternatives. 

This [blog post](blogpostlink) contains a thorough description of our process. In short, we observed the following procedure:
1. Curate the dataset to remove variables that are either redundant or non-indicative of socioeconomic status.
2. Normalize the dataset with respect to each category within each GND.
3. Standardize each variable.
4. Run PCA on the standardized dataset.
5. Extract the weights given by the first principal component.
6. Multiply the normalized dataset by these weights.
7. Sum the above scores for each GND to get the socioeconomic index.

## Results
We separated the GNDs into seven quantiles and plotted their socioeconomic index as a choropleth map. These are our results using the household and population datasets.

### Household Dataset
![Socioeconomic Index using the household dataset](/results/gnd_household.png)

### Population Dataset
![Socioeconomic Index using the population dataset](/results/gnd_population.png)
