library(dplyr)
library(ggplot2)
install.packages("shinydashboard")
library(rgeos)
library(Cairo) 
library(ggmap) 
library(rgdal)
library(scales) ; library(RColorBrewer)
install.packages("leaflet")
library(leaflet)
library(gpclib)
library(sp)
library(maptools)
library(dplyr)
#load the data
state_data <- read.csv("D:/Datasets/Indian cities/India_statistics/bharath/India state wise.csv")
state_data_1 <- read.csv("D:/Datasets/Indian cities/India state wise.csv")
#clean the data 
state_data$Name <- toupper(state_data$Name)
str(state_data)


#
write.csv(state_data,"D:/Datasets/Indian cities/statedatacleaned.csv")

#bar plot of various statistics

ggplot(aes(x = reorder(Name, -Population.millions.), y= Population.millions.), data = state_data)+
  geom_bar(stat = "identity", fill = "darkblue") + 
  theme(plot.title = element_text(size=22, hjust = 0.5),text=element_text(size=16, family="Comic Sans MS"),
        axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
  ggtitle("Population of states") +
  xlab("State") + ylab("Population in millions") +
  scale_y_continuous(breaks = seq(0, 210, 15)) + 
  geom_text(aes(label = Population.millions.), 
            position= position_dodge(width=0.9), vjust=-.5, color="darkcyan")



#chloropleth of various statistics
setwd("D:/Datasets/Indian cities/India_statistics/bharath/")
list.files()
shape<- readShapeSpatial("map.shp") 

class(shape)
plot(shape)
names(shape)
print(shape$NAME_1)
shape$NAME_1 <- toupper(shape$NAME_1)

#fortify shape file to get into dataframe 

states <- fortify(shape, region = "ID_1")
class(states)
head(states)

#merge 
merged_shape <- sp::merge(states, state_data, by = "id", all.x = TRUE)
final_plot <- merged_shape[order(merged_shape$order),]
write.csv(final_plot, "D:/Datasets/Indian cities/India_statistics/bharath/final_plot.csv")

#chloropleth plot
ggplot() +
  geom_polygon(data = final_plot, 
               aes(x = long, y = lat, group = group, fill = Population.millions.), 
               color = "black", size = 0.25) + 
  coord_map()+
  scale_fill_distiller(name="Population", palette = "YlOrRd", trans = 'reverse' , breaks = pretty_breaks(n = 5))+
  theme_nothing(legend = TRUE)+
  labs(title="Population in millions")

#read the shapefile 
shapefile<- readOGR(".", "map")
names(shapefile)
final_plot <- read.csv("final_plot.csv")

merged_shape <- sp::merge(shapefile, final_plot, by = "ID_1", all.x = TRUE, duplicateGeoms=TRUE)
str(merged_shape)
pal <- colorQuantile("RdBu", NULL, n = 6)

leaflet(data = merged_shape) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data= final_plot,fillColor = ~pal(Population.millions.), 
              fillOpacity = 1, 
              color = "darkgrey", 
              weight = 1.5)






