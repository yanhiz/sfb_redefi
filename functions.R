library(tidyverse)

months <- c("01"="JAN","02"="FEB", "03"="MAR", "04"="AVR", "05"="MAY", "06"="JUN", "07"="JUL", "08"="AUG", "09"="SEP", "10"="OCT", "11"="NOV", "12"="DEC" )

split_date <- function(data,date) {
  data %>%
    mutate(day=format(date, "%d")) %>%
    mutate(month=months[format(date, "%m")]) %>%
    mutate(year=format(date, "20%y"))
}

load_publications <- function(subproject='P',path='../sfb_output/publication_list.csv') {
  read_csv(path,
           col_names = c('project','type','year','apa','bibtex')) %>% 
    # MAKE LINKS CLICKABLE
    mutate(apa= str_replace(apa,'(https://.*)','[\\1](\\1)')) %>% 
    # SORT THE DATA FRAME AND ORDER YEARS
    arrange(type,desc(year),apa) %>% mutate(year=factor(year,levels=(unique(year)))) |> 
    filter(str_detect(project,subproject))
}


print_publications <- function(publications,level=4,header=TRUE) {
  # PRINT BIBLIOGRAPHY
  for (type in publications %>% group_split(type)) {
    if (header) {cat(str_c(c(rep('#',level),' '),collapse=''),str_c(str_to_sentence(type$type[1]),'s'),'\n\n')}
    for (year in type %>% group_split(year)) {
      if (header) {cat(str_c(c(rep('#',level+1),' '),collapse=''),as.character(year$year[1]),'\n\n')}
      year$bibtex <- year$bibtex %>% str_replace_all('\\},','\\},<br>&emsp;') %>% str_replace(', author',',<br>&emsp;author') %>% str_replace('\\}$','\n\\}') %>% str_replace_all('@','\\\\@')
      year$ref <- str_c('<p>',year$apa,' <input type="button" value="Get Bibtex" class="bibtex-button"/></p><div class="bibtex-entry"><div>',year$bibtex,'</div><input type="button" class="bibtex-copy" value="Copy to clipboard"/></div>')
      cat(year$ref,'\n\n\n',sep='\n\n')
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
