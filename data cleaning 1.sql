select * from housing;


--- Standadize Date Format

select saledate_converted, convert(date,saledate) from housing;


alter table housing
add saledate_converted date;

update housing
set saledate_converted = convert(date, saledate);


---  Populate Property Address data

select *
from housing
where propertyaddress is null
order by parcelid;

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from housing a
inner join housing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null;


update a
set propertyaddress =  isnull(a.propertyaddress, b.propertyaddress)
from housing a
inner join housing b
on a.parcelid = b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null;



---  Breaking Out PropertyAddress in Individual Columns (Address, City, State)


select Propertyaddress from housing;

select SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress, charindex(',',propertyaddress)+1, len(propertyaddress)) as city
from housing;


alter table housing
add address varchar(100);

update housing 
set address = SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress)-1);

alter table housing
add city varchar(50);

update housing 
set city = SUBSTRING(propertyaddress, charindex(',',propertyaddress)+1, len(propertyaddress));

select
PARSENAME(replace(owneraddress, ',','.'),3) as 'address',
PARSENAME(replace(owneraddress, ',','.'),2)as 'city',
PARSENAME(replace(owneraddress, ',','.'),1) as 'state'
from housing;


alter table housing
add owner_address varchar(100);

update housing
set owner_address = PARSENAME(replace(owneraddress, ',','.'),3);


alter table housing
add owner_city varchar(50);

update housing
set owner_city = PARSENAME(replace(owneraddress, ',','.'),2);


alter table housing
add owner_state varchar(10);

update housing
set owner_state = PARSENAME(replace(owneraddress, ',','.'),1);


--- Change Y and N to Yes and No in 'SoldAsVacant' column

select distinct(soldasvacant), count(soldasvacant)
from housing
group by soldasvacant
order by count(soldasvacant) desc;


select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end
	 from housing;


update Housing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
	 else soldasvacant
	 end;


---   Removing Duplicates


with rownumCTE as (
select *,
 ROW_NUMBER() over (
 partition by parcelid,
              propertyaddress,
			  saleprice,
			  saledate,
			  legalreference
			  order by
			        uniqueid
					) as row_num
from housing
)
delete from rownumCTE
where row_num > 1;




---- Delete Unused Columns


alter table housing
drop column propertyaddress, owneraddress, taxdistrict, saledate;

select * from Housing;