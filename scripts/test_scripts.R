
library(clipr)
library(datapasta)
library(DT)
library(leafpop)



df <- person_data[ ,c("lat", "long", "Label", "Organisation")]


####

library(htmlTable)
# Use htmlTables
leaflet(df) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~htmlTable(data.frame(Label, Organisation)))



####
clipr::write_clip(df) 
squads <- datapasta::tribble_paste()

dpasta(df)



###
dt <- DT::datatable((df), width = 500)

leaflet(site) %>% 
   addTiles() %>%
   addMarkers(data = dt,
     lng = ~long, lat = ~lat, 
              popup = popupGraph(dt, type = "html", width = 600),
              popupOptions = popupOptions(maxWidth = 1000)
              )  



### this works to add tiles and markers, but not for more than one record
df <- person_data[ ,c("lat", "long", "Label", "Organisation")]

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(
    data = df,
    popup = popupGraph(
      leaflet() %>%
        addProviderTiles("Esri.WorldImagery") %>%
        addMarkers(data = df,
                   popup = popupTable(df)),
      type = "html"
    )
  )


