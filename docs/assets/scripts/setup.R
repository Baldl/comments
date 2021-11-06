library(tigris)
library(acs14lite)

set_api_key("Your Census API key here")

atx <- tracts('TX', 'Travis')

inc <- acs14(geography = 'tract', variable = 'B19013_001E', 
             state = 'TX', county = 'Travis')

inc$GEOID <- paste0(inc$state, inc$county, inc$tract)

atx <- geo_join(atx, inc, by = 'GEOID')

atx$income <- atx$B19013_001E

saveRDS(atx, 'travis.rds')