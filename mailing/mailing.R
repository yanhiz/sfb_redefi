library(mailR)
library(tidyverse)
library(readxl)

source("functions.R", local = knitr::knit_global())

send_newsletter <- function(test=F){
  
events <- load_events() %>% filter(date>today())
sent <- load_events('mailing/sent_events.csv') %>% filter(date>today())
upcoming <- setdiff(events,sent)
add <- function(...) {
  mail <- str_c(mail,...)
  return(mail)
}
add_if <- function(info,if_present) {
  ifelse(info!='',if_present,'')
}

if (nrow(upcoming) > 0 | test == T) {

  sender <- read_file('mailing/sender.txt') %>% str_split('\n',simplify = T)
  if (test) {subscribers <- sender[1]} 
  else {subscribers <- read_excel('mailing/subscribers.xlsx')$email}

  mail <- '<html><p>Dear subscribers,</p><p> Welcome to the newsletter of our SFB Language between Redundancy and Deficiency. Discover the upcoming events of our group. You can also find all the events and details <a href="https://yanhiz.github.io/sfb_redefi/news.html">here</a>.</p>'
  mail <- add('<h3>New upcoming events</h2>')
  for (i in 1:nrow(upcoming)) {
    e <- upcoming[i,]
    e$details <- e$details %>%
      str_replace_all('\\*\\* ','</b> ') %>%
      str_replace_all('\\*\\*','<b>') %>%
      str_replace_all('\\[(.+)\\]\\((.+)\\)\\{.event-link\\}','<a href="\\2">\\1</a>')
      mail <- add(e$day,' ',e$month,' ',e$year,': <b>',e$title,'</b>',
                  add_if(e$people,str_c(' by ',e$people)),
                  add_if(e$location,str_c(' (',e$location,')')),'<br>',
                  '<p style="margin-left:1em;">',e$details,'</p><hr>')
  }
  mail <- add('<h3>Reminder for other upcoming events</h2>')
  mail <- add('<ul>')
  for (i in 1:nrow(sent)) {
    e <- sent[i,]
    mail <- add('<li>',e$day,' ',e$month,' ',e$year,': <b>',e$title,'</b>',add_if(e$people,str_c(' by ',e$people)),add_if(e$location,str_c(' (',e$location,')')),'</li>')
  }
  mail <- add('</ul><br>')
  mail <- add('<img width=\"300\" style=\"background-color: #8C1E1F;\"src=\"https://yanhiz.github.io/sfb_redefi/img/logos/logo%20black%20white%20schrift.png\">')
  mail <- add('</html>')

  send.mail(from = sender[1],
            to = sender[1],
            bcc = subscribers,
            subject = "SFB ReDefi - Newsletter",
            body = mail,
            html = TRUE,
            smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = sender[1], passwd = sender[2], ssl = TRUE),
            authenticate = TRUE,
            send = TRUE)
  message('The newsletter has been sent.')
  if(test!=T) {write_csv(rbind(upcoming,sent),file='./mailing/sent_events.csv')}
  }
}