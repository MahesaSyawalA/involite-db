-- create table user
CREATE TABLE USERS (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    businessId INT,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phoneNumber VARCHAR(15) NOT NULL,
    role ENUM('owner','akuntan','gudang','sales') NOT NULL,
)

-- insert data 
INSERT INTO USERS 
(businessId, firstName, lastName, email, phoneNumber, role)
VALUES
(1,'Andi','Saputra','andi.saputra@mail.com','081234567801','owner'),
(1,'Budi','Santoso','budi.santoso@mail.com','081234567802','akuntan'),
(1,'Citra','Lestari','citra.lestari@mail.com','081234567803','sales'),
(1,'Deni','Pratama','deni.pratama@mail.com','081234567804','gudang'),

(2,'Eka','Putri','eka.putri@mail.com','081234567805','owner'),
(2,'Fajar','Hidayat','fajar.hidayat@mail.com','081234567806','akuntan'),
(2,'Gita','Permata','gita.permata@mail.com','081234567807','sales'),
(2,'Hadi','Wijaya','hadi.wijaya@mail.com','081234567808','gudang'),

(3,'Indah','Sari','indah.sari@mail.com','081234567809','owner'),
(3,'Joko','Susilo','joko.susilo@mail.com','081234567810','akuntan'),
(3,'Kiki','Amelia','kiki.amelia@mail.com','081234567811','sales'),
(3,'Lukman','Hakim','lukman.hakim@mail.com','081234567812','gudang'),

(4,'Maya','Anggraini','maya.anggraini@mail.com','081234567813','owner'),
(4,'Nanda','Prakoso','nanda.prakoso@mail.com','081234567814','akuntan'),
(4,'Oki','Ramadhan','oki.ramadhan@mail.com','081234567815','sales'),
(4,'Putra','Firmansyah','putra.firmansyah@mail.com','081234567816','gudang'),

(5,'Qori','Aulia','qori.aulia@mail.com','081234567817','owner'),
(5,'Rizki','Maulana','rizki.maulana@mail.com','081234567818','akuntan'),
(5,'Salsa','Nabila','salsa.nabila@mail.com','081234567819','sales'),
(5,'Teguh','Purnomo','teguh.purnomo@mail.com','081234567820','gudang'),

(6,'Umar','Fauzi','umar.fauzi@mail.com','081234567821','owner'),
(6,'Vina','Oktaviani','vina.oktaviani@mail.com','081234567822','akuntan'),
(6,'Wahyu','Kurniawan','wahyu.kurniawan@mail.com','081234567823','sales'),
(6,'Xena','Putri','xena.putri@mail.com','08123



