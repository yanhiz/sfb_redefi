library(mailR)
library(tidyverse)
library(readxl)

events <- read_excel('event_list.xlsx') %>% filter(state=='upcoming')
sender <- read_file('sender.txt') %>% str_split('\n',simplify = T)
mail <- ''

list_event <- function(status,heading){ 
  mail <- str_c(mail,'<h2>',heading,'</h2>')
  
  for (i in 1:nrow(events %>% filter(mailing==status))) {
  e <- events[i,]
  e$details <- e$details %>%
    str_replace_all('\n','<br>') %>%
    str_replace_all('\\*\\* ','</b> ') %>%
    str_replace_all('\\*\\*','<b>') %>%
    str_replace_all('\\[(.+)\\]\\((.+)\\)\\{.event-link\\}','<a href="\\2">\\1</a>')
  mail <- str_c(mail,e$day,' ',e$month,' ',e$year,': ',e$type,'<br><b>',e$title,'</b> by ',e$people,' (',e$affiliation,') <br>',e$details,'<br><br>')
  }
  return(mail)
}

mail <- str_c(list_event('new','New upcoming events'),list_event('reminder','Reminder'))
mail <- str_c(mail,'<img width=\"300\" style=\"background-color: #8C1E1F;\"src=\"https://yanhiz.github.io/sfb_redefi/img/logos/logo%20black%20white%20schrift.png\">')
cat(mail)

send.mail(from = "yanis.dc@gmail.com",
          to = c("yanis.dc@gmail.com"),
          subject = "SFB ReDefi - Newsletter",
          body = str_c('<html>',mail,'</html>'),
          html = TRUE,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = sender[1], passwd = sender[2], ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)




