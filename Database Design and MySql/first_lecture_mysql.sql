create database market_star_schema;

use market_star_schema;

create table shipping_mode_dimen (
	Ship_Mode varchar(25),
    Vehicle_Company varchar(25),
    Toll_Required boolean
);

alter table shipping_mode_dimen add constraint primary key (Ship_Mode);

create table India (Matches_played int, Matched_won int, Matches_lost int, Net_run_rate DECIMAL(4,3), Points int);

insert into shipping_mode_dimen values
	('DELIVERY TRUCK','ASHOK LEYLAND', false),
    ('REGULAR AIR', 'Air India', false);
    
insert into shipping_mode_dimen (Ship_mode, Vehicle_Company, Toll_Required) 
values
	('Boat','Vizag Port',false);
    
update shipping_mode_dimen 
set Toll_Required=true 
where Ship_Mode='DELIVERY TRUCK';

delete 
from shipping_mode_dimen
where Vehicle_Company = 'Air India';

alter table shipping_mode_dimen
add Vehicle_Number varchar(15);

update shipping_mode_dimen 
set Vehicle_Number='MH-09-1234'
Where Ship_Mode='DELIVERY TRUCK';

alter table shipping_mode_dimen
change Toll_Required Toll_Amount int;

drop table shipping_mode_dimen;

select Ship_Mode, Vehicle_Company, concat(Ship_Mode,' ',Vehicle_Company) as Complete_Name from shipping_mode_dimen;