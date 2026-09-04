library(tidyverse)

load_publications <- function() {
  read_csv('../sfb_output/publication_list.csv',
           col_names = c('project','type','year','ref')) %>% 
    # MAKE LINKS CLICKABLE
    mutate(ref= str_replace(ref,'(https://.*)','[\\1](\\1)')) %>% 
    # SORT THE DATA FRAME AND ORDER YEARS
    arrange(type,desc(year),ref) %>% mutate(year=factor(year,levels=(unique(year)))) 
}


print_publications <- function(publications,level=4) {
  # PRINT BIBLIOGRAPHY
  for (type in publications %>% group_split(type)) {
    cat(str_c(c(rep('#',level),' '),collapse=''),str_c(str_to_sentence(type$type[1]),'s'),'\n\n')
    for (year in type %>% group_split(year)) {
      cat(str_c(c(rep('#',level+1),' '),collapse=''),as.character(year$year[1]),'\n\n')
      cat(year$ref,'\n\n',sep='\n\n')
    }
  }
}
