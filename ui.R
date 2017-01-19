#Richard Shanahan  
#https://github.com/rjshanahan  
#rjshanahan@gmail.com
#19 January 2017

###### School Survey ###### 

# load required packages
library(dplyr)
library(ggplot2)
library(reshape2)
library(shiny)
library(data.table)
library(DT)
library(plotly)


#set theme for ggplot2 graphics
theme = theme_set(theme_minimal())
theme = theme_update(legend.position="top",
                     axis.text.x = element_text(angle = 45, hjust = 1, vjust =1.25))



# Choices for drop-downs

#school list
mySchool <- list('PUBLIC' = list('Magill Primary', 'Norton Summit Primary', 'Trinity Gardens Primary', 'Stradbroke'),
                'PRIVATE' = list('St Peters Girls', 'Wilderness', 'Pembroke'),
                'CATHOLIC' = list('St Josephs', 'St Ignatius'))



############################################################
## shiny user interface function
############################################################


shinyUI(
  
  fluidPage(
      

    theme="bootstrap.css",
    titlePanel('School Rating Survey', windowTitle='School Survey'),
    br(),

     fluidRow(
       sidebarPanel(
         
         selectInput(inputId="i_school_select", "Select School", mySchool, selected = mySchool[1][[1]][1]),
         br(),         
         actionButton(inputId="goButton", "Submit your survey!"),
         br(),
         br(),
         h4("School Rating"),
         h1(textOutput("average_rating")),
         tags$head(tags$style("#average_rating{color: red;
                                 font-size: 60px;
                              }"
                         )
         ),
         width=3),
       
       h3(textOutput("yourSchool"),'Rate your school - 1 is low and 10 is high'),
       # tags$head(tags$style("#yourSchool{color: blue;
       #                           font-size: 40px;
       #                      }"
       #                   )
       #),
       br(),
       
       
       
       column(
         sliderInput('i1', 'Proximity - to home', min = 0, max = 10, value = 5),
         sliderInput('i2', 'Proximity - to work', min = 0, max = 10, value = 5),
         sliderInput('i3', 'Reputation - academic', min = 0, max = 10, value = 5),
         sliderInput('i4', 'Reputation - social', min = 0, max = 10, value = 5),
         sliderInput('i5', 'Reputation - arts', min = 0, max = 10, value = 5),
         sliderInput('i6', 'Reputation - sport', min = 0, max = 10, value = 5),
         width=3),
       column(
         sliderInput('i7', 'Little friends?', min = 0, max = 10, value = 5),
         sliderInput('i8', 'Secondary school progression', min = 0, max = 10, value = 5),
         sliderInput('i9', 'Uniform', min = 0, max = 10, value = 5),
         sliderInput('i10', 'School grounds - safety', min = 0, max = 10, value = 5),
         sliderInput('i11', 'School grounds - aesthetics', min = 0, max = 10, value = 5),
         sliderInput('i12', 'Sense of community', min = 0, max = 10, value = 5),
         width=3),
       column(
         sliderInput('i13', 'Cost', min = 0, max = 10, value = 5),
         sliderInput('i14', 'Non-denominational', min = 0, max = 10, value = 5),
         sliderInput('i15', 'Ease of enrolment', min = 0, max = 10, value = 5),
         sliderInput('i16', 'Co-educational', min = 0, max = 10, value = 5),
         sliderInput('i17', 'Ease of drop-off/pick-up', min = 0, max = 10, value = 5),
         sliderInput('i18', 'Public transport', min = 0, max = 10, value = 5),
         width=3)
       ),
     
    fluidRow(
      column(width=12,
             h4("School Rating")),
      plotlyOutput("average_visual")
    ),
     fluidRow(
       column(width=12,
              h4("Survey Results"),
              DT::dataTableOutput("survey_results"))
       )
    )
)
  


