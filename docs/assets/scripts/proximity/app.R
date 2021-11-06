library(shiny)
library(spdep)
library(leaflet)


#atx = st_read("/home/creu/Desktop/lehre/geoAI/DE_Gitter_ETRS89_LAEA_1km.shp")
#atx <- readRDS("~/edu/courses/moer/moer-mhg-spatial/docs/assets/data/hessen.rds")
atx=st_read("mrbiko1km.shp")
# Extraktion der Koordinaten aus nut3_kreise
atx = st_transform(atx, "+init=EPSG:4326")
#atx=st_make_valid(st_set_precision(atx, 1e6))
atx <- as(atx,"Spatial")
atx$id <- 1:nrow(atx)

# Queen's case spatial weights

aq <- poly2nb(atx, row.names = atx$id)

# Rook's case spatial weights

ar <- poly2nb(atx, queen = FALSE, row.names = atx$id)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      radioButtons('radio', label = 'Select a neighborhood type:',  
                   choices = list("Queen's case contiguity" = 1, "Rook's case contiguity" = 2, 
                                  'K-nearest neighbors' = 3, 'Distance' = 4), 
                   selected = 1), 
      conditionalPanel(
        condition = "input.radio == 3", 
        sliderInput("knn_slider", 'Select number of neighbors', 
                    min = 1, max = 200, value = 8)
      ), 
      conditionalPanel(
        condition = "input.radio == 4", 
        sliderInput("dist_slider", "Select a distance threshold in km", 
                    min = 0, max = 25, step = 1, value = 1)
      )
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Neighbors illustration", 
                 leafletOutput("map", width = '100%', height = 800))
      )
      
      
    )))

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    map <- leaflet(atx) %>%
      addProviderTiles('CartoDB.Positron') %>%
      addPolygons(layerId = ~id, fillColor = 'transparent', 
                  color = 'blue', weight = 0.5, smoothFactor = 0.1)
    map


  })
  
  click_tract <- eventReactive(input$map_shape_click, {
    return(input$map_shape_click$id)
  })
  
  focal_tract <- reactive({
    req(click_tract())
    return(atx[atx$id == click_tract(), ])
  })
  
  # Distance-based spatial weights
  
  knn <- reactive({
    if (input$radio == 3) {
      k <- knearneigh(coordinates(atx), k = input$knn_slider, longlat = TRUE)
      return(k$nn)
    } else {
      return(NULL)
    }
  })
  
  dist <- reactive({
    if (input$radio == 4) {
      return(dnearneigh(coordinates(atx), 0, input$dist_slider, longlat = TRUE))
    } else {
      return(NULL)
    }
  })
  
  neighbors <- reactive({
    req(click_tract())
    if (input$radio == 1) {
      return(atx[atx$id %in% aq[[click_tract()]], ])
    } else if (input$radio == 2) {
      return(atx[atx$id %in% ar[[click_tract()]], ])
    } else if (input$radio == 3) {
      v <- knn()[click_tract(), ]
      return(atx[atx$id %in% v, ])
    } else if (input$radio == 4) {
      v <- dist()[[click_tract()]]
      if (v == 0) {
        return(NULL)
      } else {
        return(atx[atx$id %in% v, ])
      }
    }
  })
  
  observe({
    req(click_tract())
    proxy <- leafletProxy('map')
    if (!is.null(neighbors())) {
      proxy %>%
        removeShape('focal') %>%
        clearGroup('neighbors') %>%
        addPolygons(data = neighbors(), fill = FALSE, color = '#FFFF00',
                    group = 'neighbors', opacity = 1,weight=2) %>%
        addPolygons(data = focal_tract(), color = '#00FFFF', 
                    opacity = 1, layerId = 'focal', fillColor = 'transparent',weight=2)
    } else {
      proxy %>%
        removeShape('focal') %>%
        clearGroup('neighbors') %>%
        addPolygons(data = focal_tract(), color = '#00FFFF', 
                    opacity = 1, layerId = 'focal', fillColor = 'transparent')
    }
  })
  
  # Getis-Ord map
  
  tract_weights <- reactive({
    if (input$radio == 1) {
      return(nb2listw(include.self(poly2nb(atx2))))
    } else if (input$radio == 2) {
      return(nb2listw(include.self(poly2nb(atx2, queen = FALSE)))) 
    } else if (input$radio == 3) {
      k <- knearneigh(coordinates(atx2), k = input$knn_slider, longlat = TRUE)
      return(nb2listw(include.self(knn2nb(k))))
    } else if (input$radio == 4) {
      d <- dnearneigh(coordinates(atx2), 0, input$dist_slider, longlat = TRUE)
      return(nb2listw(include.self(d)))
    }
  })
  
  gi_data <- reactive({
    g <- localG(atx2$income, tract_weights())
    atx2$g <- g
    return(atx2)
  })
  
  output$gimap <- renderLeaflet({
    
    cols <- rev(brewer.pal(7, 'RdBu'))
    
    pal <- colorBin(palette = cols, domain = gi_data()$g, 
                    bins = c(min(gi_data()$g), -2.58, -1.96, -1.65, 
                             1.65, 1.96, 2.58, max(gi_data()$g)))
    
    popup <- paste0("<strong>Median income:</strong> $", 
                    as.character(gi_data()$income), 
                    "<br/>", 
                    "<strong>Gi* z-score:</strong> ", 
                    as.character(round(gi_data()$g, 2)))
    
    gimap <- leaflet(gi_data()) %>%
      addProviderTiles('CartoDB.Positron') %>%
      addPolygons(data = gi_data(), fillColor = ~pal(g), weight = 0.7, fillOpacity = 0.8, 
                  popup = popup, smoothFactor = 0.1, 
                  color = 'black') %>%
      addLegend(pal = pal, values = gi_data()$g, title = "Gi* z-score")
    
    
    gimap
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)



