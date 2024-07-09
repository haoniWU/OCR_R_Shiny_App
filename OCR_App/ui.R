#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(base64enc)
library(DT)
library(openxlsx)

# Define UI for app
ui <- shinyUI(fluidPage(
  theme = bslib::bs_theme(bootswatch = "darkly"),
  
  # App title
  titlePanel("OCR App"),
  
  # Sidebar panel for inputs
  sidebarLayout(
    sidebarPanel(width = 6,
      # Input: file
      fileInput('file_input', 'upload file (.png format only)', accept = c('image/png')),
      
      # Show file
      uiOutput("pngview"),
      
      tabsetPanel(
      
        tabPanel("location of excavation",
          # Entry loc
          textInput("loc_name", "Enter location of excavation"),
          actionButton("add_loc", "Add location")
        ),
        
        tabPanel("Downloads",
          # Button download CSV
          downloadButton("CSVData", "Download CSV file"),
          
          # Button download Excel
          downloadButton("ExcelData", "Download Excel file"),
        ),
        
        tabPanel("Delete row",
          # Entry row number
          numericInput("index_to_delete", "Index of the line to delete", value = 1),
          # Delete row button
          actionButton("delete_row_button", "Delete row"),
        ),
        
        tabPanel("Delete column",
          # Entry name column
          textInput("column_name_to_delete", "Name of the column to delete"),
          # Delete column button
          actionButton("delete_column_button", "Delete column"),
        ),
      ),
    ),
    
    mainPanel(width = 6,
              
      # Table
      DTOutput("table"),
    )
  )
))
