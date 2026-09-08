library(mailR)
library(tidyverse)
library(readxl)

events <- read_excel('event_list.xlsx') %>% filter(date>today())
sent <- read_csv('mailing/sent_events.csv') %>% filter(date>today())
upcoming <- setdiff(events,sent)
add <- function(...) {
  mail <- str_c(mail,...)
  return(mail)
}

if (nrow(upcoming) > 0) {
  
  sender <- read_file('mailing/sender.txt') %>% str_split('\n',simplify = T)
  subscribers <- read_excel('mailing/subscribers.xlsx')$mail
  
  mail <- '<html><p>Dear subscribers,</p><p> Welcome to the newsletter of our SFB Language between Redundancy and Deficiency. Discover the upcoming events of our group. You can also find all the events and details <a href="https://yanhiz.github.io/sfb_redefi/news.html">here</a>.</p>'
  mail <- add('<h2>New upcoming events</h2>')
  for (i in 1:nrow(upcoming)) {
    e <- upcoming[i,]
    e$details <- e$details %>%
      str_replace_all('\n','<br>') %>%
      str_replace_all('\\*\\* ','</b> ') %>%
      str_replace_all('\\*\\*','<b>') %>%
      str_replace_all('\\[(.+)\\]\\((.+)\\)\\{.event-link\\}','<a href="\\2">\\1</a>')
    mail <- add(e$day,' ',e$month,' ',e$year,': ',e$type,'<br><b>',e$title,'</b> by ',e$people,' (',e$affiliation,') <br>',e$details,'<br><hr>')
  }
  mail <- add('<h2>Reminder</h2>')
  mail <- add('<ul>')
  for (i in 1:nrow(sent)) {
    e <- sent[i,]
    mail <- add('<li>',e$day,' ',e$month,' ',e$year,': <b>',e$title,'</b> by ',e$people,' (',e$type,')</li>')
  }
  mail <- add('</ul><br>')
  mail <- add('<img width=\"300\" style=\"background-color: #8C1E1F;\"src=\"https://yanhiz.github.io/sfb_redefi/img/logos/logo%20black%20white%20schrift.png\">')
  add('</html>')

  send.mail(from = sender[1],
            to = subscribers,
            subject = "SFB ReDefi - Newsletter",
            body = mail,
            html = TRUE,
            smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = sender[1], passwd = sender[2], ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
  
  write_csv(rbind(upcoming,sent),file='./mailing/sent_events.csv')
}