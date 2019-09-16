library(tidyverse)

# Read in the data
census_data <- lapply(
    list.files("data"),
    function(filename) {
        read.csv(
            file = paste0("data/", filename), 
            stringsAsFactors = FALSE
        ) %>%
            select(
                -dist_name,
                -dsd_name,
                -gnd_name,
                -gnd_number,
                -total
            ) %>%
            mutate(
                total = rowSums(.[-1])
            ) %>%
            rename_at(
                vars(-code_7),
                list(~paste(substr(filename, 1, 3), ., sep = "_"))
            )
    }
)

# Merge the census datasets into a single large dataset
census_data <- Reduce(
    function(x, y) {
        inner_join(x, y, by = c("code_7"))
    },
    census_data
)

# Aggregate the census data by household and population data
## Remove the housing variables as they are redundant
## Remove most of the "other" fields as they are ambiguous
## Remove the age and gender variables as they are irrelevant
datasets <- list(
    "household" = census_data %>%
        select(
            code_7,
            starts_with("coo"),
            starts_with("flo"),
            starts_with("lig"),
            starts_with("roo"),
            starts_with("str"),
            starts_with("ten"),
            starts_with("toi"),
            starts_with("wal"),
            starts_with("wat")
        ) %>%
        mutate(
            coo_total = coo_total - coo_other,
            flo_total = flo_total - flo_other,
            lig_total = lig_total - lig_other,
            roo_total = roo_total - roo_other,
            ten_total = ten_total - ten_other,
            wal_total = wal_total - wal_other,
            wat_total = wat_total - wat_other
        ) %>%
        select(
            -coo_other,
            -flo_other,
            -lig_other,
            -roo_other,
            -ten_other,
            -wal_other,
            -wat_other
        ) %>%
        na.omit(),
    "population" = census_data %>% 
        select(
            code_7,
            starts_with("edu"),
            starts_with("emp")
        ) %>%
        na.omit()
)

# Normalize the datasets with respect to category within each GND
normalized_datasets <- datasets
categories <- unique(substr(names(census_data), 1, 3))[-1]
for(i in names(normalized_datasets)) {
    for(j in categories) {
        normalized_datasets[[i]] <- normalized_datasets[[i]] %>%
            mutate_at(
                vars(starts_with(j)), 
                list(~. / .data[[paste(j, "total", sep = "_")]])
            )
    }
    normalized_datasets[[i]] <- normalized_datasets[[i]] %>%
        select(-ends_with("total"))
}
normalized_datasets[["population"]] <- normalized_datasets[["population"]] %>% 
    mutate_all(~replace(., is.na(.), 0))
rm(categories, i, j)

# Conduct principle component analysis on the normalized datasets
pca_results <- list()
first_components <- list()
for(i in names(normalized_datasets)) {
    ## Run the analysis
    pca_results[[i]] <- prcomp(
        normalized_datasets[[i]] %>% 
            select(-code_7), 
        scale. = TRUE
    )
    
    ## Plot the results
    var <- pca_results[[i]]$sdev^2
    biplot(pca_results[[i]], scale = 0)
    plot(var/sum(var), type = "b")
    plot(cumsum(var/sum(var)), type = "b")
    
    ## Extract the first principle component
    first_components[[i]] <- pca_results[[i]]$rotation[, "PC1"]
    first_components[[i]]["code_7"] <- 1
}
rm(i, var)

# Calculate the socioeconomic index for each dataset
indexes <- list()
for(i in names(normalized_datasets)) {
    indexes[[i]] <- as.data.frame(
        mapply(
            '*', 
            normalized_datasets[[i]], 
            first_components[[i]][names(normalized_datasets[[i]])]
        )
    ) %>%
        mutate(
            pc_1 = rowSums(
                select(., -code_7)
            )
        ) %>%
        select(
            code_7, pc_1
        )
}
rm(i)

# Write the results
for(i in names(indexes)) {
    write.csv(
        x = indexes[[i]], 
        file = paste0("results/gnd_", i, "_pc1.csv"),
        row.names = FALSE
    )   
}
rm(i)