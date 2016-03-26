library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
      
      library(data.table)
      library(ggplot2)
      library(ggmap)
      library(dplyr)
      library(lubridate)
      library(RColorBrewer)
      
      train <- fread("train.csv")
      
      #Change cols to factors (more convenient for ggplot)
      train$date <- ymd_hms(train$Dates)
      train$year <- year(train$date)
      train$year <- as.factor(train$year)
      train$Category <- as.factor(train$Category)
      train$Descript <- as.factor(train$Descript)
      train$DayOfWeek <- as.factor(train$DayOfWeek)
      train$PdDistrict <- as.factor(train$PdDistrict)
      train$Resolution <- as.factor(train$Resolution)
      
      names(train)[8:9] <- c("lon", "lat")
      
      cat_distr <- as.data.frame(table(train$Category, train$PdDistrict))
      names(cat_distr) <- c("category", "district", "freq")
      cat_distr = as.data.table(cat_distr)
      distr_summ <- cat_distr[,sum(freq), by = district]
      names(distr_summ)[2] <- "sum"
      
      #cat_total <- train %>% group_by(Category) %>% summarise(n())
      #names(cat_total)[2] <- "sum"
      
      richmond <- train[train$PdDistrict == "RICHMOND"]
      southern <- train[train$PdDistrict == "SOUTHERN"]
      
      southern_resolution <- as.data.frame(table(southern$Resolution, southern$Category))
      richmond_resolution <- as.data.frame(table(richmond$Resolution, richmond$Category))
      names(southern_resolution) <- c("resolution", "category", "freq")
      names(richmond_resolution) <- c("resolution", "category", "freq")
      southern_resolution <- as.data.table(southern_resolution)
      richmond_resolution <- as.data.table(richmond_resolution)
      richmond_sum_by_cat <- richmond_resolution[,sum(freq), by = category]
      southern_sum_by_cat <- southern_resolution[,sum(freq), by = category]
      names(southern_sum_by_cat)[2] <- "sum"
      names(richmond_sum_by_cat)[2] <- "sum"
      southern_sum_by_cat <- arrange(southern_sum_by_cat, desc(sum))
      southern_sum_by_cat$category <- factor(southern_sum_by_cat$category,
                                             levels = as.character(southern_sum_by_cat$category))
      richmond_sum_by_cat <- arrange(richmond_sum_by_cat, desc(sum))
      richmond_sum_by_cat$category <- factor(richmond_sum_by_cat$category,
                                             levels = as.character(richmond_sum_by_cat$category))
      richmond_outcome <- richmond_resolution %>% group_by(resolution) %>% summarise(sum(freq))
      southern_outcome <- southern_resolution %>% group_by(resolution) %>% summarise(sum(freq))
      names(richmond_outcome)[2] <- "sum"
      names(southern_outcome)[2] <- "sum"
      
      cols <- colorRampPalette(c("gold", "blue"))
      qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
      col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
      
      train$hour <- hour(train$Dates)
      #count_by_hour_distr <- train[,.N, by = .(hour,PdDistrict)]
      
      map <- get_map(location = "San Francisco", zoom = 13, 
                     maptype = "roadmap", source = "osm")
      
      #OUTPUTS
      output$resolution_bar <- renderPlot({input$execute
            isolate(ggplot(as.data.frame(table(train$Resolution[(train$PdDistrict == input$district)&(train$year == input$year)], train$Category[(train$PdDistrict == input$district)&(train$year == input$year)])), 
                                         aes(reorder(Var2, -Freq), Freq, group = Var1)) + 
                  geom_bar(stat = "identity", aes(fill = Var1)) + 
                  coord_flip() + 
                  ylab("Sum") + 
                  xlab("Crime category") + 
                  ggtitle(paste("Top crime categories by resolution in the", 
                                paste(toupper(substr(input$district, 1, 1)), 
                                      tolower(substr(input$district, 2, nchar(input$district))), sep = ""),
                                "district in year", as.character(input$year))) + 
                  theme(title = element_text(size = 18), 
                        plot.title = element_text(face = "bold")) + 
                  scale_fill_manual(values = col_vector, name = "Resolution"))})
                  
      
      output$year_density <- renderPlot({input$execute
            isolate(ggmap(map) %+% train[((train$year == input$year)&(train$PdDistrict == input$district)),] + aes(x = lon, y = lat) + geom_density2d() + stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                                  bins = 20,
                                  geom = "polygon") + 
            scale_fill_gradient(low = "green", high = "red", "Crime\ndensity") + 
                  scale_alpha(range = c(0, 0.5), guide = FALSE) +
                  xlab("Longitude") + 
                  ylab("Latitude") +
                  theme(title = element_text(size = 18), 
                        plot.title = element_text(face = "bold")) +
                  ggtitle(paste("Crime density in the", 
                                paste(toupper(substr(input$district, 1, 1)), 
                                      tolower(substr(input$district, 2, nchar(input$district))), sep = ""),
                                "district in year", as.character(input$year))))})
      
      output$top_categories <- renderPlot({input$execute
            isolate(ggplot(train[train$year == input$year, .N, by = Category], aes(reorder(Category, -N), N)) + 
                  geom_bar(stat = "identity", 
                           fill = cols(nrow(train[train$year == input$year, .N, by = Category])), 
                           col = "black") + coord_flip() + 
                  ylab("Sum of crimes") + 
                  xlab("Crime category") + 
                  ggtitle(paste("Top crime categories in year", as.character(input$year), "in all districts")) + 
                  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
                        title = element_text(size = 18), 
                        plot.title = element_text(face = "bold")))})
      
      output$hourly_reports <- renderPlot({input$execute
            isolate(
                  ggplot(arrange(train[train$DayOfWeek == input$weekday,.N, by = .(hour,PdDistrict)], PdDistrict), 
                         aes(x = as.factor(hour), y = N, fill = PdDistrict)) + 
                        geom_bar(stat = "identity") + 
                        xlab("Hour") + 
                        ylab("Reports") + 
                        ggtitle(paste("Number of reports by hour for ", input$weekday, "s", sep = "")) + 
                        theme(axis.text.x = element_text(angle = 45, hjust = 1), 
                              title = element_text(size = 18), 
                              plot.title = element_text(face = "bold")) + 
                        scale_fill_discrete("District")
            )
      })
      output$nitty <- renderUI({
            str1 <- h3(strong("Data was obtained from Kaggle:"))
            str2 <- h4(a("Link", href="https://www.kaggle.com/c/sf-crime"))
            str3 <- h4("Since the application initially needs to load and process a 
                       dataset of dimensions 878049 rows by 11 columns, therefore it takes a long time
                       to load.")
            str4 <- h3(strong("Processing"))
            str5 <- h4("Data is processed as follows: columns are changed to appropriate data types,
                       3 new columns are addded and finally graphs are made based on processed data.")
            str6 <- h4("To find out more about data processing, visit my GitHub page:")
            str7 <- h4(a("Link", href = "https://github.com/rabbit140/developing_data_products"))
            HTML(paste(str1, str2, str3, str4, str5, str6, str7, sep = '<br/>'))
            }
      )

})