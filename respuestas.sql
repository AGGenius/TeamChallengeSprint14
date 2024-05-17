-- Investigación realizada por Blanca y Adrián Giner.
-- Inicio
-- Was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City.

-- 1. Buscamos inicialmente por el tipo de crimen, fecha y ciudad, para saber lo sucedido.
SELECT * FROM crime_scene_report WHERE type='murder' AND date='20180115' AND city='SQL City';

-- Respuesta
/*
ID: 20180115	
type: murder	
Data: Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".	
City: SQL City
*/

-- 2. Buscamos los datos de los testigos en la tabla de person.
SELECT *
FROM person 
WHERE address_street_name 
LIKE 'Northwestern Dr' 
ORDER BY address_number DESC
LIMIT 1;

/*
ID: 14887	
Nombre: Morty Schapiro	
license_id: 118009	
address_number: 4919	
adress_street_name: Northwestern Dr	
SSN: 111564949
*/

SELECT * 
FROM person 
WHERE name LIKE'Annabel%'
AND address_street_name = 'Franklin Ave';

/*
ID: 16371	
Nombre: Annabel Miller	
license_id: 490173	
address_number: 103	
adress_street_name: Franklin Ave
SSN: 318771143
*/

-- 3. Revisamos las entrevistas realizadas a los testigos en la tabla interview.
/*
Interviews:
---------------------------------------------------------------------------
SELECT * 
FROM interview 
WHERE person_id = 14887;

Morty Schapiro	
-->
I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
Only gold members have those bags. The man got into a car with a plate that included "H42W".

---------------------------------------------------------------------------

SELECT *
FROM interview WHERE person_id='16371'

Annabel Miller	
-->
I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

---------------------------------------------------------------------------
*/

-- 4.
/*
Facebook
---------------------------------------------------------------------------

SELECT * FROM facebook_event_checkin WHERE person_id= '16371';
Annabel Miller
-->
person_id: 16371	
event_id: 4719	
event_name: The Funky Grooves Tour	
date: 20180115

---------------------------------------------------------------------------
*/

-- Sospechosos: Tenemos pistas por las declaraciones de la entrevista a Morty Schapiro. Coincide en parte con las de Annabel Miller
SELECT *
FROM get_fit_now_member 
WHERE id LIKE '48Z%' AND membership_status = 'gold';

/*
id: 48Z7A	
person_id: 28819	
name: Joe Germuska	
membership_start_date: 20160305	
memebership_status: gold

id: 48Z55	
person_id: 67318	
name: Jeremy Bowers	
membership_start_date: 20160101	
memebership_status: gold
*/

--5. Situación de los sospechosos en el gimnaso.

SELECT *
FROM get_fit_now_check_in 
WHERE check_in_date LIKE '%0109'
AND membership_id = '48Z7A' OR membership_id = '48Z55';

/*	
membership_id: 48Z7A
check_in_date: 20180109
check_in_time: 1600
check_out_time:	1730

membership_id: 48Z55
check_in_date: 20180109
check_in_time: 1530
check_out_time:	1700			
*/

--6. Busqueda por comentario respecto a la matricula. Tres coincidentes.
SELECT * 
FROM drivers_license
WHERE plate_number LIKE '%H42W%';

/*
---------------------------------------------------------------------------
id: 183779
age: 21
height: 65
eye_color: blue
hair_color: blonde
gender: female
plate_number: H42W0X
car_make: Toyota
car_model: Prius
---------------------------------------------------------------------------
id: 423327
age: 30
height: 70
eye_color: brown
hair_color: brown
gender: male
plate_number: 0H42W2
car_make: Chevrolet
car_model: Spark LS
---------------------------------------------------------------------------
id: 664760
age: 21
height: 71
eye_color: black
hair_color: black
gender: male
plate_number: 4H42WR
car_make: Nissan
car_model: Altima
---------------------------------------------------------------------------								
*/

--7. De estos tres resultados previos el ID de la licencia de conducir coincide con la de Jeremy Bowers, que ya era sospechoso.
SELECT * 
FROM person
WHERE license_id = 423327;

/*
id: 67318
name: Jeremy Bowers
license_id: 423327
address_number: 530
address_street_name: Washington Pl, Apt 3A	
ssn: 871539279				
*/

-- Derivado. Persona que contrató a Jere,y Bowers. Por los datos de su entrevista sabemos lo siguiente:
SELECT * 
FROM interview 
WHERE person_id=67318
/*
--> I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
*/

-- Con estos datos obtenemos tres resultados en la tabla drivers_license
SELECT * 
FROM drivers_license
WHERE hair_color = 'red' AND gender = 'female' AND car_make = 'Tesla';

/*
---------------------------------------------------------------------------		
id: 202298
age: 68
height: 66
eye_color: green
hair_color: red
gender: female
plate_number: 500123
car_make: Tesla
car_model: Model S
--> 
*/
--> Se trata de:
SELECT * 
FROM person
WHERE license_id = 202298;
/*
id: 99716
name: Miranda Priestly
license_id: 202298
address_number: 1883
address_street_name: Golden Ave
ssn: 987756388				
*/
/*
---------------------------------------------------------------------------		
id: 291182
age: 68
height: 66
eye_color: blue
hair_color: red
gender: female
plate_number: 08CM64
car_make: Tesla
car_model: Model S
*/
--> Se trata de:
SELECT * 
FROM person
WHERE license_id = 291182;
/*
id: 90700
name: Regina George	
license_id: 202298
address_number: 332
address_street_name: Maple Ave
ssn: 337169072				
*/
/*
---------------------------------------------------------------------------		
id: 918773
age: 48
height: 65
eye_color: black
hair_color: red
gender: female
plate_number: 917UU3
car_make: Tesla
car_model: Model S
*/
--> Se trata de:
SELECT * 
FROM person
WHERE license_id = 918773;
/*
id: 78881
name: Red Korb	
license_id: 918773
address_number: 107
address_street_name: Camerata Dr
ssn: 961388910				
*/
---------------------------------------------------------------------------		

-- De estas tres se trata de una con mucho dinero:

-- id: 99716
-- name: Miranda Priestly	

SELECT * 
FROM income
WHERE ssn = 987756388;
/*
ssn: 987756388
annual_income: 310000
*/
---------------------------------------------------------------------------	
-- id: 90700
--name: Regina George	

SELECT * 
FROM income
WHERE ssn = 337169072;
/*
No data returned.
*/
---------------------------------------------------------------------------	
-- id: 78881
-- name: Red Korb	

SELECT * 
FROM income
WHERE ssn = 961388910;
/*
ssn: 961388910
annual_income: 278000
*/
---------------------------------------------------------------------------	
/* SOLUCION         SOLUCION         SOLUCION         SOLUCION         SOLUCION         SOLUCION         SOLUCION         SOLUCION         SOLUCION -->
De todos estos datos, la que mas coincidencias da es:
    id: 99716
    name: Miranda Priestly	
Que parece ser que pago a: 
    id: 67318
    name: Jeremy Bowers
---------------------------------------------------------------------------	
El asesino a resultado ser: Jeremy Bowers
*/
INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;
/*
Pero nos pedia ir mas allá, y con ello descubrimos que todo fue orquestado por: Miranda Priestly.
*/
INSERT INTO solution VALUES (1, 'Miranda Priestly');
        
        SELECT value FROM solution;
