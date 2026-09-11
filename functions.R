library(tidyverse)

load_publications <- function(subproject='P') {
  read_csv('../sfb_output/publication_list.csv',
           col_names = c('project','type','year','ref')) %>% 
    # MAKE LINKS CLICKABLE
    mutate(ref= str_replace(ref,'(https://.*)','[\\1](\\1)')) %>% 
    # SORT THE DATA FRAME AND ORDER YEARS
    arrange(type,desc(year),ref) %>% mutate(year=factor(year,levels=(unique(year)))) |> 
    filter(str_detect(project,subproject))
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


print_card_members <- function(project) {
  library(tidyverse)
  
  members <- readxl::read_excel("../member_list.xlsx") %>%
    filter(subproject == project)
  
  n_members <- nrow(members)
  
  layout_class <- if (n_members == 3) {
    "project-team-grid--three"
  } else {
    "project-team-grid--two"
  }
  
  # Open the single team grid
  cat(
    ":::: {.project-team-grid .",
    layout_class,
    "}\n\n",
    sep = ""
  )
  
  for (i in seq_len(nrow(members))) {
    member <- members[i, ]
    
    cat("::: {.project-member-card}\n\n")
    cat(
      "![](..",
      member$picture,
      "){.project-member-photo}\n\n",
      sep = ""
    )
    cat("#### ", member$short_name, "\n\n", sep = "")
    cat(
      "**", member$position, "**<br>",
      "**University of ", member$university, "**\n\n",
      sep = ""
    )
    cat(
      member$description,
      " [Read more](/people.qmd#",
      member$short_name %>% str_replace_all(" ", "_"),
      "){.read-more}\n\n",
      sep = ""
    )
    cat(
      "[Institutional profile](",
      member$website,
      ")\n\n",
      sep = ""
    )
    cat(":::\n\n")
  }
  
  # Close the team grid
  cat("::::\n")
}
