library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
nc_data <- nc_open('D:/Python&R _My codes/R_NCDF Reading/Temperature_Air_2m_Max_24h_ERA5_daily_1991-2021.nc')
print(nc_data)
dname <- "Temperature_Air_2m_Max_24h"
lon <- ncvar_get(nc_data, "lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(nc_data, "lat")
nlat <- dim(lat)
head(lat)
print(c(nlon, nlat))
t <- ncvar_get(nc_data, "time")
tunits <- ncatt_get(nc_data, "time", "units")
nt <- dim(t)
tmp.array <- ncvar_get(nc_data, dname)

dlname <- ncatt_get(nc_data, dname, "long_name")
dunits <- ncatt_get(nc_data, dname, "units")

fillvalue <- ncatt_get(nc_data, dname, "_FillValue")
dim(tmp.array)

title <- ncatt_get(nc_data, 0, "title")
institution <- ncatt_get(nc_data, 0, "institution")
datasource <- ncatt_get(nc_data, 0, "source")
references <- ncatt_get(nc_data, 0, "references")
history <- ncatt_get(nc_data, 0, "history")
Conventions <- ncatt_get(nc_data, 0, "Conventions")

# split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth = as.integer(unlist(tdstr)[2])
tday = as.integer(unlist(tdstr)[3])
tyear = as.integer(unlist(tdstr)[1])
chron::chron(t, origin = c(tmonth, tday, tyear))
tmp.array[tmp.array == fillvalue$value] <- NA
length(na.omit(as.vector(tmp.array[, , 1])))
m <- 1
tmp.slice <- tmp.array[, , m]
lonlat <- expand.grid(lon, lat)
tmp.vec <- as.vector(tmp.slice)
length(tmp.vec)
tmp.df01 <- data.frame(cbind(lonlat, tmp.vec))
names(tmp.df01) <- c("lon", "lat", paste(dname, as.character(m), sep = "_"))
head(na.omit(tmp.df01), 20)
csvfile <- "cru_tmp_2.csv"
write.table(na.omit(tmp.df01), csvfile, row.names = FALSE, sep = ",")
tmp.vec.long <- as.vector(tmp.array)
length(tmp.vec.long)
tmp.mat <- matrix(tmp.vec.long, nrow = nlon * nlat, ncol = nt)
dim(tmp.mat)
head(na.omit(tmp.mat))

# create a dataframe
lonlat <- expand.grid(lon, lat)
tmp.df02 <- data.frame(cbind(lonlat, tmp.mat))
options(width = 110)
head(na.omit(tmp.df02, 20))
csvfile <- "cru_tmp_3.csv"
write.table(na.omit(tmp.df02), csvfile, row.names = FALSE, sep = ",")