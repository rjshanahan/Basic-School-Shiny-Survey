#Richard Shanahan  
#https://github.com/rjshanahan  
#rjshanahan@gmail.com
#19 January 2017

###### School Survey ###### 

################# 1. LOAD PACKAGES & SETUP SESSION #################

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

#reorder visualisations
reorder_size <- function(x) {
  factor(x, levels = names(sort(table(x),
                                decreasing=TRUE)))
}


#school list
mySchool_simple <- c('Magill Primary', 'Norton Summit Primary', 'Trinity Gardens Primary', 'Stradbroke','St Peters Girls', 'Wilderness', 'Pembroke','St Josephs', 'St Ignatius')

################# 2. SHINY SERVER FUNCTION #################


server <- function(input,output,session) {
  
  
  output$yourSchool <- renderText({ 
    input$i_school_select
  })



  schoolSurvey <-reactiveValues(
    
    schoolData =     data.frame(
      school_name = character(),
      PROXIMITY_HOME = integer(),
      PROXIMITY_WORK = integer(),
      REP_ACADEMIC = integer(),
      REP_SOCIAL = integer(),
      REP_ARTS = integer(),
      REP_SPORTS = integer(),
      FRIENDS = integer(),
      SECONDARY_PROG = integer(),
      UNIFORM = integer(),
      GROUNDS_SAFETY = integer(),
      GROUNDS_AESTHETICS = integer(),
      COMMUNITY = integer(),
      COST = integer(),
      NON_DENOM = integer(),
      ENROL = integer(),
      COED = integer(),
      DROP_OFF = integer(),
      PUB_TRANSPORT = integer(), 
      stringsAsFactors=FALSE) 
  )
  
  
  addData <- observe({

    #browser()
    if(input$goButton > 0) {
      
      newLine = isolate(c(input$i_school_select,
                           input$i1,input$i2,input$i3,input$i4,input$i5,input$i6,
                           input$i7,input$i8,input$i9,input$i10,input$i11,input$i12,
                           input$i13,input$i14,input$i15,input$i16,input$i17,input$i18 ))

      schoolSurvey$schoolData = isolate(rbindlist(list(schoolSurvey$schoolData, 
                                      as.list(newLine)),
                                      use.names=FALSE,
                                      fill=FALSE))
      
    }
    
  })
  
  
  observeEvent(input$goButton, {
    updateSliderInput(session, 'i1', 'Proximity - to home', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i2', 'Proximity - to work', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i3', 'Reputation - academic', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i4', 'Reputation - social', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i5', 'Reputation - arts', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i6', 'Reputation - sport', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i7', 'Little friends?', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i8', 'Secondary school progression', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i9', 'Uniform', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i10', 'School grounds - safety', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i11', 'School grounds - aesthetics', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i12', 'Sense of community', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i13', 'Cost', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i14', 'Non-denominational', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i15', 'Ease of enrolment', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i16', 'Co-educational', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i17', 'Ease of drop-off/pick-up', min = 0, max = 10, value = 5)
    updateSliderInput(session, 'i18', 'Public transport', min = 0, max = 10, value = 5)
  })
  
  
  output$average_rating <- renderText({
    
    schoolData_df <- schoolSurvey$schoolData
    
      if(is.na(round(mean(as.integer(t(dplyr::filter(schoolData_df, quote(school_name) == input$i_school_select)[-1]))), 2))){
        ""
      }
    else{
      round(mean(as.integer(t(dplyr::filter(schoolData_df, quote(school_name) == input$i_school_select)[-1]))), 2)
    }

    })
  
  
  
  output$average_visual = renderPlotly({
    
    visual_df <<- schoolSurvey$schoolData
    
    visual_df = visual_df %>% 
      reshape2::melt(id.vars = "school_name") %>% 
      group_by(school_name) %>% 
      summarise(rating = round(mean(as.integer(value), na.rm=TRUE), 2))
    
    
    p = ggplot(visual_df,
               aes(x=school_name,
                   y=rating,
                   colour=school_name)) +
      guides(fill=FALSE, colour=FALSE) +
      ggtitle("School Survey - Average School Rating") +
      xlab('School Name') +
      ylab('Rating') +
      labs(caption = 'Note: no weighting has been applied to criteria') +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      geom_point(size=5)
    
    ggplotly(p)
    
  })
  
  
  
  output$survey_results = DT::renderDataTable({
 
    schoolSurvey$schoolData
    
  })
  
}

