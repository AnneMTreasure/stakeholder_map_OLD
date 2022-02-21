## EXAMPLE FROM WEB ###

library(shiny)

Artist <- c("A1", "A1", "A1", "A1", "A1", "A1", "A1", "A1", "A1", "A1", "A1", "A1", 
            "A2", "A2", "A2", "A2", "A2", "A2", "A2", "A2", "A2", "A2", "A2", "A2", 
            "A3", "A3", "A3", "A3", "A3", "A3", "A3", "A3", "A3", "A3", "A3", "A3")

Language <- c("Spanish", "Spanish", "Spanish", "Spanish", "Spanish", "German", "German", "German", "French", "French", "French", "French",
              "Italian", "Italian", "Italian", "Italian", "Italian", "Polish", "Polish", "Polish", "Israeli", "Israeli", "Israeli", "Israeli",
              "English", "English", "English", "English", "English", "Armenian", "Armenian", "Armenian", "Bengali", "Bengali", "Bengali", "Bengali")

NumberList <- c("uno", "dos", "tres", "cuatro", "cinco", "einz", "zwei", "drei", "un", "deux", "trois", "quatre",
                "uno", "due", "tre", "quattro", "cinque", "jeden", "dwa", "trzy", "achat", "shtaim", "shalosh", "arba",
                "one", "two", "three", "four", "five", "mek", "yerku", "yerek", "shoonno", "ek", "dui", "tin")

df <- data.frame(Artist, Language, NumberList)

ui <- shinyUI(
    fluidPage(
        titlePanel("Language Selection"),
        sidebarLayout(
            sidebarPanel(
                helpText("The goal from this is to have the select tab automatically update with the language after selecting the artist"),
                
                helpText("Select artistId artist"),
                selectInput("artistId", "Artist", choices = unique(df$Artist)),
                helpText("Based on the artist you selected, now select the Language below to display the numberlist in the main panel."),
                
                selectInput("selectinputid", "Language to Select:", choices = unique(df$Language)),
                actionButton("goButton1", "Submit Language")),
            mainPanel(
                tableOutput("result")
            )
        )
    )
)

server <- function(input, output,session) {
    
    observeEvent(D1(),{
        updateSelectInput(session, "selectinputid", "Language to Select:",  choices = unique(D1()$Language),selected = unique(D1()$Language)[1])
    })
    
    D1  <- reactive({
        df[df$Artist %in% input$artistId,]
    })
    
    D2 <- eventReactive(input$goButton1,{
        D1()[D1()$Language %in% input$selectinputid,]
    })
    
    output$result <- renderTable({
        D2()
    })
}

shinyApp(ui, server)