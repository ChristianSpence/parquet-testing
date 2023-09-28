# gives us an object binding that we can query against
rgva_parquet <- arrow::read_parquet("https://github.com/economic-analytics/edd/blob/main/data/parquet/RGVA.parquet?raw=true", as_data_frame = FALSE)

# downloads the object and loads all data into memory
rgva_df <- arrow::read_parquet("https://github.com/economic-analytics/edd/blob/main/data/parquet/RGVA.parquet?raw=true")

# we can also read from a single CSV (just the binding)
lms_csv <- arrow::read_csv_arrow("https://raw.githubusercontent.com/economic-analytics/edd/main/data/csv/LMS_data.csv", as_data_frame = F)

# or pull all the data into memory
lms_csv_df <- arrow::read_csv_arrow("https://raw.githubusercontent.com/economic-analytics/edd/main/data/csv/LMS_data.csv")

# we can also query via duckdb
# BUT for now, we can't as there's an issue with the latest release

dataset <- "https://static.data.gouv.fr/resources/bureaux-de-vote-et-adresses-de-leurs-electeurs/20230626-135723/table-adresses-reu.parquet"

con = DBI::dbConnect(duckdb::duckdb())

# To do once:
# DBI::dbExecute(cnx, "INSTALL httpfs")
DBI::dbExecute(cnx, "LOAD httpfs")

DBI::dbSendQuery(cnx, glue("
  CREATE VIEW bureaux AS
    SELECT *
    FROM '{dataset}'"))

bureaux <- dplyr::tbl(cnx, "bureaux")

con = duckdb::dbConnect(duckdb::duckdb(), "https://github.com/economic-analytics/edd/blob/main/data/parquet/RGVA.parquet?raw=true")
sql <- "(SELECT * FROM read_parquet('https://raw.githubusercontent.com/RobinL/iris_parquet/main/iris.parquet'))"
DBI::dbGetQuery(con, sql)

