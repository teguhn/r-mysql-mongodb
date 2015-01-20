# r-mysql-mongodb
Connecting MySQL and MongoDB in R

* MySQL : test.us500.sql
Adalah data yang terdiri atas 500 orang di US dengan 10 kolom: id, first_name, last_name, company_name, address, zip, phone1, phone2, email, web

* MongoDB : zips.json
Adalah data yang terdiri atas 88293 kota di US yang seluruh dokumennya memiliki fields: _id (zipcode), city, loc, pop, state

##Replikasi:
1. Import data MySQL : source test.us500.sql
SQL tersebut akan membuat database 'test' dan tabel 'us500' serta memasukkan datanya

1. Import data MongoDB : mongoimport --db test --collection zips --file zips.json

1. Buka script merge-us500-zips.R di R IDE, lalu jalankan. Pada script tersebut, Anda bisa menyesuaikan beberapa variabel sesuai dengan koneksi MySQL dan MongoDB Anda. Hasilnya adalah data frame 'us500.merged' yang berisi data 'us500' dengan tambahan kolom 'city', dan 'state'.