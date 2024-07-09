library(shiny)
library(base64enc)
library(DT)

library(reticulate)

if (!py_module_available("cv2")) {
  # Installer opencv-python si nécessaire
  py_install("opencv-python", pip = TRUE)
}

if (!py_module_available("pandas")) {
  # Installer opencv-python si nécessaire
  py_install("pandas", pip = TRUE)
}

# Vérifiez si pytesseract est installé et installez-le si nécessaire
if (!py_module_available("pytesseract")) {
  py_install("pytesseract", pip = TRUE)
}

# Source your Python file
source_python("layout-analysis/main.py")


###################################################################################

server <- function(input, output, session) {
  rv <- reactiveValues(data = NULL)
  
  # Observer pour capturer les modifications apportées au tableau
  observeEvent(input$table_cell_edit, {
    info <- input$table_cell_edit
    str(info) # Vérifiez la structure de l'objet info pour voir comment récupérer les informations sur la modification
    rowIndex <- info$row # Adjusting for R's 1-based indexing
    colIndex <- info$col # Adjusting for R's 1-based indexing
    newValue <- info$value
    
    # Mettez à jour le dataframe avec la nouvelle valeur
    rv$data[rowIndex, colIndex] <- newValue
  })
  
  
  # Ajouter une colonne avec le nom de location spécifié
  observeEvent(input$add_loc, {
    new_loc <- input$loc_name
    if (nchar(new_loc) > 0) {
      if (!is.null(rv$data)) {
        if ("Localisation" %in% colnames(rv$data)) {
          # Si la colonne existe déjà, mettre à jour les valeurs
          rv$data$Localisation <- new_loc
        } else {
          # Ajouter la nouvelle colonne "Localisation" à gauche
          rv$data <- cbind(Localisation = new_loc, rv$data)
        }
      } else {
        # Si le dataframe est vide, créer un nouveau dataframe avec la colonne "Localisation"
        rv$data <- data.frame(Localisation = new_loc, stringsAsFactors = FALSE)
      }
      updateTextInput(session, "loc_name", value = "")
      output$table <- renderDT({
        datatable(rv$data, editable = TRUE)
      })
    }
  })
  
  # Supprimer une ligne par son index
  observeEvent(input$delete_row_button, {
    row_to_delete <- input$delete_row_button
    if (!is.null(rv$data) &&  row_to_delete %in% nrow(rv$data)) {
      rv$data <- rv$data[-row_to_delete, , drop = FALSE]
      output$table <- renderDT({
        datatable(rv$data, editable = TRUE)
      })
    } else {
      showNotification("Invalid row number", type = "error")
    }
  })
  
  # Supprimer une colonne par son nom
  observeEvent(input$delete_column_button, {
    column_name <- input$column_name_to_delete
    if (!is.null(rv$data) && column_name %in% colnames(rv$data)) {
      rv$data <- rv$data[, !colnames(rv$data) %in% column_name, drop = FALSE]
      output$table <- renderDT({
        datatable(rv$data, editable = TRUE)
      })
    } else {
      showNotification("Invalid column name", type = "error")
    }
  })
  
  # Appeler la fonction Python pour réaliser l'OCR
  observeEvent(input$file_input, {
    req(input$file_input)
    
    # Vérifier si le fichier est une image
    is_image <- grepl("\\.(png|jpeg|jpg)$", input$file_input$name)
    validate(
      need(is_image, "Le fichier doit être une image (.png, .jpeg, .jpg)")
    )
    
    if (!is_image) {
      showNotification("Le fichier téléchargé n'est pas une image valide.", type = "error")
      return(NULL)
    }
    
    temp_file <- tempfile(fileext = ".png")
    file.copy(input$file_input$datapath, temp_file)
    img_path <- temp_file
    
    # Appeler la fonction Python pour réaliser l'OCR
    result <- reticulate::py$test(img_path)
    rv$data <- as.data.frame(result)
    
    output$table <- renderDT({
      datatable(rv$data, editable = TRUE)
    })
  })
  
  output$pngview <- renderUI({
    inFile <- input$file_input
    if (!is.null(inFile)) {
      tags$div(
        tags$img(src = dataURI(file = inFile$datapath, mime = "image/png"), width = "100%")
      )
    }
  })
  
  output$table <- renderDT({
    if (!is.null(rv$data)) {
      datatable(rv$data, editable = TRUE)
    }
  })
  
  output$CSVData <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), '.csv', sep = '')
    },
    content = function(con) {
      write.csv(rv$data, con)
    }
  )
  
  output$ExcelData <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), '.xlsx', sep = '')
    },
    content = function(file) {
      openxlsx::write.xlsx(rv$data, file)
    }
  )
}