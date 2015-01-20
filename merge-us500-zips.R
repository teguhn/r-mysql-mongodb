if(!require('rmongodb')){
  install.packages('rmongodb')
  require('rmongodb')
}
if(!require('RMySQL')){
  install.packages('RMySQL')
  require('RMySQL')
}
if(!require('data.table')){
  install.packages('data.table')
  require('data.table')
}

#Connecting to mongodb
mongo.host <- '127.0.0.1'
mongo.username <- ''
mongo.password <- ''
mongo.db <- 'test'
mongo.coll <- 'test.zips'
mongo <- mongo.create(host=mongo.host, username=mongo.username, password=mongo.password, db=mongo.db)
if(!mongo.is.connected(mongo)){
  mongo.get.err(mongo)
  stop("mongodb is not connected")
}

#Connecting to mysql
mysql.host <- '127.0.0.1'
mysql.user <- 'root'
mysql.password <- ''
mysql.db <- 'test'
mysql.limit <- 500
mysql <- dbConnect(MySQL(), host=mysql.host, user=mysql.user, password=mysql.password, db=mysql.db)

#loading us500 data from mysql
us500.df <- dbGetQuery(mysql, paste('SELECT * FROM `us500` LIMIT ', mysql.limit))

##explain us500.df dataset
str(us500.df)
head(us500.df)

#loading zips data from mongodb
zip.list <- dbGetQuery(mysql, paste('SELECT DISTINCT `zip` FROM `us500` LIMIT ', mysql.limit));
query <- list('_id'=list('$in'=as.character(zip.list$zip)))
query.bson <- mongo.bson.from.list(query)
fields.bson = mongo.bson.from.list(list(city=1L, state=1L, id=1L))
res <- mongo.find.all(mongo, mongo.coll, fields=fields.bson, query=query.bson)
zips.df <- data.frame(matrix(unlist(res), ncol=3, byrow=T))
colnames(zips.df) <- c('zip','city', 'state')

##explain zips.df dataset
str(zips.df)
head(zips.df)

#merging us500 with zips, faster using data.table and key
us500.df$zip <- as.factor(us500.df$zip)
zips.dt<-data.table(zips.df,  key='zip') 
us500.dt<-data.table(us500.df, key='zip')
us500.merged <- merge(us500.dt, zips.dt, all.x=T, by='zip')[order(id)]

##explain us500.merged dataset
str(us500.merged)
head(us500.merged)

dbDisconnect(mysql)
mongo.destroy(mongo)