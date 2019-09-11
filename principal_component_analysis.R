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
) %>%
    mutate(code_4 = as.integer(substr(code_7, 1, 4)))

# Aggregate the census data by GND and DSD levels and by household and 
# population data
## Remove the housing variables as they are redundant
## Remove most of the "other" fields as they are ambiguous
## Remove the age and gender variables as they are irrelevant
datasets <- list(
    "gnd" = list(
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
    ),
    "dsd" = list(
        "household" = census_data %>%
            group_by(code_4) %>%
            summarise_at(
                vars(-code_7),
                list(~sum(., na.rm = TRUE))
            ) %>%
            select(
                code_4,
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
            group_by(code_4) %>%
            summarise_at(
                vars(-code_7),
                list(~sum(., na.rm = TRUE))
            ) %>%
            select(
                code_4,
                starts_with("edu"),
                starts_with("emp")
            ) %>%
            distinct() %>%
            na.omit()
    )
)

# Conduct principle component analysis on the datasets
pca_results <- list()
first_components <- list()
for(i in names(datasets)) {
    for(j in names(datasets[[i]])) {
        ## Run the analysis
        pca_results[[i]][[j]] <- prcomp(
            datasets[[i]][[j]] %>% 
                select(-one_of(c("code_7", "code_4"))), 
            scale. = TRUE
        )
        
        ## Plot the results
        var <- pca_results[[i]][[j]]$sdev^2
        biplot(pca_results[[i]][[j]], scale = 0)
        plot(var/sum(var), type = "b")
        plot(cumsum(var), type = "b")
        
        ## Extract the first principle component
        first_components[[i]][[j]] <- pca_results[[i]][[j]]$rotation[, "PC1"]
        first_components[[i]][[j]]["code_7"] <- 1
        first_components[[i]][[j]]["code_4"] <- 1
    }
}
rm(i, j, var)

# Calculate the socioeconomic index for each dataset
## First normalize the datasets
normalized_datasets <- list()
for(i in names(datasets)) {
    for(j in names(datasets[[i]])) {
        normalized_datasets[[i]][[j]] <- datasets[[i]][[j]] %>%
            mutate_at(
                vars(-one_of(c("code_7", "code_4"))), 
                funs((. - min(.))/(max(.) - min(.)))
            )    
    }
}
rm(i, j)

## Calculate the first principle component for each dataset
indexes <- list()
for(i in names(normalized_datasets)) {
    for(j in names(normalized_datasets[[i]])) {
        indexes[[i]][[j]] <- as.data.frame(
            mapply(
                '*', 
                normalized_datasets[[i]][[j]], 
                first_components[[i]][[j]][names(normalized_datasets[[i]][[j]])]
            )
        ) %>%
            mutate(
                pc_1 = rowSums(
                    select(., -one_of(c("code_7", "code_4")))
                )
            ) %>%
            select(
                one_of(c("code_7", "code_4")), pc_1
            )
    }
}
rm(i, j)

# Write the results
for(i in names(indexes)) {
    for(j in names(indexes[[i]])) {
        write.csv(
            x = indexes[[i]][[j]], 
            file = paste0("results/", i, "_", j, "_pc1.csv"),
            row.names = FALSE
        )   
    }
}
rm(i, j)