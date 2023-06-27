--CLEANING DATA IN SQL
Select *
From HousingData

--STANDARDIZE DATE FORMAT
Select SaleDate, convert(date,SaleDate)
From HousingData

 ALTER TABLE HousingData
 add SalesDateConvert date

update HousingData
set SalesDateConvert = convert(date,SaleDate)

--or Alter Table HousingDate Set SaleDateConverted = convert(date,SaleDate)


--POPULATE PROPERTY ADDRESS
Select PropertyAddress
From HousingData
Where PropertyAddress is null

Select *
From HousingData
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingData a
join HousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingData a
join HousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--we can populate with a string
--update a
--set PropertyAddress = ISNULL(a.PropertyAddress,'No Address')
--From HousingData a
--join HousingData b
--	on a.ParcelID = b.ParcelID
--	and a.[UniqueID ] <> b.[UniqueID ]
--where a.PropertyAddress is null

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)
--Property Address using Substring
Select PropertyAddress
From HousingData
--Where PropertyAddress is null

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) Address

From HousingData

Alter Table HousingData
Add PropertysplitAddress nvarchar(255)

Update HousingData
Set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table HousingData
Add PropertysplitCity nvarchar(255)

update HousingData
Set PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))


select *
From HousingData

--Owner Address using Parsename
select OwnerAddress
From HousingData

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.' ) ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From HousingData
 
 Alter Table HousingData
Add OwnersplitAddress nvarchar(255)

Update HousingData
Set OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.' ) ,3)

Alter Table HousingData
Add OwnersplitCity nvarchar(255)

update HousingData
Set OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

 Alter Table HousingData
Add OwnersplitState nvarchar(255)

Update HousingData
Set OwnersplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


select *
From HousingData

--CHANGE Y AND N TO TO YES AND NO IN 'SOLD AS VACANT' FIELD USING CASE STATEMENT
select distinct(SoldAsVacant)
From HousingData

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
From HousingData
group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From HousingData

UPDATE HousingData
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


--REMOVING DUPLICATES USING CTE'S AND WINDOWS FUNCTIONS

WITH RowNumCTE as (
select *,
	ROW_NUMBER() over(
	Partition by
	ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	Order by UniqueID) row_num
From HousingData
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

WITH RowNumCTE as (
select *,
	ROW_NUMBER() over(
	Partition by
	ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	Order by UniqueID) row_num
From HousingData
--order by ParcelID
)
delete
from RowNumCTE
where row_num > 1

--DELETING UNSED COLUMNS USING

SELECT *
FROM HousingData

ALTER TABLE HousingData
drop column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE HousingData
drop column SaleDate